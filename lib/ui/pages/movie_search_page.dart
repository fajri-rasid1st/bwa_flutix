import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
import 'package:cick_movie_app/ui/widgets/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieSearchPage extends StatefulWidget {
  final String query;
  final List<MoviePopular> movies;
  final int results;

  const MovieSearchPage({
    Key key,
    @required this.query,
    @required this.movies,
    @required this.results,
  }) : super(key: key);

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  // initialize atribute
  int _page = 2;
  int _totalItems = 0;

  // this attribute will be filled in the future
  String _failureMessage;

  @override
  Widget build(BuildContext context) {
    _totalItems = widget.movies.length;

    return PullToRefresh(
      child: StaggeredGridView.extentBuilder(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        maxCrossAxisExtent: 200,
        staggeredTileBuilder: (index) {
          return const StaggeredTile.extent(1, 320);
        },
        itemBuilder: (context, index) {
          if (widget.results != _totalItems) {
            if (_failureMessage == null) {
              if (index == _totalItems - 1) {
                loadMoreSearchedMovies();
              }
            }
          }

          return GridItem(item: widget.movies[index]);
        },
        itemCount: _totalItems,
      ),
      onRefresh: refreshSearchedMovies,
    );
  }

  Future<void> loadMoreSearchedMovies() async {
    await MovieServices.searchMovies(
      page: _page,
      query: widget.query,
      onSuccess: (movies, _) {
        widget.movies.addAll(movies);
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

  Future<void> refreshSearchedMovies() async {
    await Future.delayed(Duration(milliseconds: 1500));

    await MovieServices.searchMovies(
      query: widget.query,
      onSuccess: (movies, results) {
        widget.movies.clear();
        widget.movies.addAll(movies);

        _totalItems = movies.length;
        _page = 2;
        _failureMessage = null;

        Utils.showSnackBarMessage(
          context: context,
          text: 'Found $results result(s)',
        );
      },
      onFailure: (message) {
        Utils.showSnackBarMessage(context: context, text: message);
      },
    ).then((_) {
      setState(() {});
    });
  }
}
