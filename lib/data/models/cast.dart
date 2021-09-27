import 'package:flutter/material.dart';

class Cast {
  String name;
  String character;
  String profilePath;

  Cast({
    @required this.name,
    @required this.character,
    @required this.profilePath,
  });

  factory Cast.fromMap(Map<String, dynamic> map) {
    return Cast(
      name: map['name'],
      character: map['character'],
      profilePath: map['profile_path'],
    );
  }

  @override
  String toString() {
    return 'Cast(name: $name, character: $character, profilePath: $profilePath)';
  }
}
