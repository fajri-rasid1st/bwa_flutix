import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        Center(
          child: Text('Favorite Movie Tab'),
        ),
        Center(
          child: Text('Favorite Tv Show Tab'),
        ),
      ],
    );
  }
}
