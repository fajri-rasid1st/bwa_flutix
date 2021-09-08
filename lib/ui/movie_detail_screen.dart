import 'package:cick_movie_app/models/Movie.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Movie'),
      ),
    );
  }
}
