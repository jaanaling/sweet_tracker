// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:candy_planner/src/feature/candy/model/candy.dart';
import 'package:candy_planner/src/feature/candy/model/sweet_type.dart';

/// Модель для списка покупок
class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final SweetType type;
  final String? note;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.type,
    this.note,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    SweetType? type,
    String? note,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'type': type.name,
      'note': note,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      type: SweetType.values.firstWhere((e) => e.name == map['type']),
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingItem.fromJson(String source) =>
      ShoppingItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, quantity: $quantity, type: $type, note: $note)';
  }

  @override
  bool operator ==(covariant ShoppingItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.quantity == quantity &&
        other.type == type &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        quantity.hashCode ^
        type.hashCode ^
        note.hashCode;
  }
}
