import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class FavoriteAppBar extends StatelessWidget {
  final String title;

  const FavoriteAppBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
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
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: secondaryColor,
        tabs: <Widget>[
          Tab(
            child: Text(
              'Movies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Tv Shows',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
