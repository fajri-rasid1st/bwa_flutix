import 'dart:convert';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/movie.dart';
import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:http/http.dart' as http;

class MovieServices {
  // function to get list of popular movies from API
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

        // casting response to Map <string, dynamic> and get results value
        final List<dynamic> results =
            (popularMoviesResponse as Map<String, dynamic>)['results'];

        // initialize empty MoviePopular list
        final List<MoviePopular> movies = [];

        // add movie to MoviePopular list
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

  // function to get movie detail from API
  static Future<Movie> getMovie(int movieId) async {
    // define URL target
    final url = '${Const.BASE_URL}/movie/$movieId?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final movieResponse = json.decode(response.body);

        // casting response to Map <string, dynamic>
        final Map<String, dynamic> results =
            (movieResponse as Map<String, dynamic>);

        // get Movie from Map <string, dynamic>
        final Movie movie = Movie.fromMap(results);

        // return Movie
        return movie;
      } else {
        return Movie();
      }
    } catch (e) {
      print(e.toString());

      return Movie();
    }
  }
}
