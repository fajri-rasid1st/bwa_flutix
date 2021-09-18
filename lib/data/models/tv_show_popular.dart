import 'package:flutter/material.dart';

class TvShowPopular {
  int id;
  String title;
  String releaseDate;
  num voteAverage;
  String posterPath;

  TvShowPopular({
    @required this.id,
    @required this.title,
    @required this.releaseDate,
    @required this.voteAverage,
    @required this.posterPath,
  });

  factory TvShowPopular.fromMap(Map<String, dynamic> tvShowPopular) {
    return TvShowPopular(
      id: tvShowPopular['id'],
      title: tvShowPopular['name'],
      releaseDate: tvShowPopular['first_air_date'],
      voteAverage: tvShowPopular['vote_average'],
      posterPath: tvShowPopular['poster_path'],
    );
  }
}
