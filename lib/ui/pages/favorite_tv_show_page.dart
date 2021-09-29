import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class FavoriteTvShowPage extends StatefulWidget {
  const FavoriteTvShowPage({Key key}) : super(key: key);

  @override
  _FavoriteTvShowPageState createState() => _FavoriteTvShowPageState();
}

class _FavoriteTvShowPageState extends State<FavoriteTvShowPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Favorite TV Show Page',
          style: appBarTitleTextStyle,
        ),
      ),
    );
  }
}
