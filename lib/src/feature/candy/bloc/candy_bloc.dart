import 'package:bloc/bloc.dart';
import 'package:candy_planner/src/feature/candy/model/candy.dart';
import 'package:candy_planner/src/feature/candy/model/history.dart';
import 'package:candy_planner/src/feature/candy/model/shopping_item.dart';
import 'package:candy_planner/src/feature/candy/model/sweet_type.dart';
import 'package:candy_planner/src/feature/candy/repository/history_repository.dart';
import 'package:candy_planner/src/feature/candy/repository/shop_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/dependency_injection.dart';
import '../../../core/utils/log.dart';
import '../repository/repository.dart';

part 'candy_event.dart';
part 'candy_state.dart';

class CandyBloc extends Bloc<CandyEvent, CandyState> {
  final CandyRepository _candyRepository = locator<CandyRepository>();
  final ShoppingItemRepository _shoppingRepository =
      locator<ShoppingItemRepository>();
  final UsageHistoryRepository _historyRepository =
      locator<UsageHistoryRepository>();

  // Локальное хранилище полного списка для удобной фильтрации
  List<Candy> _allCandies = [];
  List<ShoppingItem> _shoppingList = [];
  Map<String, int> _pendingPeriodicUsage = {};

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
    on<CheckoutShoppingList>(_onCheckoutShoppingList);
  }

   Future<void> _onLoadCandy(
    LoadCandy event,
    Emitter<CandyState> emit,
  ) async {
    emit(CandyLoading());
    try {
      final candies = await _candyRepository.load();
      _allCandies = candies;
      // Загрузим список покупок
      _shoppingList = await _shoppingRepository.load();
      emit(CandyLoaded(
        candies: _allCandies,
        shoppingList: _shoppingList,
        pendingPeriodicUsage: _pendingPeriodicUsage,
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

  /// CheckPeriodicity event logic
  /// Предполагается, что данное событие будет вызываться регулярно (например, при запуске приложения или по таймеру),
  /// чтобы проверить конфеты, у которых включен периодический расход.
  Future<void> _onCheckPeriodicity(
    CheckPeriodicity event,
    Emitter<CandyState> emit,
  ) async {
    // Очищаем предыдущий список "ожидания"
    _pendingPeriodicUsage.clear();

    for (var candy in _allCandies) {
      if (candy.isPeriodic && candy.periodicityDays != null && candy.periodicityCount != null) {
        // Проверим, есть ли что списывать
        if (candy.quantity > 0) {
          final countToUse = candy.quantity >= candy.periodicityCount!
              ? candy.periodicityCount!
              : candy.quantity;
          if (countToUse > 0) {
            _pendingPeriodicUsage[candy.id] = countToUse;
          }
        }
      }
    }

    emit(CandyLoaded(
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
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
          sweetName: candy.name,
          usedQuantity: countToUse,
        );

        try {
          await _historyRepository.addRecord(record);
        } catch (e) {
          logger.e(e);
          emit(const CandyError('Failed to add usage history record'));
          return;
        }

        emit(CandyLoaded(
          candies: _allCandies,
          shoppingList: _shoppingList,
          pendingPeriodicUsage: _pendingPeriodicUsage,
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
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
    ));
  }

  Future<void> _onAddToShoppingList(
    AddToShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    final item = ShoppingItem(
      id: event.id,
      name: event.name,
      quantity: event.quantity,
      type: event.type,
      note: event.note,
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
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
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
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
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
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
    ));
  }

  Future<void> _onCheckoutShoppingList(
    CheckoutShoppingList event,
    Emitter<CandyState> emit,
  ) async {
    // Логика экспорта/отправки списка покупок:
    // Тут мы просто логируем.
    logger.d("Checkout shopping list: $_shoppingList");
    // Можно например очистить после выгрузки:
    // _shoppingList.clear();
    // await _shoppingRepository.clear();

    // Пока просто эмитим текущее состояние
    emit(CandyLoaded(
      candies: _allCandies,
      shoppingList: _shoppingList,
      pendingPeriodicUsage: _pendingPeriodicUsage,
    ));
  }
}