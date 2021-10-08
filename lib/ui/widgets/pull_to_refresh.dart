import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function({BuildContext context}) onRefresh;

  const PullToRefresh({
    Key key,
    @required this.child,
    @required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: () => onRefresh(context: context),
      color: primaryColor,
    );
  }
}
