import 'package:flutter/material.dart';

class Utils {
  // function to show snackbar with message
  static void showSnackBarMessage({
    @required BuildContext context,
    @required String text,
    int duration = 2000,
    bool showAction = false,
    Future<void> Function() action,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: duration),
      action: showAction
          ? SnackBarAction(
              label: 'Dismiss',
              onPressed: action,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // function to scroll page to top
  static void scrollToTop({@required ScrollController controller}) {
    const start = 0.0;
    var duration = controller.position.pixels.toInt() * 5;

    if (duration != 0) {
      controller.animateTo(
        start,
        duration: Duration(milliseconds: duration),
        curve: Curves.ease,
      );
    }
  }
}
