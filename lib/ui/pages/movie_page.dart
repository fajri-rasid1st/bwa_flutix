import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
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
        final movies = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(color: tertiaryTextColor),
              width: 75,
              height: 75,
            ),
          );
        } else {
          if (snapshot.hasError) Center(child: Text('Request failed.'));

          return GridViewItems(items: movies);
        }
      },
    );
  }
}
