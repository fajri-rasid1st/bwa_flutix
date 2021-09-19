class TvShowPopular {
  int id;
  String title;
  String releaseDate;
  num voteAverage;
  String posterPath;

  TvShowPopular({
    this.id,
    this.title,
    this.releaseDate,
    this.voteAverage,
    this.posterPath,
  });

  factory TvShowPopular.fromMap(Map<String, dynamic> tvShowPopular) {
    return TvShowPopular(
      id: tvShowPopular['id'],
      title: tvShowPopular['name'],
      releaseDate: tvShowPopular['first_air_date'],
      voteAverage: tvShowPopular['vote_average'],
      posterPath: tvShowPopular['poster_path'],
    );
  }
}
