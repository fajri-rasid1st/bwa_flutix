import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(100); // default is 56.0
  final String title;

  CustomAppBar({Key key, @required this.title}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBar(
            elevation: 0,
            backgroundColor: backgroundColor,
            centerTitle: true,
            title: Text(
              widget.title,
              style: appBarTitleTextStyle,
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  color: primaryColor,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
