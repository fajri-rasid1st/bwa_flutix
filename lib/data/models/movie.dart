import 'package:flutter/cupertino.dart';

class Movie {
  String title;
  String overview;
  String releaseDate;
  String posterUrl;
  String backdropUrl;
  String videoId;
  double voteAverage;
  int voteCount;
  int runtime;
  List<String> genres;

  Movie({
    @required this.title,
    @required this.overview,
    @required this.releaseDate,
    @required this.posterUrl,
    @required this.backdropUrl,
    @required this.videoId,
    @required this.voteAverage,
    @required this.voteCount,
    @required this.runtime,
    @required this.genres,
  });
}
