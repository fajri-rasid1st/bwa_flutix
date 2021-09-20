import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/grid_view_items.dart';
import 'package:flutter/material.dart';

class TvShowPage extends StatefulWidget {
  const TvShowPage({Key key}) : super(key: key);

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TvShowPopular>>(
      future: TvShowServices.getPopularTvShows(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FutureOnLoad(text: 'Fetching data...');
        } else {
          if (snapshot.hasError) {
            return FutureOnLoad(text: 'Request failed.', isError: true);
          }

          final tvShows = snapshot.data;

          return GridViewItems(items: tvShows);
        }
      },
    );
  }
}
