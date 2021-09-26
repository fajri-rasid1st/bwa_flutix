import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
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
        return FutureOnLoad(text: _failureMessage, isError: true);
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
                    if (!_hasError) _page++;
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
                  GridItems(items: _tvShows),
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
