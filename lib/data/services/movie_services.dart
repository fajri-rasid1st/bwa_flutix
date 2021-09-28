import 'dart:convert';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/cast.dart';
import 'package:cick_movie_app/data/models/movie.dart';
import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/models/video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieServices {
  // function to get list of popular movies from API
  static Future<void> getPopularMovies({
    int page = 1,
    @required void Function(List<MoviePopular> movies) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/movie/popular?api_key=${Const.API_KEY}&page=$page';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final popularMoviesResponse = json.decode(response.body);

        // casting response to Map<string, dynamic> and get results value
        final List<dynamic> results =
            (popularMoviesResponse as Map<String, dynamic>)['results'];

        // get each movie inside results
        final movies = List<MoviePopular>.from(
          results.map((moviePopular) {
            return MoviePopular.fromMap(moviePopular);
          }),
        );

        // return MoviePopular list
        onSuccess(movies);
      } else {
        onFailure('Request failed.');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  // function to get movie detail from API
  static Future<void> getMovie({
    @required int movieId,
    @required void Function(Movie movie) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url = '${Const.BASE_URL}/movie/$movieId?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final movieResponse = json.decode(response.body);

        // casting response to Map<string, dynamic>
        final results = (movieResponse as Map<String, dynamic>);

        // get Movie from Map<string, dynamic> results
        final movie = Movie.fromMap(results);

        // return Movie when request success
        onSuccess(movie);
      } else {
        onFailure('Request failed');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  // function to get movie video from API
  static Future<void> getMovieVideo({
    @required int movieId,
    @required void Function(Video video) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/movie/$movieId/videos?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final movieVideoResponse = json.decode(response.body);

        // casting response to Map<string, dynamic> and get results value
        final List<dynamic> results =
            (movieVideoResponse as Map<String, dynamic>)['results'];

        if (results.isEmpty) {
          // failure if results is empty
          onFailure('This movie has no trailer');
        } else {
          // else, get video from results at index 0
          onSuccess(Video.fromMap(results[0]));
        }
      } else {
        onFailure('Request failed');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  // function to get movie casts from API
  static Future<void> getMovieCasts({
    @required int movieId,
    @required void Function(List<Cast> casts) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/movie/$movieId/credits?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final movieCastsResponse = json.decode(response.body);

        // casting response to Map<string, dynamic> and get cast value
        final List<dynamic> results =
            (movieCastsResponse as Map<String, dynamic>)['cast'];

        if (results.isEmpty) {
          onFailure('No credits data.');
        } else {
          // initialize empty Cast list
          final List<Cast> casts = [];

          for (var cast in results) {
            // if casts are already 16 items, break the loop
            if (casts.length == 16) break;
            // add every cast on results to Cast list
            casts.add(Cast.fromMap(cast));
          }

          // return Cast list
          onSuccess(casts);
        }
      } else {
        onFailure('Request failed.');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
