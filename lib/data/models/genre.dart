import 'package:flutter/material.dart';

class Genre {
  String name;

  Genre({@required this.name});

  factory Genre.fromMap(Map<String, dynamic> genre) {
    return Genre(name: genre['name']);
  }

  @override
  String toString() => 'Genre(name: $name)';
}
