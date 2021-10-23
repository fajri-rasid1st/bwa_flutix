import 'package:flutter/material.dart';

class Popular {
  int id;
  String title;
  String releaseDate;
  num voteAverage;
  String posterPath;

  Popular({
    @required this.id,
    @required this.title,
    @required this.releaseDate,
    @required this.voteAverage,
    @required this.posterPath,
  });

  String get releaseDateParse {
    return releaseDate;
  }
}
