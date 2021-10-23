import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
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

  @override
  Widget build(BuildContext context) {
    _totalItems = widget.movies.length;

    return StaggeredGridView.extentBuilder(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      maxCrossAxisExtent: 200,
      staggeredTileBuilder: (index) {
        return const StaggeredTile.extent(1, 320);
      },
      itemBuilder: (context, index) {
        if (widget.results != _totalItems) {
          if (index == _totalItems - 1) {
            loadMoreSearchedMovies();
          }
        }

        return GridItem(item: widget.movies[index]);
      },
      itemCount: _totalItems,
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
      onFailure: (_) {},
    ).then((_) {
      setState(() {});
    });
  }
}
