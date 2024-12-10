// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class SweetCategory {
  final String id;
  final String name;

  SweetCategory({
    required this.id,
    required this.name,
  });

  SweetCategory copyWith({
    String? id,
    String? name,
  }) {
    return SweetCategory(
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

  factory SweetCategory.fromMap(Map<String, dynamic> map) {
    return SweetCategory(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SweetCategory.fromJson(String source) =>
      SweetCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SweetCategory(id: $id, name: $name)';

  @override
  bool operator ==(covariant SweetCategory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
