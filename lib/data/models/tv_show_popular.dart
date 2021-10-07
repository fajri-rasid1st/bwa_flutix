import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      releaseDate: tvShowPopular['first_air_date'] ?? '',
      voteAverage: tvShowPopular['vote_average'] ?? 0,
      posterPath: tvShowPopular['poster_path'],
    );
  }

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
