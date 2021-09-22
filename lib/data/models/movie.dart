import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cick_movie_app/data/models/genre.dart';

class Movie {
  String title;
  String releaseDate;
  String posterPath;
  String backdropPath;
  String overview;
  int runtime;
  int voteCount;
  num voteAverage;
  List<Genre> genres;

  Movie({
    @required this.title,
    @required this.releaseDate,
    @required this.posterPath,
    @required this.backdropPath,
    @required this.overview,
    @required this.runtime,
    @required this.voteCount,
    @required this.voteAverage,
    @required this.genres,
  });

  factory Movie.fromMap(Map<String, dynamic> movie) {
    return Movie(
      title: movie['title'],
      releaseDate: movie['release_date'],
      posterPath: movie['poster_path'],
      backdropPath: movie['backdrop_path'],
      overview: movie['overview'],
      runtime: movie['runtime'],
      voteCount: movie['vote_count'],
      voteAverage: movie['vote_average'],
      genres: List<Genre>.from(
        movie['genres'].map((genre) {
          return Genre.fromMap(genre);
        }),
      ),
    );
  }

  String get releaseDateParse {
    return releaseDate == null
        ? 'None'
        : DateFormat('MMM dd, y').format(DateTime.parse(releaseDate));
  }

  @override
  String toString() {
    return 'Movie(title: $title, releaseDate: $releaseDate, posterPath: $posterPath, backdropPath: $backdropPath, overview: $overview, runtime: $runtime, voteCount: $voteCount, voteAverage: $voteAverage, genres: $genres)';
  }
}
