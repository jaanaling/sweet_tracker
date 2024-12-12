// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';

class SweetNotification {
  final String id;
  final DateTime date;
  final String sweetName;
  final SweetType type;
  final String? image;
  final String message;
  bool isRead ;


  SweetNotification({
    required this.id,
    required this.date,
    required this.type,
    required this.isRead,
    this.image,
    required this.sweetName,
    required this.message,
  });

  SweetNotification copyWith({
    String? id,
    DateTime? date,
    String? sweetName,
    SweetType? type,
    String? image,
    String? message,
    bool? isRead,
  }) {
    return SweetNotification(
      type: type ?? this.type,
      id: id ?? this.id,
      date: date ?? this.date,
      image: image ?? this.image,
      sweetName: sweetName ?? this.sweetName,
      isRead: isRead ?? this.isRead,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'type': type.name,
      'image': image,
      'sweetName': sweetName,
      'message': message,
    };
  }

  factory SweetNotification.fromMap(Map<String, dynamic> map) {
    return SweetNotification(
      id: map['id'] as String,
      type: SweetType.values.firstWhere((e) => e.name == map['type']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      image: map['image'] != null ? map['image'] as String : null,
      isRead: false,
      sweetName: map['sweetName'] as String,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SweetNotification.fromJson(String source) =>
      SweetNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SweetNotification(id: $id, date: $date, sweetName: $sweetName, message: $message)';
  }

  @override
  bool operator ==(covariant SweetNotification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.sweetName == sweetName &&
        other.type == type &&
        other.image == image &&
        other.message == message;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ sweetName.hashCode ^ message.hashCode;
  }
}
