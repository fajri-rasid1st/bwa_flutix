import 'dart:convert';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:http/http.dart' as http;

class TvShowServices {
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

        // casting response to map <string, dynamic> and get results value
        final List<dynamic> results =
            (popularTvShowsResponse as Map<String, dynamic>)['results'];

        // initialize empty TvShowPopular list
        final List<TvShowPopular> tvShows = [];

        // adds tvShow to TvShowPopular list
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
}
