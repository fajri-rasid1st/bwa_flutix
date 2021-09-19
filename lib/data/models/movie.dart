import 'package:intl/intl.dart';

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
    this.title,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.runtime,
    this.voteCount,
    this.voteAverage,
    this.genres,
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
      genres: List<Genre>.from(movie['genres'].map((genre) {
        return Genre.fromMap(genre);
      })),
    );
  }

    get releaseDateParse =>
      DateFormat('MMM dd, y').format(DateTime.parse(releaseDate));
}

class Genre {
  String name;

  Genre({this.name});

  factory Genre.fromMap(Map<String, dynamic> genre) {
    return Genre(
      name: genre['name'],
    );
  }
}
