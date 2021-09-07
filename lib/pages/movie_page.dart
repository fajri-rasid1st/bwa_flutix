import 'package:cick_movie_app/models/Movie.dart';
import 'package:cick_movie_app/pages/grid_view_items.dart';
import 'package:cick_movie_app/ui/movie_detail_screen.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridViewItems(items: movies, routeScreen: MovieDetailScreen());
  }
}
