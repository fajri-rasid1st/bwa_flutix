import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  final String title;
  final bool innerBoxIsScrolled;

  const DefaultAppBar({
    Key key,
    @required this.title,
    @required this.innerBoxIsScrolled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 2,
      forceElevated: innerBoxIsScrolled,
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
    );
  }
}
