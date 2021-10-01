import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/screens/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:cick_movie_app/ui/widgets/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  Widget _errorButtonChild = const Text('Try again');

  // this attribute will be filled in the future
  List<TvShowPopular> _tvShows;
  String _failureMessage;
  bool _hasError;

  @override
  void initState() {
    TvShowServices.getPopularTvShows(
      onSuccess: (tvShow) => _tvShows = tvShow,
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
      if (_tvShows == null) {
        return FutureOnLoad(
          text: _failureMessage,
          isError: true,
          onPressedErrorButton: loadPopularTvShows,
          errorButtonChild: _errorButtonChild,
        );
      } else {
        return NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            var metrics = scrollEnd.metrics;

            if (metrics.atEdge) {
              if (metrics.pixels != 0) {
                setState(() => _isScrollPositionAtBottom = true);

                TvShowServices.getPopularTvShows(
                  page: _page,
                  onSuccess: (tvShows) {
                    _tvShows.addAll(tvShows);
                    _hasError = false;
                  },
                  onFailure: (_) {
                    _hasError = true;
                  },
                ).then((_) {
                  setState(() {
                    if (_hasError == false) _page++;
                    _isScrollPositionAtBottom = false;
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
                  PullToRefresh(
                    child: GridItems(items: _tvShows),
                    onRefresh: loadPopularTvShows,
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

  Future<void> loadPopularTvShows() async {
    if (_tvShows == null) {
      setState(() {
        _errorButtonChild = Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Fetching data...'),
          ],
        );
      });
    }

    await Future.delayed(Duration(milliseconds: 1500));

    TvShowServices.getPopularTvShows(
      onSuccess: (tvShows) {
        _tvShows = tvShows;
      },
      onFailure: (message) {
        Utils.showSnackBarMessage(context: context, text: message);
      },
    ).then((_) {
      setState(() {
        if (_tvShows == null) {
          _errorButtonChild = const Text('Try again');
        }
        
        _page = 2;
      });
    });
  }
}
