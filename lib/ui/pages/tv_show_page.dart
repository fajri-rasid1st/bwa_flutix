import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_items.dart';
import 'package:flutter/material.dart';

class TvShowPage extends StatefulWidget {
  const TvShowPage({Key key}) : super(key: key);

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  // initialize atribute
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
      setState(() => _isLoading = false);
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
        return GridItems(items: _tvShows);
      }
    }
  }
}
