// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class SweetNotification {
  final String id;
  final DateTime date;
  final String sweetName;
  final String message;

  SweetNotification({
    required this.id,
    required this.date,
    required this.sweetName,
    required this.message,
  });

  SweetNotification copyWith({
    String? id,
    DateTime? date,
    String? sweetName,
    String? message,
  }) {
    return SweetNotification(
      id: id ?? this.id,
      date: date ?? this.date,
      sweetName: sweetName ?? this.sweetName,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'sweetName': sweetName,
      'message': message,
    };
  }

  factory SweetNotification.fromMap(Map<String, dynamic> map) {
    return SweetNotification(
      id: map['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
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
        other.message == message;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ sweetName.hashCode ^ message.hashCode;
  }
}
