import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final List<Widget> actions;

  const DefaultAppBar({
    Key key,
    @required this.title,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: backgroundColor,
      title: title,
      leading: leading,
      leadingWidth: 40,
      actions: actions,
    );
  }
}
