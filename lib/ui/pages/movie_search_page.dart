import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovieSearchPage extends StatefulWidget {
  final String query;
  final List<MoviePopular> movies;

  const MovieSearchPage({
    Key key,
    @required this.query,
    @required this.movies,
  }) : super(key: key);

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  // initialize atribute
  int _page = 2;
  bool _isScrollPositionAtBottom = false;

  // declaration atribute
  MoviePopular _lastInsertedMovie;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;

        if (metrics.atEdge) {
          if (metrics.pixels != 0) {
            setState(() => _isScrollPositionAtBottom = true);
            loadMoreSearchedMovies();
          }
        }

        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              GridItems(items: widget.movies),
              if (_isScrollPositionAtBottom) ...[
                Positioned(
                  left: 0,
                  bottom: 12,
                  child: Container(
                    width: constraints.maxWidth,
                    height: 32,
                    child: Center(
                      child: SpinKitThreeBounce(
                        size: 20,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                )
              ]
            ],
          );
        },
      ),
    );
  }

  Future<void> loadMoreSearchedMovies() async {
    await MovieServices.searchMovies(
      page: _page,
      query: widget.query,
      onSuccess: (movies) {
        if (_lastInsertedMovie == null) {
          _lastInsertedMovie = widget.movies.first;
        }

        if (_lastInsertedMovie.toString() != movies.first.toString()) {
          widget.movies.addAll(movies);

          _lastInsertedMovie = movies.first;

          _page++;
        }
      },
      onFailure: (message) {
        Utils.showSnackBarMessage(context: context, text: message);
      },
    ).then((_) {
      setState(() => _isScrollPositionAtBottom = false);
    });
  }
}
