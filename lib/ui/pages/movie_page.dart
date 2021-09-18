import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/widgets/grid_view_items.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<MoviePopular> movies = [];

  @override
  void initState() {
    MovieServices.getPopularMovies(1).then((movies) {
      this.movies = movies;

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridViewItems(items: movies);
  }
}
