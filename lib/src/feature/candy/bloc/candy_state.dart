part of 'candy_bloc.dart';

abstract class CandyState extends Equatable {
  const CandyState();

  @override
  List<Object> get props => [];
}

class CandyInitial extends CandyState {}

class CandyLoading extends CandyState {}

class CandyLoaded extends CandyState {
  final List<Candy> candies;
  final List<ShoppingItem> shoppingList;
  final List<UsageHistoryRecord> historyList;
  final Map<String, int> pendingPeriodicUsage;

  const CandyLoaded({
    required this.candies,
    required this.historyList,
    required this.shoppingList,
    required this.pendingPeriodicUsage,
  });

  @override
  List<Object> get props => [candies, shoppingList, pendingPeriodicUsage, historyList];
}

class CandyError extends CandyState {
  final String message;
  const CandyError(this.message);

  @override
  List<Object> get props => [message];
}
