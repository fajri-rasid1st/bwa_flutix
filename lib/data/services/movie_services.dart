import 'dart:convert';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:http/http.dart' as http;

class MovieServices {
  static Future<List<MoviePopular>> getPopularMovies([int page = 1]) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/movie/popular?api_key=${Const.API_KEY}&page=$page';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final popularMoviesResponse = json.decode(response.body);

        // casting response to map <string, dynamic> and get results value
        final List<dynamic> results =
            (popularMoviesResponse as Map<String, dynamic>)['results'];

        // initialize empty MoviePopular list
        final List<MoviePopular> movies = [];

        // adds movie to MoviePopular list
        for (var movie in results) {
          movies.add(MoviePopular.fromMap(movie));
        }

        // return MoviePopular list
        return movies;
      } else {
        return <MoviePopular>[];
      }
    } catch (e) {
      print(e.toString());

      return <MoviePopular>[];
    }
  }
}
