// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';

/// Модель для списка покупок
class ShoppingItem {
  final String id;

  final Candy candy;

  ShoppingItem({
    required this.id,
    required this.candy,
  });

  ShoppingItem copyWith({
    String? id,
    Candy? candy,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      candy: candy ?? this.candy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'candy': candy.toMap(),
    };
  }


  String toJson() => json.encode(toMap());

  factory ShoppingItem.fromJson(String source) =>
      ShoppingItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ShoppingItem(id: $id, candy: $candy)';

  @override
  bool operator ==(covariant ShoppingItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.candy == candy;
  }

  @override
  int get hashCode => id.hashCode ^ candy.hashCode;

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      candy: Candy.fromMap(map['candy'] as Map<String,dynamic>),
    );
  }
}
