import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';
import 'package:uuid/uuid.dart';

import '../../../core/dependency_injection.dart';
import '../../../core/utils/log.dart';
import '../model/candy.dart';
import '../model/history.dart';
import '../model/shopping_item.dart';
import '../model/sweet_notification.dart';
import '../repository/repository.dart';
import '../repository/history_repository.dart';
import '../repository/shop_repository.dart';

part 'candy_event.dart';
part 'candy_state.dart';

class CandyBloc extends Bloc<CandyEvent, CandyState> {
  final CandyRepository _candyRepository = locator<CandyRepository>();
  final ShoppingItemRepository _shoppingRepository =
      locator<ShoppingItemRepository>();
  final UsageHistoryRepository _historyRepository =
      locator<UsageHistoryRepository>();

  List<Candy> _allCandies = [];
  List<ShoppingItem> _shoppingList = [];
  List<UsageHistoryRecord> _historyList = [];
  Map<String, int> _pendingPeriodicUsage = {};
  List<SweetNotification> _notifications = [];

  CandyBloc() : super(CandyInitial()) {
    on<LoadCandy>(_onLoadCandy);
    on<UpdateCandy>(_onUpdateCandy);
    on<SaveCandy>(_onSaveCandy);
    on<RemoveCandy>(_onRemoveCandy);

    // Периодические события
    on<CheckPeriodicity>(_onCheckPeriodicity);
    on<ConfirmPeriodicUsage>(_onConfirmPeriodicUsage);
    on<CancelPeriodicUsage>(_onCancelPeriodicUsage);

    // Список покупок
    on<AddToShoppingList>(_onAddToShoppingList);
    on<RemoveFromShoppingList>(_onRemoveFromShoppingList);
    on<ClearShoppingList>(_onClearShoppingList);
    on<BuyFromShoppingList>(_onBuyFromShoppingList);
    on<CheckoutShoppingList>(_onCheckoutShoppingList);

    // Удаление уведомлений
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onLoadCandy(
    LoadCandy event,
    Emitter<CandyState> emit,
  ) async {
    emit(CandyLoading());
    try {
      final candies = await _candyRepository.load();
      _allCandies = candies;

      _shoppingList = await _shoppingRepository.load();
      _historyList = await _historyRepository.load();
      
      // Генерируем уведомления ОДИН раз при загрузке
 if (_notifications.isEmpty) {
      _generateNotifications();}

      // После этого вызова _notifications будет хранить все уведомления для сессии
      // В дальнейшем не вызываем снова add(LoadCandy()) для обновления уведомлений,
      // а просто emit(...) новые стейты при изменениях.

      emit(CandyLoaded(
        candies: _allCandies,
        shoppingList: _shoppingList,
        pendingPeriodicUsage: _pendingPeriodicUsage,
        historyList: _historyList,
        notifications: _notifications,
      ));

      // Запускаем проверку периодичности один раз
      add(CheckPeriodicity());

    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to load candy'));
    }
  }

  // Метод для однократной генерации уведомлений
  void _generateNotifications() {
    final now = DateTime.now();

    // Уведомления о сроке годности
    for (var candy in _allCandies) {
      if (candy.expirationDate != null) {
        final diff = candy.expirationDate!.difference(now).inDays;
        if (diff == 1) {
          _notifications.add(
            SweetNotification(
              id: const Uuid().v4(),
              isRead: false,
              image: candy.imageUrl,
              type: candy.type,
              date: now,
              sweetName: candy.name,
              message: 'Candy "${candy.name}" will expire in 1 day!',
            ),
          );
        }
        if (candy.expirationDate!.isBefore(now)) {
          _notifications.add(
            SweetNotification(
              id: const Uuid().v4(),
              isRead: false,
              image: candy.imageUrl,
              type: candy.type,
              date: now,
              sweetName: candy.name,
              message: 'Candy "${candy.name}" is expired!',
            ),
          );
        }
      }
    }
  }

  Future<void> _onUpdateCandy(
    UpdateCandy event,
    Emitter<CandyState> emit,
  ) async {
    try {
      final index = _allCandies.indexWhere((c) => c.id == event.candy.id);
      if (index != -1) {
        _allCandies[index] = event.candy;
        final record = UsageHistoryRecord(
          id: const Uuid().v4(),
          date: DateTime.now(),
          category: event.candy.category,
          sweetName: event.candy.name,
          usedQuantity: event.candy.quantity,
        );
        await _historyRepository.addRecord(record);
        _historyList.add(record);
      }

      await _candyRepository.update(event.candy);

      // Вместо add(LoadCandy()) просто обновляем состояние
      emit(CandyLoaded(
        candies: _allCandies,
        shoppingList: _shoppingList,
        pendingPeriodicUsage: _pendingPeriodicUsage,
        historyList: _historyList,
        notifications: _notifications,
      ));

    } catch (e) {
      emit(const CandyError('Failed to update candy'));
    }
  }

  Future<void> _onSaveCandy(
    SaveCandy event,
    Emitter<CandyState> emit,
  ) async {
    try {
      logger.d(event);
      await _candyRepository.save(event.candy);

      // Добавляем новую конфету
      _allCandies.add(event.candy);

      // Обновляем состояние напрямую
      add(LoadCandy());
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to save candy'));
    }
  }

  Future<void> _onRemoveCandy(
    RemoveCandy event,
    Emitter<CandyState> emit,
  ) async {
    try {
      await _candyRepository.remove(event.candy);
      _allCandies.removeWhere((c) => c.id == event.candy.id);

      add(LoadCandy());
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to remove candy'));
    }
  }

  Future<void> _onCheckPeriodicity(
    CheckPeriodicity event,
    Emitter<CandyState> emit,
  ) async {
    _pendingPeriodicUsage.clear();
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday

    for (var candy in _allCandies) {
      if (candy.isPeriodic &&
          candy.periodicityDays != null &&
          candy.periodicityDays!.isNotEmpty &&
          candy.periodicityCount != null) {
        final days = candy.periodicityDays!;
        final index = candy.currentPeriodicIndex ?? 0;
        if (currentWeekday == days[index]) {
          if (candy.quantity > 0) {
            final countToUse = candy.quantity >= candy.periodicityCount!
                ? candy.periodicityCount!
                : candy.quantity;

            candy.currentPeriodicIndex =
                (candy.currentPeriodicIndex! + 1) % days.length;
            await _candyRepository.update(candy.copyWith(
                currentPeriodicIndex: candy.currentPeriodicIndex));

            if (countToUse > 0) {
              _pendingPeriodicUsage[candy.id] = countToUse;
            }
          } else {
            // Нет в наличии, генерируем уведомление, если еще не генерировали
            final notif = SweetNotification(
              id: const Uuid().v4(),
              image: candy.imageUrl,
              isRead: false,
              type: candy.type,
              date: now,
              sweetName: candy.name,
              message: 'Candy "${candy.name}" is out of stock!',
            );
            // Добавляем только один раз
            if (!_notifications.any((n) => n.message == notif.message)) {
              _notifications.add(notif);
            }
          }
        }
      }
    }

    // Если есть конфеты на подтверждение списания, добавим уведомление (один раз)
    if (_pendingPeriodicUsage.isNotEmpty) {
      final notifMessage = 'You have periodic usage to confirm.';
      if (!_notifications.any((n) => n.message == notifMessage)) {
        _notifications.add(SweetNotification(
          id: const Uuid().v4(),
          image: '',
          type: SweetType.caramel,
          isRead: false,
          date: now,
          sweetName: '',
          message: notifMessage,
        ));
      }
    }

    // Обновляем состояние без перезагрузки
    emit(CandyLoaded(
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      historyList: _historyList,
      notifications: _notifications,
    ));
  }

  Future<void> _onConfirmPeriodicUsage(
    ConfirmPeriodicUsage event,
    Emitter<CandyState> emit,
  ) async {
    final candyId = event.candyId;
    final countToUse = _pendingPeriodicUsage[candyId];
    if (countToUse != null && countToUse > 0) {
      final index = _allCandies.indexWhere((c) => c.id == candyId);
      if (index != -1) {
        final candy = _allCandies[index];
        final updatedCandy = candy.copyWith(
          quantity: candy.quantity - countToUse,
        );

        try {
          await _candyRepository.update(updatedCandy);
        } catch (e) {
          emit(const CandyError('Failed to confirm periodic usage'));
          return;
        }

        _allCandies[index] = updatedCandy;
        _pendingPeriodicUsage.remove(candyId);

        final record = UsageHistoryRecord(
          id: const Uuid().v4(),
          date: DateTime.now(),
          category: candy.category,
          sweetName: candy.name,
          usedQuantity: countToUse,
        );

        try {
          await _historyRepository.addRecord(record);
          _historyList.add(record);
        } catch (e) {
          logger.e(e);
          emit(const CandyError('Failed to add usage history record'));
          return;
        }

        // Если конфета постоянная и количество 0, добавляем в корзину и уведомляем
        if (updatedCandy.isPermanent && updatedCandy.quantity == 0) {
          final shopItem = ShoppingItem(
            id: const Uuid().v4(),
            candy: updatedCandy,
          );
          _shoppingList.add(shopItem);
          await _shoppingRepository.save(shopItem);

          final notifMessage =
              'Candy "${updatedCandy.name}" is out of stock. Added to shopping list!';
          if (!_notifications.any((n) => n.message == notifMessage)) {
            _notifications.add(
              SweetNotification(
                id: const Uuid().v4(),
                date: DateTime.now(),
                isRead: false,
                type: updatedCandy.type,
                image: updatedCandy.imageUrl,
                sweetName: updatedCandy.name,
                message: notifMessage,
              ),
            );
          }
        }

        // Обновляем состояние напрямую, без LoadCandy()
       add(LoadCandy());
      }
    }
  }

  void _onCancelPeriodicUsage(
    CancelPeriodicUsage event,
    Emitter<CandyState> emit,
  ) {
    _pendingPeriodicUsage.remove(event.candyId);
    add(LoadCandy());
  }

  Future<void> _onAddToShoppingList(
    AddToShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    final item = ShoppingItem(
      id: event.id,
      candy: event.candy,
    );
    _shoppingList.add(item);

    try {
      await _shoppingRepository.save(item);
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to add to shopping list'));
      return;
    }

    // Обновляем состояние напрямую
   add(LoadCandy());
  }

  Future<void> _onRemoveFromShoppingList(
    RemoveFromShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    _shoppingList.removeWhere((i) => i.id == event.item.id);
    try {
      await _shoppingRepository.remove(event.item);
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to remove from shopping list'));
      return;
    }

   add(LoadCandy());
  }

  Future<void> _onClearShoppingList(
    ClearShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    _shoppingList.clear();
    try {
      await _shoppingRepository.clear();
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to clear shopping list'));
      return;
    }

   add(LoadCandy());
  }

  Future<void> _onCheckoutShoppingList(
    CheckoutShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    logger.d("Checkout shopping list: $_shoppingList");
    // Ничего не меняем, просто эмитим текущее состояние
   add(LoadCandy());
  }

  Future<void> _onBuyFromShoppingList(
    BuyFromShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    final item = event.item;
    _shoppingList.removeWhere((i) => i.id == item.id);
    try {
      await _shoppingRepository.remove(item);
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to remove from shopping list'));
      return;
    }

    final candyIndex = _allCandies.indexWhere((c) => c.id == item.candy.id);
    if (candyIndex != -1) {
      final updatedCandy = _allCandies[candyIndex].copyWith(
        quantity: _allCandies[candyIndex].quantity + item.candy.quantity,
      );
      _allCandies[candyIndex] = updatedCandy;
      await _candyRepository.update(updatedCandy);
    } else {
      _allCandies.add(item.candy);
      await _candyRepository.save(item.candy);
    }

   add(LoadCandy());
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<CandyState> emit,
  ) async {
    // Удаляем уведомление из текущего списка, не вызываем LoadCandy()
    _notifications.removeWhere((n) => n.id == event.notification.id);

    // Обновляем состояние напрямую
   add(LoadCandy());
  }
}
