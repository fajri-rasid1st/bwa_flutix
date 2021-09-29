import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/widgets/favorite_empty.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:flutter/material.dart';

class FavoriteTvShowPage extends StatefulWidget {
  const FavoriteTvShowPage({Key key}) : super(key: key);

  @override
  _FavoriteTvShowPageState createState() => _FavoriteTvShowPageState();
}

class _FavoriteTvShowPageState extends State<FavoriteTvShowPage> {
  List<Favorite> _tvShowFavorites = [];

  bool _isLoading = true;

  @override
  void initState() {
    getTvShowFavorites();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad(text: 'Please wait...');
    } else {
      if (_tvShowFavorites.isEmpty) {
        return FavoriteEmpty(text: 'Tv Show');
      } else {
        return Text('Asiap');
      }
    }
  }

  Future<void> getTvShowFavorites() async {
    _tvShowFavorites = await FavoriteDatabase.instance.readFavorites('tv_show');

    setState(() => _isLoading = false);
  }
}
