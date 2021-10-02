import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FutureOnLoad extends StatelessWidget {
  final String text;
  final bool isError;
  final Future<void> Function() onPressedErrorButton;
  final Widget errorButtonChild;

  const FutureOnLoad({
    Key key,
    this.text,
    this.isError = false,
    this.onPressedErrorButton,
    this.errorButtonChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isError
                  ? SvgPicture.asset(
                      'assets/svg/undraw_server_down_s4lk.svg',
                      height: 100,
                    )
                  : SpinKitThreeBounce(
                      size: 40,
                      color: secondaryColor,
                    ),
              if (isError) ...[
                const SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onPressedErrorButton,
                  child: errorButtonChild,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
