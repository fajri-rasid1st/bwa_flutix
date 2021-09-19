import 'package:intl/intl.dart';

class MoviePopular {
  int id;
  String title;
  String releaseDate;
  num voteAverage;
  String posterPath;

  MoviePopular({
    this.id,
    this.title,
    this.releaseDate,
    this.voteAverage,
    this.posterPath
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

  get releaseDateParse =>
      DateFormat('MMM dd, y').format(DateTime.parse(releaseDate));
}
