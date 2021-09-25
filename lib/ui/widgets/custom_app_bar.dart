import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget {
  final String title;

  const CustomAppbar({Key key, @required this.title}) : super(key: key);

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
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
            Icons.favorite_outline,
            color: primaryTextColor,
          ),
          tooltip: 'Favorite',
        ),
      ],
      bottom: CustomBottomAppBar(),
    );
  }
}

class CustomBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Size preferredSize = Size.fromHeight(44); // default is 56.0

  CustomBottomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 44,
          child: Text(
            'Detail',
            style: TextStyle(
              fontSize: 30,
              color: primaryTextColor,
            ),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
