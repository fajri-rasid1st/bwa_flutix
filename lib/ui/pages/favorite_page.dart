import 'package:cick_movie_app/ui/pages/favorite_movie_page.dart';
import 'package:cick_movie_app/ui/pages/favorite_tv_show_page.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  final TabController controller;

  const FavoritePage({Key key, @required this.controller}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      children: const <Widget>[
        FavoriteMoviePage(),
        FavoriteTvShowPage(),
      ],
    );
  }
}
