import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
import 'package:cick_movie_app/ui/widgets/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  // initialize atribute
  int _page = 1;
  int _totalItems = 0;
  bool _isLoading = false;
  bool _isErrorButtonDisabled = false;
  Widget _errorButtonChild = const Text('Try again');

  // this attribute will be filled in the future
  List<MoviePopular> _movies;
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
        return PullToRefresh(
          onRefresh: refreshPopularMovies,
          child: StaggeredGridView.extentBuilder(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
            physics: const BouncingScrollPhysics(),
            maxCrossAxisExtent: 200,
            staggeredTileBuilder: (index) {
              return const StaggeredTile.extent(1, 320);
            },
            itemBuilder: (context, index) {
              if (_failureMessage == null) {
                if (index == _totalItems - 1) {
                  loadMorePopularMovies();
                }
              }

              return GridItem(item: _movies[index]);
            },
            itemCount: _totalItems,
          ),
        );
      }
    }
  }

  Future<void> initPopularMovies() async {
    setState(() {
      _isLoading = true;
    });

    await MovieServices.getPopularMovies(
      onSuccess: (movies) {
        _movies = movies;
        _totalItems = movies.length;
        _page++;
      },
      onFailure: (message) {
        _failureMessage = message;
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> loadMorePopularMovies() async {
    await MovieServices.getPopularMovies(
      page: _page,
      onSuccess: (movies) {
        _movies.addAll(movies);
        _totalItems += movies.length;
        _page++;
      },
      onFailure: (message) {
        _failureMessage = message;
      },
    ).then((_) {
      setState(() {});
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

    await Future.delayed(const Duration(milliseconds: 1500));

    await MovieServices.getPopularMovies(
      onSuccess: (movies) {
        _movies = movies;
        _totalItems = movies.length;
        _page = 2;
        _failureMessage = null;
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
      });
    });
  }
}
