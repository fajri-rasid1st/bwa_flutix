import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
