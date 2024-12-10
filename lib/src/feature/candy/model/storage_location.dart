// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class StorageLocation {
  final String id;
  final String name;

  StorageLocation({
    required this.id,
    required this.name,
  });

  StorageLocation copyWith({
    String? id,
    String? name,
  }) {
    return StorageLocation(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory StorageLocation.fromMap(Map<String, dynamic> map) {
    return StorageLocation(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StorageLocation.fromJson(String source) =>
      StorageLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StorageLocation(id: $id, name: $name)';

  @override
  bool operator ==(covariant StorageLocation other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
