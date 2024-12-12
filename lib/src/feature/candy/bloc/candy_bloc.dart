import 'dart:convert'; // NEW CODE: для jsonEncode/jsonDecode

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NEW CODE: для SharedPreferences

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
  bool isFirst = false;

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

  // NEW CODE: метод для загрузки _pendingPeriodicUsage из SharedPreferences
  Future<void> _loadPendingPeriodicUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('pendingPeriodicUsage');
    if (jsonString != null && jsonString.isNotEmpty) {
      final Map<String, dynamic> decoded =
          jsonDecode(jsonString) as Map<String, dynamic>;
      _pendingPeriodicUsage =
          decoded.map((key, value) => MapEntry(key, value as int));

      logger.d(
          'Pending periodic usage loaded from SharedPreferences: $_pendingPeriodicUsage');
    } else {
      _pendingPeriodicUsage = {};
      logger.d(
          'Pending periodic usage loaded from SharedPreferences: $_pendingPeriodicUsage');
    }
  }

  // NEW CODE: метод для сохранения _pendingPeriodicUsage в SharedPreferences
  Future<void> _savePendingPeriodicUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_pendingPeriodicUsage);
    await prefs.setString('pendingPeriodicUsage', jsonString);
  }
  // END NEW CODE

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

      // NEW CODE: Загрузка _pendingPeriodicUsage из SharedPreferences
      await _loadPendingPeriodicUsage();
      // END NEW CODE

      if (isFirst == false) {
        _generateNotifications();
        isFirst = true;
      }

      emit(CandyLoaded(
        candies: _allCandies,
        shoppingList: _shoppingList,
        pendingPeriodicUsage: _pendingPeriodicUsage,
        historyList: _historyList,
        notifications: _notifications,
      ));

      // Запускаем проверку периодичности один раз
      if (isFirst == false) {
        add(CheckPeriodicity());
        isFirst = true;
      }
    } catch (e) {
      logger.e(e);
      emit(const CandyError('Failed to load candy'));
    }
  }

  void _generateNotifications() {
    final now = DateTime.now();

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
          image: event.candy.imageUrl,
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

      _allCandies.add(event.candy);
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
            // Нет в наличии, генерируем уведомление
            final notif = SweetNotification(
              id: const Uuid().v4(),
              image: candy.imageUrl,
              isRead: false,
              type: candy.type,
              date: now,
              sweetName: candy.name,
              message: 'Candy "${candy.name}" is out of stock!',
            );
            if (!_notifications.any((n) => n.message == notif.message)) {
              _notifications.add(notif);
            }
          }
        }
      }
    }

    // NEW CODE: Сохраняем обновлённый _pendingPeriodicUsage
    await _savePendingPeriodicUsage();
    // END NEW CODE

    add(LoadCandy());
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
          image: updatedCandy.imageUrl,
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

        // NEW CODE: Сохраняем обновлённый _pendingPeriodicUsage
        await _savePendingPeriodicUsage();
        // END NEW CODE

        add(LoadCandy());
      }
    }
  }

  Future<void> _onCancelPeriodicUsage(
    CancelPeriodicUsage event,
    Emitter<CandyState> emit,
  ) async {
    _pendingPeriodicUsage.remove(event.candyId);
    // NEW CODE: Сохраняем обновлённый _pendingPeriodicUsage после удаления
    await _savePendingPeriodicUsage();
    // END NEW CODE

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
    _notifications[
            _notifications.indexWhere((n) => n.id == event.notification.id)]
        .isRead = true;
    add(LoadCandy());
  }
}
