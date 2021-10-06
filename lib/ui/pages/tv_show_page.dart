import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_item.dart';
import 'package:cick_movie_app/ui/widgets/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TvShowPage extends StatefulWidget {
  const TvShowPage({Key key}) : super(key: key);

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  // initialize atribute
  int _page = 1;
  bool _isLoading = true;
  bool _isScrollPositionAtBottom = false;
  bool _isErrorButtonDisabled = false;
  Widget _errorButtonChild = const Text('Try again');

  // this attribute will be filled in the future
  List<TvShowPopular> _tvShows;
  TvShowPopular _lastInsertedTvShow;
  String _failureMessage;

  @override
  void initState() {
    initFavoriteTvShows();

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
        return NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;

            if (metrics.atEdge) {
              if (metrics.pixels != 0) {
                loadMorePopularTvShows();
              }
            }

            return true;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: <Widget>[
                  PullToRefresh(
                    onRefresh: refreshPopularTvShows,
                    child: StaggeredGridView.extentBuilder(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
                      shrinkWrap: true,
                      maxCrossAxisExtent: 200,
                      staggeredTileBuilder: (index) {
                        return const StaggeredTile.extent(1, 320);
                      },
                      itemBuilder: (context, index) {
                        return GridItem(item: _tvShows[index]);
                      },
                      itemCount: _tvShows.length,
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

  Future<void> initFavoriteTvShows() async {
    await TvShowServices.getPopularTvShows(
      onSuccess: (tvShow) {
        _tvShows = tvShow;
        _lastInsertedTvShow = _tvShows[0];
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

  Future<void> loadMorePopularTvShows() async {
    setState(() => _isScrollPositionAtBottom = true);

    await TvShowServices.getPopularTvShows(
      page: _page,
      onSuccess: (tvShows) {
        if (_lastInsertedTvShow.toString() != tvShows[0].toString()) {
          _tvShows.addAll(tvShows);

          _lastInsertedTvShow = tvShows[0];

          _page++;
        }
      },
      onFailure: (_) {},
    ).then((_) {
      setState(() => _isScrollPositionAtBottom = false);
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

    await Future.delayed(Duration(milliseconds: 1500));

    await TvShowServices.getPopularTvShows(
      onSuccess: (tvShows) {
        _tvShows = tvShows;
        _lastInsertedTvShow = _tvShows[0];
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

        _page = 2;
      });
    });
  }
}
