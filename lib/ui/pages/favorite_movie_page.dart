import 'package:flutter/material.dart';

class FavoriteMoviePage extends StatefulWidget {
  const FavoriteMoviePage({Key key}) : super(key: key);

  @override
  _FavoriteMoviePageState createState() => _FavoriteMoviePageState();
}

class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Favorite'),
      ),
    );
  }
}
