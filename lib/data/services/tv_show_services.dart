import 'dart:convert';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/tv_show.dart';
import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/models/video.dart';
import 'package:http/http.dart' as http;

class TvShowServices {
  // function to get list of popular tv shows from API
  static Future<List<TvShowPopular>> getPopularTvShows([int page = 1]) async {
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
        return tvShows;
      } else {
        throw Exception('Request failed.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // function to get tv show detail from API
  static Future<TvShow> getTvShow(int tvShowId) async {
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

        // return TvShow
        return tvShow;
      } else {
        throw Exception('Request failed.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // function to get tv show video from API
  static Future<Video> getTvShowVideo(int tvShowId) async {
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

        // return exception if results is empty
        if (results.isEmpty) {
          throw Exception('This tv show has no trailer.');
        }

        // return video from results at index 0 if exist
        return Video.fromMap(results[0]);
      } else {
        throw Exception('Request failed.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
