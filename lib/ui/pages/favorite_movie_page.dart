import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/widgets/favorite_empty.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:flutter/material.dart';

class FavoriteMoviePage extends StatefulWidget {
  const FavoriteMoviePage({Key key}) : super(key: key);

  @override
  _FavoriteMoviePageState createState() => _FavoriteMoviePageState();
}

class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  List<Favorite> _movieFavorites;
  
  bool _isLoading = true;

  @override
  void initState() {
    getMovieFavorites();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad(text: 'Please wait...');
    } else {
      if (_movieFavorites.isEmpty) {
        return FavoriteEmpty(text: 'Movie');
      } else {
        return Text('Asiap');
      }
    }
  }

  Future<void> getMovieFavorites() async {
    _movieFavorites = await FavoriteDatabase.instance.readFavorites('movie');

    setState(() => _isLoading = false);
  }
}
