import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cick_movie_app/data/models/genre.dart';

class TvShow {
  String title;
  String firstAirDate;
  String lastAirDate;
  String posterPath;
  String backdropPath;
  String overview;
  int numberOfEpisodes;
  int numberOfSeasons;
  int episodeRuntime;
  int voteCount;
  num voteAverage;
  List<Genre> genres;

  TvShow({
    @required this.title,
    @required this.firstAirDate,
    @required this.lastAirDate,
    @required this.posterPath,
    @required this.backdropPath,
    @required this.overview,
    @required this.numberOfEpisodes,
    @required this.numberOfSeasons,
    @required this.episodeRuntime,
    @required this.voteCount,
    @required this.voteAverage,
    @required this.genres,
  });

  factory TvShow.fromMap(Map<String, dynamic> tvShow) {
    return TvShow(
      title: tvShow['name'],
      firstAirDate: tvShow['first_air_date'],
      lastAirDate: tvShow['last_air_date'],
      posterPath: tvShow['poster_path'],
      backdropPath: tvShow['backdrop_path'],
      overview: tvShow['overview'],
      numberOfEpisodes: tvShow['number_of_episodes'],
      numberOfSeasons: tvShow['number_of_seasons'],
      episodeRuntime: tvShow['episode_run_time'][0],
      voteCount: tvShow['vote_count'],
      voteAverage: tvShow['vote_average'],
      genres: List<Genre>.from(
        tvShow['genres'].map((genre) {
          return Genre.fromMap(genre);
        }),
      ),
    );
  }

  String get firstandLastAirDateParse {
    var firstAirDateParse = firstAirDate == null
        ? 'None'
        : DateFormat('MMM dd, y').format(DateTime.parse(firstAirDate));

    var lastAirDateParse = lastAirDate == null
        ? 'None'
        : DateFormat('MMM dd, y').format(DateTime.parse(lastAirDate));

    return '$firstAirDateParse to $lastAirDateParse';
  }

  @override
  String toString() {
    return 'TvShow(title: $title, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, posterPath: $posterPath, backdropPath: $backdropPath, overview: $overview, numberOfEpisodes: $numberOfEpisodes, numberOfSeasons: $numberOfSeasons, episodeRuntime: $episodeRuntime, voteCount: $voteCount, voteAverage: $voteAverage, genres: $genres)';
  }
}
