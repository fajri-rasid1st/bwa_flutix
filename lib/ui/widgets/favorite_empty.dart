import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoriteEmpty extends StatelessWidget {
  final String text;

  const FavoriteEmpty({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/svg/undraw_Taken_re_yn20.svg',
                height: 160,
              ),
              const SizedBox(height: 12),
              Text(
                'Your Favorite $text Still Empty',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Press the heart icon on $text detail to add a list of favorite $text.',
                textAlign: TextAlign.center,
                style: secondaryTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
