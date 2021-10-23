import 'package:cick_movie_app/data/models/popular.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoviePopular extends Popular {
  MoviePopular({
    @required int id,
    @required String title,
    @required String releaseDate,
    @required num voteAverage,
    @required String posterPath,
  }) : super(
          id: id,
          title: title,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          posterPath: posterPath,
        );

  factory MoviePopular.fromMap(Map<String, dynamic> moviePopular) {
    return MoviePopular(
      id: moviePopular['id'],
      title: moviePopular['title'],
      releaseDate: moviePopular['release_date'] ?? '',
      voteAverage: moviePopular['vote_average'] ?? 0,
      posterPath: moviePopular['poster_path'],
    );
  }

  @override
  String get releaseDateParse {
    return releaseDate.isEmpty
        ? 'None'
        : DateFormat('MMM dd, y').format(DateTime.parse(releaseDate));
  }

  @override
  String toString() {
    return 'MoviePopular(id: $id, title: $title, releaseDate: $releaseDate, voteAverage: $voteAverage, posterPath: $posterPath)';
  }
}
