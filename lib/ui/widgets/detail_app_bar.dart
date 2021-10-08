import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class DetailAppBar extends StatelessWidget {
  final String title;
  final Icon favoriteIcon;
  final Future<void> Function(BuildContext context) onPressedFavoriteIcon;

  const DetailAppBar({
    Key key,
    @required this.title,
    @required this.favoriteIcon,
    @required this.onPressedFavoriteIcon,
  }) : super(key: key);

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
        title,
        style: appBarTitleTextStyle,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.chevron_left,
          color: defaultTextColor,
        ),
        tooltip: 'Back',
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => onPressedFavoriteIcon(context),
          icon: favoriteIcon,
          tooltip: 'Favorite',
        ),
      ],
      bottom: DetailBottomAppBar(),
    );
  }
}

class DetailBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Size preferredSize = Size.fromHeight(40); // default is 56.0

  DetailBottomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          child: Text(
            'Detail',
            style: TextStyle(fontSize: 30),
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
