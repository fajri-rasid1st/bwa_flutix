import 'package:cick_movie_app/data/models/popular.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TvShowPopular extends Popular {
  TvShowPopular({
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

  factory TvShowPopular.fromMap(Map<String, dynamic> tvShowPopular) {
    return TvShowPopular(
      id: tvShowPopular['id'],
      title: tvShowPopular['name'],
      releaseDate: tvShowPopular['first_air_date'] ?? '',
      voteAverage: tvShowPopular['vote_average'] ?? 0,
      posterPath: tvShowPopular['poster_path'],
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
    return 'TvShowPopular(id: $id, title: $title, releaseDate: $releaseDate, voteAverage: $voteAverage, posterPath: $posterPath)';
  }
}
