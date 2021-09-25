import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MoviePage extends StatefulWidget {
  final ScrollController controller;

  MoviePage({Key key, @required this.controller}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  // initialize atribute
  int _page = 1;
  bool _isLoading = true;

  // this attribute will be filled in the future
  List<MoviePopular> _movies;
  String _failureMessage;

  @override
  void initState() {
    MovieServices.getPopularMovies(
      onSuccess: (movies) => _movies = movies,
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

      MovieServices.getPopularMovies(
        page: _page,
        onSuccess: (movies) => _movies.addAll(movies),
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
      if (_movies == null) {
        return FutureOnLoad(text: _failureMessage, isError: true);
      } else {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                GridItems(items: _movies),
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
