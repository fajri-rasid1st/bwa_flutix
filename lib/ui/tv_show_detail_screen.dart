import 'package:cick_movie_app/models/TvShow.dart';
import 'package:cick_movie_app/style/color_scheme.dart';
import 'package:cick_movie_app/style/text_style.dart';
import 'package:flutter/material.dart';

class TvShowDetailScreen extends StatelessWidget {
  final TvShow tvShow;

  const TvShowDetailScreen({@required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.grey[50],
                title: Text(
                  tvShow.title,
                  style: appBarTitleTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.chevron_left,
                    color: primaryTextColor,
                  ),
                  tooltip: 'Back',
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: primaryTextColor,
                    ),
                    tooltip: 'Search',
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: accentColor,
                      ),
                    ),
                  ),
                  child: Text(
                    'Detail',
                    style: appBarTitleTextStyle,
                  ),
                ),
              ),
            ];
          },
          body: Center(),
        ),
      ),
    );
  }
}
