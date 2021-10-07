import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
import 'package:cick_movie_app/ui/widgets/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviePage extends StatefulWidget {
  final List<MoviePopular> movies;

  const MoviePage({Key key, this.movies}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  // initialize atribute
  int _page = 1;
  bool _isLoading = true;
  bool _isScrollPositionAtBottom = false;
  bool _isErrorButtonDisabled = false;
  Widget _errorButtonChild = const Text('Try again');

  // this attribute will be filled in the future
  List<MoviePopular> _movies;
  MoviePopular _lastInsertedMovie;
  String _failureMessage;

  @override
  void initState() {
    initPopularMovies();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad();
    } else {
      if (_movies == null) {
        return FutureOnLoad(
          text: _failureMessage,
          isError: true,
          onPressedErrorButton:
              _isErrorButtonDisabled ? null : refreshPopularMovies,
          errorButtonChild: _errorButtonChild,
        );
      } else {
        return NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;

            if (metrics.atEdge) {
              if (metrics.pixels != 0) {
                loadMorePopularMovies();
              }
            }

            return true;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: <Widget>[
                  PullToRefresh(
                    onRefresh: refreshPopularMovies,
                    child: StaggeredGridView.extentBuilder(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      maxCrossAxisExtent: 200,
                      staggeredTileBuilder: (index) {
                        return const StaggeredTile.extent(1, 320);
                      },
                      itemBuilder: (context, index) {
                        return GridItem(
                            item: widget.movies != null
                                ? widget.movies[index]
                                : _movies[index]);
                      },
                      itemCount: widget.movies != null
                          ? widget.movies.length
                          : _movies.length,
                    ),
                  ),
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
    }
  }

  Future<void> initPopularMovies() async {
    await MovieServices.getPopularMovies(
      onSuccess: (movies) {
        _movies = movies;
        _lastInsertedMovie = _movies[0];
      },
      onFailure: (message) {
        _failureMessage = message;
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
        _page++;
      });
    });
  }

  Future<void> loadMorePopularMovies() async {
    setState(() => _isScrollPositionAtBottom = true);

    await MovieServices.getPopularMovies(
      page: _page,
      onSuccess: (movies) {
        if (_lastInsertedMovie.toString() != movies[0].toString()) {
          _movies.addAll(movies);

          _lastInsertedMovie = movies[0];

          _page++;
        }
      },
      onFailure: (_) {},
    ).then((_) {
      setState(() => _isScrollPositionAtBottom = false);
    });
  }

  Future<void> refreshPopularMovies() async {
    if (_movies == null) {
      setState(() {
        _isErrorButtonDisabled = true;
        _errorButtonChild = Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Fetching data...'),
          ],
        );
      });
    }

    await Future.delayed(Duration(milliseconds: 1500));

    await MovieServices.getPopularMovies(
      onSuccess: (movies) {
        _movies = movies;
        _lastInsertedMovie = _movies[0];
      },
      onFailure: (message) {
        Utils.showSnackBarMessage(context: context, text: message);
      },
    ).then((_) {
      setState(() {
        if (_movies == null) {
          _isErrorButtonDisabled = false;
          _errorButtonChild = const Text('Try again');
        }

        _page = 2;
      });
    });
  }
}
