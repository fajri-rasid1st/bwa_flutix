import 'package:flutter/material.dart';

class MoviePopular {
  int id;
  String title;
  String releaseDate;
  num voteAverage;
  String posterPath;

  MoviePopular({
    @required this.id,
    @required this.title,
    @required this.releaseDate,
    @required this.voteAverage,
    @required this.posterPath,
  });

  factory MoviePopular.fromMap(Map<String, dynamic> moviePopular) {
    return MoviePopular(
      id: moviePopular['id'],
      title: moviePopular['title'],
      releaseDate: moviePopular['release_date'],
      voteAverage: moviePopular['vote_average'],
      posterPath: moviePopular['poster_path'],
    );
  }
}
