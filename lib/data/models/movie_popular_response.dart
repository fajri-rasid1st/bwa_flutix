import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:flutter/foundation.dart';

class MoviePopularResponse {
  int page;
  int totalPages;
  List<MoviePopular> moviePopular;

  MoviePopularResponse({
    @required this.page,
    @required this.totalPages,
    @required this.moviePopular,
  });

  
}
