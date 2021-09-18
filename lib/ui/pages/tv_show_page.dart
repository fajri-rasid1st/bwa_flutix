import 'package:cick_movie_app/data/models/tv_show.dart';
import 'package:cick_movie_app/ui/widgets/grid_view_items.dart';
import 'package:flutter/material.dart';

class TvShowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridViewItems(items: tvShows);
  }
}
