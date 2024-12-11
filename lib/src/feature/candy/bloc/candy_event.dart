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
  final Candy candy;

  const AddToShoppingList({
    required this.id,
    required this.candy,
  });

  @override
  List<Object> get props => [
        id,
        candy,
      ];
}

class RemoveFromShoppingList extends CandyEvent {
  final ShoppingItem item;
  const RemoveFromShoppingList(this.item);

  @override
  List<Object> get props => [item];
}

class ClearShoppingList extends CandyEvent {}

class CheckoutShoppingList extends CandyEvent {}

class DeleteNotification extends CandyEvent {
  final SweetNotification notification;
  const DeleteNotification(this.notification);

  @override
  List<Object> get props => [notification];
}

class BuyFromShoppingList extends CandyEvent {
  final ShoppingItem item;
  const BuyFromShoppingList(this.item);

  @override
  List<Object> get props => [item];
}

