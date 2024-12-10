part of 'candy_bloc.dart';

abstract class CandyEvent extends Equatable {
  const CandyEvent();

  @override
  List<Object> get props => [];
}

class LoadCandy extends CandyEvent {}

class UpdateCandy extends CandyEvent {
  final Candy candy;
  const UpdateCandy(this.candy);

  @override
  List<Object> get props => [candy];
}

class SaveCandy extends CandyEvent {
  final Candy candy;
  const SaveCandy(this.candy);

  @override
  List<Object> get props => [candy];
}

class RemoveCandy extends CandyEvent {
  final Candy candy;
  const RemoveCandy(this.candy);

  @override
  List<Object> get props => [candy];
}

// Периодические события
class CheckPeriodicity extends CandyEvent {}

class ConfirmPeriodicUsage extends CandyEvent {
  final String candyId;
  const ConfirmPeriodicUsage(this.candyId);

  @override
  List<Object> get props => [candyId];
}

class CancelPeriodicUsage extends CandyEvent {
  final String candyId;
  const CancelPeriodicUsage(this.candyId);

  @override
  List<Object> get props => [candyId];
}

// Список покупок
class AddToShoppingList extends CandyEvent {
  final String id;
  final String name;
  final int quantity;
  final SweetType type;
  final String? note;

  const AddToShoppingList({
    required this.id,
    required this.name,
    required this.quantity,
    required this.type,
    this.note,
  });

  @override
  List<Object> get props => [id, name, quantity, type, note ?? ''];
}

class RemoveFromShoppingList extends CandyEvent {
  final ShoppingItem item;
  const RemoveFromShoppingList(this.item);

  @override
  List<Object> get props => [item];
}

class ClearShoppingList extends CandyEvent {}

class CheckoutShoppingList extends CandyEvent {}