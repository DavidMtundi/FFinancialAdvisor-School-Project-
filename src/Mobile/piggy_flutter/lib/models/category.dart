import 'package:flutter/material.dart';

class Category {
  Category({required this.id, this.name, this.icon});

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        icon = json['icon'];

  toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }

  String? name;
  String? id;
  String? icon;

  @override
  String toString() {
    return 'category is $name';
  }
}
