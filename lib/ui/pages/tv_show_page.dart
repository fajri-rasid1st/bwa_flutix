import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TvShowPage extends StatefulWidget {
  final ScrollController controller;

  const TvShowPage({Key key, @required this.controller}) : super(key: key);

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  // initialize atribute
  int _page = 1;
  bool _isLoading = true;

  // this attribute will be filled in the future
  List<TvShowPopular> _tvShows;
  String _failureMessage;

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

    widget.controller.addListener(listen);

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);

    super.dispose();
  }

  void listen() {
    if (widget.controller.position.pixels ==
        widget.controller.position.maxScrollExtent) {
      _isLoading = true;

      TvShowServices.getPopularTvShows(
        page: _page,
        onSuccess: (tvShows) => _tvShows.addAll(tvShows),
        onFailure: (message) => _failureMessage = message,
      ).then((_) {
        setState(() {
          _isLoading = false;
          _page++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad(text: 'Fetching data...');
    } else {
      if (_tvShows == null) {
        return FutureOnLoad(text: _failureMessage, isError: true);
      } else {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                GridItems(items: _tvShows),
                if (_isLoading) ...[
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: constraints.maxWidth,
                      height: 40,
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
        );
      }
    }
  }
}
