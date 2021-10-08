import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TvShowSearchPage extends StatefulWidget {
  final String query;
  final List<TvShowPopular> tvShows;

  const TvShowSearchPage({
    Key key,
    @required this.query,
    @required this.tvShows,
  }) : super(key: key);

  @override
  _TvShowSearchPageState createState() => _TvShowSearchPageState();
}

class _TvShowSearchPageState extends State<TvShowSearchPage> {
  // initialize atribute
  int _page = 2;
  bool _isScrollPositionAtBottom = false;

  // declaration atribute
  TvShowPopular _lastInsertedTvShow;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;

        if (metrics.atEdge) {
          if (metrics.pixels != 0) {
            setState(() => _isScrollPositionAtBottom = true);
            loadMoreSearchedTvShows();
          }
        }

        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              GridItems(items: widget.tvShows),
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

  Future<void> loadMoreSearchedTvShows() async {
    await TvShowServices.searchTvShows(
      page: _page,
      query: widget.query,
      onSuccess: (tvShows) {
        if (_lastInsertedTvShow != null) {
          if (_lastInsertedTvShow.toString() != tvShows.first.toString()) {
            widget.tvShows.addAll(tvShows);

            _lastInsertedTvShow = tvShows.first;

            _page++;
          }
        } else {
          _lastInsertedTvShow = tvShows.first;
        }
      },
      onFailure: (message) {
        Utils.showSnackBarMessage(context: context, text: message);
      },
    ).then((_) {
      setState(() => _isScrollPositionAtBottom = false);
    });
  }
}
