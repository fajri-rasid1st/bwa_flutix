import 'dart:convert';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/cast.dart';
import 'package:cick_movie_app/data/models/tv_show.dart';
import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/models/video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TvShowServices {
  // function to get list of popular tv show from API
  static Future<void> getPopularTvShows({
    int page = 1,
    @required void Function(List<TvShowPopular> tvShow) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/tv/popular?api_key=${Const.API_KEY}&page=$page';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final popularTvShowsResponse = json.decode(response.body);

        // casting response to Map<string, dynamic> and get results value
        final List<dynamic> results =
            (popularTvShowsResponse as Map<String, dynamic>)['results'];

        // get each tv show inside results
        final tvShows = List<TvShowPopular>.from(
          results.map((tvShowPopular) {
            return TvShowPopular.fromMap(tvShowPopular);
          }),
        );

        // return TvShowPopular list
        onSuccess(tvShows);
      } else {
        onFailure('Request failed');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  // function to get tv show detail from API
  static Future<void> getTvShow({
    @required int tvShowId,
    @required void Function(TvShow tvShow) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url = '${Const.BASE_URL}/tv/$tvShowId?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final tvShowResponse = json.decode(response.body);

        // casting response to Map<string, dynamic>
        final results = (tvShowResponse as Map<String, dynamic>);

        // get TvShow from Map<string, dynamic> results
        final tvShow = TvShow.fromMap(results);

        // return TvShow when request success
        onSuccess(tvShow);
      } else {
        onFailure('Request failed');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  // function to get tv show video from API
  static Future<void> getTvShowVideo({
    @required int tvShowId,
    @required void Function(Video video) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/tv/$tvShowId/videos?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final tvShowVideoResponse = json.decode(response.body);

        // casting response to Map<string, dynamic> and get results value
        final List<dynamic> results =
            (tvShowVideoResponse as Map<String, dynamic>)['results'];

        if (results.isEmpty) {
          // failure if results is empty
          onFailure('This tv show has no trailer');
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

  // function to get tv show casts from API
  static Future<void> getTvShowCasts({
    @required int tvShowId,
    @required void Function(List<Cast> casts) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/tv/$tvShowId/credits?api_key=${Const.API_KEY}';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final tvShowCastsResponse = json.decode(response.body);

        // casting response to Map<string, dynamic> and get cast value
        final List<dynamic> results =
            (tvShowCastsResponse as Map<String, dynamic>)['cast'];

        if (results.isEmpty) {
          onFailure('No credit(s) or cast(s) data');
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
        onFailure('Request failed');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  // function to search movies
  static Future<void> searchTvShows({
    int page = 1,
    @required String query,
    @required void Function(List<TvShowPopular> tvShows) onSuccess,
    @required void Function(String message) onFailure,
  }) async {
    // define URL target
    final url =
        '${Const.BASE_URL}/search/tv?api_key=${Const.API_KEY}&page=$page&query=$query&include_adult=false';

    try {
      // send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // parse the string and returns the resulting json object
        final searchTvShowsResponse = json.decode(response.body);

        // casting response to Map<string, dynamic>
        final searchTvShowsMap =
            (searchTvShowsResponse as Map<String, dynamic>);

        // get results value
        final List<dynamic> results = searchTvShowsMap['results'];

        // get total_pages value
        final int totalPages = searchTvShowsMap['total_pages'];

        if (totalPages == 0) {
          // if no result(s) based inserted query, return failure
          onFailure('Tv show(s) not found');
        } else {
          // otherwise, get each tv show inside results
          final tvShows = List<TvShowPopular>.from(
            results.map((tvShow) {
              return TvShowPopular.fromMap(tvShow);
            }),
          );

          // return tvShows
          return tvShows.length == 0
              ? onFailure('No more tv shows')
              : onSuccess(tvShows);
        }
      } else {
        onFailure('Request failed');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
