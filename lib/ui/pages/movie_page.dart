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
  // initialize atribute
  bool _isLoading = true;

  // this attribute will be filled in the future
  List<MoviePopular> _movies;
  String _failureMessage;

  @override
  void initState() {
    MovieServices.getPopularMovies(
      onSuccess: (movies) => _movies = movies,
      onFailure: (message) => _failureMessage = message,
    ).then((_) {
      setState(() => _isLoading = false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad(text: 'Fetching data...');
    } else {
      if (_movies == null) {
        return FutureOnLoad(text: _failureMessage, isError: true);
      } else {
        return GridViewItems(items: _movies);
      }
    }
  }
}
