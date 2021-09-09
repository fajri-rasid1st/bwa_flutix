import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidget extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  final Duration duration;

  const ScrollToHideWidget({
    Key key,
    @required this.controller,
    @required this.child,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  _ScrollToHideWidgetState createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listen);
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;

    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!_isVisible) setState(() => _isVisible = true);
  }

  void hide() {
    if (_isVisible) setState(() => _isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: _isVisible ? kBottomNavigationBarHeight : 0,
      curve: _isVisible ? Curves.easeOut : Curves.easeIn,
      child: Wrap(children: <Widget>[widget.child]),
    );
  }
}
