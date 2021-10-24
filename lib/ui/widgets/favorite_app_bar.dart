import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class FavoriteAppBar extends StatelessWidget {
  final String title;
  final bool innerBoxIsScrolled;
  final TabController controller;

  const FavoriteAppBar({
    Key key,
    @required this.title,
    @required this.innerBoxIsScrolled,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      elevation: 2,
      backgroundColor: backgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/cickmovie_sm.png',
            width: 32,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: appBarTitleTextStyle,
          )
        ],
      ),
      bottom: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: secondaryColor,
        tabs: <Widget>[
          Tab(
            child: Text(
              'Movies',
              style: titleTextStyle,
            ),
          ),
          Tab(
            child: Text(
              'Tv Shows',
              style: titleTextStyle,
            ),
          ),
        ],
      ),
      forceElevated: innerBoxIsScrolled,
    );
  }
}
