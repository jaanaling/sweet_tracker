import 'dart:convert';

import 'package:sweet_planner/src/feature/candy/model/sweet_category.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';

class UsageHistoryRecord {
  final String id;
  final DateTime date;
  final String sweetName;
  final String? image;
  final SweetType category;
  final int usedQuantity;

  UsageHistoryRecord({
    required this.id,
    required this.date,
    this.image,
    required this.sweetName,
    required this.category,
    required this.usedQuantity,
  });

  UsageHistoryRecord copyWith({
    String? id,
    DateTime? date,
    String? sweetName,
    String? image,
    SweetType? category,
    int? usedQuantity,
  }) {
    return UsageHistoryRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      image: image ?? this.image,
      sweetName: sweetName ?? this.sweetName,
      usedQuantity: usedQuantity ?? this.usedQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'image': image,
      'sweetName': sweetName,
      'category': category.name,
      'usedQuantity': usedQuantity,
    };
  }

  factory UsageHistoryRecord.fromMap(Map<String, dynamic> map) {
    return UsageHistoryRecord(
      id: map['id'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      category: SweetType.values.firstWhere((e) => e.name == map['category']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      sweetName: map['sweetName'] as String,
      usedQuantity: map['usedQuantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsageHistoryRecord.fromJson(String source) =>
      UsageHistoryRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsageHistoryRecord(id: $id, date: $date, sweetName: $sweetName, usedQuantity: $usedQuantity)';
  }

  @override
  bool operator ==(covariant UsageHistoryRecord other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.category == category &&
        other.image == image &&
        other.sweetName == sweetName &&
        other.usedQuantity == usedQuantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category.hashCode ^
        image.hashCode ^
        date.hashCode ^
        sweetName.hashCode ^
        usedQuantity.hashCode;
  }
}
