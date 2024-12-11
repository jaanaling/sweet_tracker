import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  // Локальные хранилища
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
      _notifications.clear();

      // Проверяем, есть ли конфеты с истекающим сроком годности (1 день до конца)
      final now = DateTime.now();
      for (var candy in _allCandies) {
        if (candy.expirationDate != null) {
          final diff = candy.expirationDate!.difference(now).inDays;
          if (diff == 1) {
            _notifications.add(
              SweetNotification(
                id: const Uuid().v4(),
                date: now,
                sweetName: candy.name,
                message: 'Candy "${candy.name}" will expire in 1 day!',
              ),
            );
          }
        }
      }

      // Проверяем, есть ли конфеты с просроченным сроком годности
      for (var candy in _allCandies) {
        if (candy.expirationDate != null &&
            candy.expirationDate!.isBefore(now)) {
          _notifications.add(
            SweetNotification(
              id: const Uuid().v4(),
              date: now,
              sweetName: candy.name,
              message: 'Candy "${candy.name}" is expired!',
            ),
          );
        }
      }

      logger.d(_notifications);

      // Если после загрузки есть неподтверждённое периодическое списание, тоже уведомим.
      // Но после загрузки мы только что очистили pending, поэтому ничего нет.
      // Логику проверки pendingPeriodicUsage оставим в _onCheckPeriodicity.

      add(CheckPeriodicity());

      emit(CandyLoaded(
        candies: _allCandies,
        shoppingList: _shoppingList,
        pendingPeriodicUsage: _pendingPeriodicUsage,
        historyList: _historyList,
        notifications: _notifications,
      ));
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to load candy'));
    }
  }

  Future<void> _onUpdateCandy(
    UpdateCandy event,
    Emitter<CandyState> emit,
  ) async {
    try {

      await _candyRepository.update(event.candy);
      add(LoadCandy());
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
    // Очищаем предыдущий список "ожидания"
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
            _notifications.add(
              SweetNotification(
                id: const Uuid().v4(),
                date: now,
                sweetName: candy.name,
                message: 'Candy "${candy.name}" is out of stock!',
              ),
            );
          }
        }
      }
    }

    // Если есть конфеты на подтверждение списания, добавим уведомление
    if (_pendingPeriodicUsage.isNotEmpty) {
      _notifications.add(
        SweetNotification(
          id: const Uuid().v4(),
          date: now,
          sweetName: '',
          message: 'You have periodic usage to confirm.',
        ),
      );
    }

    emit(CandyLoaded(
      historyList: _historyList,
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
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

        // Сохраняем запись в историю использования
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

        // Проверяем, если конфета постоянная (isPermanent) и количество 0, добавляем в корзину и уведомляем
        if (updatedCandy.isPermanent && updatedCandy.quantity == 0) {
          final shopItem = ShoppingItem(
            id: const Uuid().v4(),
            candy: updatedCandy,
          );
          _shoppingList.add(shopItem);
          await _shoppingRepository.save(shopItem);

          // Создаём уведомление о необходимости пополнить запасы
          _notifications.add(
            SweetNotification(
              id: const Uuid().v4(),
              date: DateTime.now(),
              sweetName: updatedCandy.name,
              message:
                  'Candy "${updatedCandy.name}" is out of stock. Added to shopping list!',
            ),
          );
        }

        emit(CandyLoaded(
          historyList: _historyList,
          candies: _allCandies,
          shoppingList: _shoppingList,
          pendingPeriodicUsage: _pendingPeriodicUsage,
          notifications: _notifications,
        ));
      }
    }
  }

  void _onCancelPeriodicUsage(
    CancelPeriodicUsage event,
    Emitter<CandyState> emit,
  ) {
    _pendingPeriodicUsage.remove(event.candyId);
    emit(CandyLoaded(
      historyList: _historyList,
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
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

    emit(CandyLoaded(
      historyList: _historyList,
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
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

    emit(CandyLoaded(
      candies: _allCandies,
      historyList: _historyList,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
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

    emit(CandyLoaded(
      candies: _allCandies,
      historyList: _historyList,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
  }

  Future<void> _onCheckoutShoppingList(
    CheckoutShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    logger.d("Checkout shopping list: $_shoppingList");
    // Оставим всё как есть
    emit(CandyLoaded(
      historyList: _historyList,
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
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

    // Обновляем количество конфет
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

    emit(CandyLoaded(
      candies: _allCandies,
      historyList: _historyList,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<CandyState> emit,
  ) async {
    _notifications
        .removeWhere((element) => element.id == event.notification.id);
    emit(CandyLoaded(
      historyList: _historyList,
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
      notifications: _notifications,
    ));
  }
}
