import 'package:cick_movie_app/data/models/tv_show_popular.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/widgets/grid_view_items.dart';
import 'package:flutter/material.dart';

class TvShowPage extends StatefulWidget {
  const TvShowPage({Key key}) : super(key: key);

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  List<TvShowPopular> tvShows = [];

  @override
  void initState() {
    TvShowServices.getPopularTvShows(1).then((tvShows) {
      this.tvShows = tvShows;

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridViewItems(items: tvShows);
  }
}
