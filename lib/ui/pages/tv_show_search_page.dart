import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TvShowSearchPage extends StatefulWidget {
  final String query;
  final List<TvShowPopular> tvShows;
  final int results;

  const TvShowSearchPage({
    Key key,
    @required this.query,
    @required this.tvShows,
    @required this.results,
  }) : super(key: key);

  @override
  _TvShowSearchPageState createState() => _TvShowSearchPageState();
}

class _TvShowSearchPageState extends State<TvShowSearchPage> {
  // initialize atribute
  int _page = 2;
  int _totalItems = 0;

  @override
  Widget build(BuildContext context) {
    _totalItems = widget.tvShows.length;

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
            loadMoreSearchedTvShows();
          }
        }

        return GridItem(item: widget.tvShows[index]);
      },
      itemCount: _totalItems,
    );
  }

  Future<void> loadMoreSearchedTvShows() async {
    await TvShowServices.searchTvShows(
      page: _page,
      query: widget.query,
      onSuccess: (tvShows, _) {
        widget.tvShows.addAll(tvShows);
        _totalItems += tvShows.length;
        _page++;
      },
      onFailure: (_) {},
    ).then((_) {
      setState(() {});
    });
  }
}
