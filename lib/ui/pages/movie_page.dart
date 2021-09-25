import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  // initialize atribute
  int _page = 1;
  bool _isLoading = true;
  bool _isScrollPositionAtBottom = false;

  // this attribute will be filled in the future
  List<MoviePopular> _movies;
  String _failureMessage;
  bool _hasError;

  @override
  void initState() {
    MovieServices.getPopularMovies(
      onSuccess: (movies) => _movies = movies,
      onFailure: (message) => _failureMessage = message,
    ).then((_) {
      setState(() {
        _isLoading = false;
        _page++;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad(text: 'Fetching data...');
    } else {
      if (_movies == null) {
        return FutureOnLoad(text: _failureMessage, isError: true);
      } else {
        return NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            var metrics = scrollEnd.metrics;

            if (metrics.atEdge) {
              if (metrics.pixels != 0) {
                setState(() => _isScrollPositionAtBottom = true);

                MovieServices.getPopularMovies(
                  page: _page,
                  onSuccess: (movies) {
                    _movies.addAll(movies);
                    _hasError = false;
                  },
                  onFailure: (_) {
                    _hasError = true;
                  },
                ).then((_) {
                  setState(() {
                    _isScrollPositionAtBottom = false;
                    if (!_hasError) _page++;
                  });
                });
              }
            }

            return true;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: <Widget>[
                  GridItems(items: _movies),
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
                  ],
                ],
              );
            },
          ),
        );
      }
    }
  }
}
