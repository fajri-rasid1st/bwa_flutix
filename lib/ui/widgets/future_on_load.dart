import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FutureOnLoad extends StatelessWidget {
  final String text;
  final bool isError;

  const FutureOnLoad({
    Key key,
    @required this.text,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isError
                ? Icon(
                    Icons.wifi_off,
                    size: 75,
                    color: secondaryColor,
                  )
                : SpinKitThreeBounce(
                    size: 40,
                    color: secondaryColor,
                  ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
