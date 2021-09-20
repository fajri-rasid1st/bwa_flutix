import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_view_items.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoviePopular>>(
      future: MovieServices.getPopularMovies(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FutureOnLoad(text: 'Fetching data...');
        } else {
          if (snapshot.hasError) {
            return FutureOnLoad(text: 'Request failed.', isError: true);
          }

          final movies = snapshot.data;

          return GridViewItems(items: movies);
        }
      },
    );
  }
}
