// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sweet_planner/src/feature/candy/model/storage_location.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_category.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';

class Candy {
  final String id;
  final String name;
  final SweetCategory category;
  final StorageLocation location;
  final int quantity;
  final DateTime? expirationDate;

  final bool isPermanent;
  final bool isPeriodic;
  final List<int>? periodicityDays;
  final int? periodicityCount;
   int? currentPeriodicIndex;
  final SweetType type;
  final String? imageUrl;
  bool get isExpired =>
      expirationDate != null ? DateTime.now().isAfter(expirationDate!) : false;
  final bool isTemplate;

  Candy({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.quantity,
    this.expirationDate,
    required this.isPermanent,
    required this.isPeriodic,
    this.currentPeriodicIndex,
    this.periodicityDays,
    this.periodicityCount,
    required this.type,
    this.imageUrl,
    required this.isTemplate,
  });

  Candy copyWith({
    String? id,
    String? name,
    SweetCategory? category,
    StorageLocation? location,
    int? quantity,
    DateTime? expirationDate,
    bool? isPermanent,
    bool? isPeriodic,
    List<int>? periodicityDays,
    int? currentPeriodicIndex,
    int? periodicityCount,
    SweetType? type,
    String? imageUrl,
    bool? isExpired,
    bool? isTemplate,
  }) {
    return Candy(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
      expirationDate: expirationDate ?? this.expirationDate,
      isPermanent: isPermanent ?? this.isPermanent,
      isPeriodic: isPeriodic ?? this.isPeriodic,
      currentPeriodicIndex: currentPeriodicIndex ?? this.currentPeriodicIndex,
      periodicityDays: periodicityDays ?? this.periodicityDays,
      periodicityCount: periodicityCount ?? this.periodicityCount,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      isTemplate: isTemplate ?? this.isTemplate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category.toMap(),
      'location': location.name,
      'quantity': quantity,
      'expirationDate': expirationDate?.millisecondsSinceEpoch,
      'currentPeriodicIndex': currentPeriodicIndex,
      'isPermanent': isPermanent,
      'isPeriodic': isPeriodic,
      'periodicityDays': periodicityDays,
      'periodicityCount': periodicityCount,
      'type': type.name,
      'imageUrl': imageUrl,
      'isTemplate': isTemplate,
    };
  }

  factory Candy.fromMap(Map<String, dynamic> map) {
    return Candy(
      id: map['id'] as String,
      name: map['name'] as String,
      category: SweetCategory.fromMap(map['category'] as Map<String, dynamic>),
      location:
          StorageLocation.values.firstWhere((e) => e.name == map['location']),
      quantity: map['quantity'] as int,
      expirationDate: map['expirationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expirationDate'] as int)
          : null,
      isPermanent: map['isPermanent'] as bool,
      isPeriodic: map['isPeriodic'] as bool,
      currentPeriodicIndex: map['currentPeriodicIndex'] != null
          ? map['currentPeriodicIndex'] as int
          : null,
      periodicityDays: map['periodicityDays'] != null
          ? List<int>.from(map['periodicityDays'] as List)
          : null,
      periodicityCount: map['periodicityCount'] != null
          ? map['periodicityCount'] as int
          : null,
      type: SweetType.values.firstWhere((e) => e.name == map['type']),
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      isTemplate: map['isTemplate'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Candy.fromJson(String source) =>
      Candy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Candy(id: $id, name: $name, category: $category, location: $location, quantity: $quantity, expirationDate: $expirationDate, isPermanent: $isPermanent, isPeriodic: $isPeriodic, periodicityDays: $periodicityDays, periodicityCount: $periodicityCount, type: $type, imageUrl: $imageUrl, isExpired: $isExpired, isTemplate: $isTemplate)';
  }

  @override
  bool operator ==(covariant Candy other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.category == category &&
        other.location == location &&
        other.quantity == quantity &&
        other.currentPeriodicIndex == currentPeriodicIndex &&

        other.expirationDate == expirationDate &&
        other.isPermanent == isPermanent &&
        other.isPeriodic == isPeriodic &&
        other.periodicityDays == periodicityDays &&
        other.periodicityCount == periodicityCount &&
        other.type == type &&
        other.imageUrl == imageUrl &&
        other.isTemplate == isTemplate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        currentPeriodicIndex.hashCode ^
        location.hashCode ^
        quantity.hashCode ^
        expirationDate.hashCode ^
        isPermanent.hashCode ^
        isPeriodic.hashCode ^
        periodicityDays.hashCode ^
        periodicityCount.hashCode ^
        type.hashCode ^
        imageUrl.hashCode ^
        isTemplate.hashCode;
  }
}
