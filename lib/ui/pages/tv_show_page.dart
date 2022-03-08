import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
import 'package:cick_movie_app/ui/widgets/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TvShowPage extends StatefulWidget {
  const TvShowPage({Key key}) : super(key: key);

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  // initialize atribute
  int _page = 1;
  int _totalItems = 0;
  bool _isLoading = false;
  bool _isErrorButtonDisabled = false;
  Widget _errorButtonChild = const Text('Try again');

  // this attribute will be filled in the future
  List<TvShowPopular> _tvShows;
  String _failureMessage;

  @override
  void initState() {
    initPopularTvShows();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad();
    } else {
      if (_tvShows == null) {
        return FutureOnLoad(
          text: _failureMessage,
          isError: true,
          onPressedErrorButton:
              _isErrorButtonDisabled ? null : refreshPopularTvShows,
          errorButtonChild: _errorButtonChild,
        );
      } else {
        return PullToRefresh(
          onRefresh: refreshPopularTvShows,
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
                  loadMorePopularTvShows();
                }
              }

              return GridItem(item: _tvShows[index]);
            },
            itemCount: _totalItems,
          ),
        );
      }
    }
  }

  Future<void> initPopularTvShows() async {
    setState(() {
      _isLoading = true;
    });

    await TvShowServices.getPopularTvShows(
      onSuccess: (tvShow) {
        _tvShows = tvShow;
        _totalItems = tvShow.length;
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

  Future<void> loadMorePopularTvShows() async {
    await TvShowServices.getPopularTvShows(
      page: _page,
      onSuccess: (tvShows) {
        _tvShows.addAll(tvShows);
        _totalItems += tvShows.length;
        _page++;
      },
      onFailure: (message) {
        _failureMessage = message;
      },
    ).then((_) {
      setState(() {});
    });
  }

  Future<void> refreshPopularTvShows() async {
    if (_tvShows == null) {
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

    await TvShowServices.getPopularTvShows(
      onSuccess: (tvShows) {
        _tvShows = tvShows;
        _totalItems = tvShows.length;
        _page = 2;
        _failureMessage = null;
      },
      onFailure: (message) {
        Utils.showSnackBarMessage(context: context, text: message);
      },
    ).then((_) {
      setState(() {
        if (_tvShows == null) {
          _isErrorButtonDisabled = false;
          _errorButtonChild = const Text('Try again');
        }
      });
    });
  }
}
