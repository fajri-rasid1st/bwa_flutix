import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final Widget title;
  final bool innerBoxIsScrolled;
  final Widget leading;
  final List<Widget> actions;

  const MainAppBar({
    Key key,
    @required this.title,
    @required this.innerBoxIsScrolled,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: backgroundColor, // Theme.of(context).scaffoldBackgroundColor
      title: title,
      leading: leading,
      leadingWidth: 40,
      actions: actions,
      forceElevated: innerBoxIsScrolled,
    );
  }
}
