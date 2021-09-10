import 'package:cick_movie_app/models/Movie.dart';
import 'package:cick_movie_app/style/color_scheme.dart';
import 'package:cick_movie_app/style/text_style.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({@required this.movie});

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
                  movie.title,
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
            ];
          },
          body: Container(
            color: Colors.blue[50],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: primarySwatch,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
