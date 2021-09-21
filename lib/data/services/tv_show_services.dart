import 'dart:convert';
import 'package:cick_movie_app/const.dart';
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

        // initialize empty TvShowPopular list
        final List<TvShowPopular> tvShows = [];

        // add every tv show on results to TvShowPopular list
        for (var tvShow in results) {
          tvShows.add(TvShowPopular.fromMap(tvShow));
        }

        // return TvShowPopular list
        onSuccess(tvShows);
      } else {
        onFailure('Request failed.');
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
        final Map<String, dynamic> results =
            (tvShowResponse as Map<String, dynamic>);

        // get TvShow from Map<string, dynamic> results
        final TvShow tvShow = TvShow.fromMap(results);

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
}
