import 'package:cick_movie_app/pages/movie_page.dart';
import 'package:cick_movie_app/pages/tv_show_page.dart';
import 'package:cick_movie_app/style/color_scheme.dart';
import 'package:cick_movie_app/style/text_style.dart';
import 'package:cick_movie_app/ui/scroll_to_hide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final List<Widget> _pages = [MoviePage(), TvShowPage()];

  ScrollController _controller;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _controller,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.grey[50],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/cickmovie_sm.png',
                      width: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'CickMovie',
                      style: appBarTitleTextStyle,
                    )
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: primaryTextColor,
                    ),
                    tooltip: 'Search',
                  ),
                ],
              )
            ];
          },
          body: _pages[_currentIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: secondaryTextColor,
        child: Icon(
          Icons.play_arrow,
          color: accentColor,
        ),
        tooltip: 'Play',
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: ScrollToHideWidget(
        controller: _controller,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedFontSize: 12,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_outlined),
              activeIcon: Icon(Icons.movie_creation),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_display_outlined),
              activeIcon: Icon(Icons.smart_display),
              label: 'TV Shows',
            ),
          ],
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
