import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class PullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const PullToRefresh({
    Key key,
    @required this.child,
    @required this.onRefresh,
  }) : super(key: key);

  @override
  _PullToRefreshState createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: widget.child,
      onRefresh: widget.onRefresh,
      color: primaryColor,
    );
  }
}
