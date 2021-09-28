import 'dart:convert';

import 'package:flutter/material.dart';

final String favoriteTable = 'favorite_table';

class FavoriteFields {
  static final String id = '_id';
  static final String favoriteId = 'favoriteId';
  static final String title = 'title';
  static final String posterPath = 'posterPath';
  static final String overview = 'overview';
  static final String type = 'type';
  static final String createdAt = 'createdAt';
}

class Favorite {
  int id;
  int favoriteId;
  String title;
  String posterPath;
  String overview;
  String type;
  DateTime createdAt;

  Favorite({
    @required this.id,
    @required this.favoriteId,
    @required this.title,
    @required this.posterPath,
    @required this.overview,
    @required this.type,
    @required this.createdAt,
  });

  factory Favorite.fromMap(Map<String, dynamic> favorite) {
    return Favorite(
      id: favorite[FavoriteFields.id] as int,
      favoriteId: favorite[FavoriteFields.favoriteId] as int,
      title: favorite[FavoriteFields.title] as String,
      posterPath: favorite[FavoriteFields.posterPath] as String,
      overview: favorite[FavoriteFields.overview] as String,
      type: favorite[FavoriteFields.type] as String,
      createdAt: DateTime.parse(
        favorite[FavoriteFields.createdAt] as String,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FavoriteFields.id: id,
      FavoriteFields.favoriteId: favoriteId,
      FavoriteFields.title: title,
      FavoriteFields.posterPath: posterPath,
      FavoriteFields.overview: overview,
      FavoriteFields.type: type,
      FavoriteFields.createdAt: createdAt.toIso8601String(),
    };
  }

  Favorite copyWith({
    int id,
    int favoriteId,
    String title,
    String posterPath,
    String overview,
    String type,
    DateTime createdAt,
  }) {
    return Favorite(
      id: id ?? this.id,
      favoriteId: favoriteId ?? this.favoriteId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
