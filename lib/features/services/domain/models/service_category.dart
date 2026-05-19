import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String imageUrl;
  final Color color;
  final int providerCount;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.imageUrl,
    required this.color,
    required this.providerCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ServiceCategory{id: $id, name: $name, description: $description}';
  }
}
