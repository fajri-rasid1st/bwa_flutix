import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class Utils {
  // function to show snackbar with message
  static void showSnackBarMessage({
    @required BuildContext context,
    @required String text,
    int duration = 2000,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: duration),
      ),
    );
  }

  // function to scroll page to top
  static void scrollToTop({@required ScrollController controller}) {
    final start = 0.0;
    var duration = controller.position.pixels.toInt() * 5;

    if (duration != 0) {
      controller.animateTo(
        start,
        duration: Duration(milliseconds: duration),
        curve: Curves.ease,
      );
    }
  }

  // function to create divider
  static Widget buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: dividerColor,
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 0.5),
            blurRadius: 1,
            color: dividerColor,
          ),
          BoxShadow(
            offset: Offset(0.5, 0),
            blurRadius: 1,
            color: dividerColor,
          ),
        ],
      ),
    );
  }
}
