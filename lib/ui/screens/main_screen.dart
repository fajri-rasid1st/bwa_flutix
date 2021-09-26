import 'package:cick_movie_app/ui/pages/movie_page.dart';
import 'package:cick_movie_app/ui/pages/tv_show_page.dart';
import 'package:cick_movie_app/ui/screens/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/scroll_to_hide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [MoviePage(), TvShowPage()];

  ScrollController _scrollController;

  int _currentIndex = 0;
  bool _isFabVisible = true;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/cickmovie_sm.png',
                    width: 32,
                  ),
                  const SizedBox(width: 8),
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
        body: NotificationListener<UserScrollNotification>(
          onNotification: (userScroll) {
            if (userScroll.direction == ScrollDirection.forward) {
              if (!_isFabVisible) {
                setState(() => _isFabVisible = true);
              }
            } else if (userScroll.direction == ScrollDirection.reverse) {
              if (_isFabVisible) {
                setState(() => _isFabVisible = false);
              }
            }

            return true;
          },
          child: _pages[_currentIndex],
        ),
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () => Utils.scrollToTop(controller: _scrollController),
              child: Icon(Icons.arrow_upward_rounded),
              foregroundColor: accentColor,
              backgroundColor: primaryTextColor.withOpacity(0.75),
              tooltip: 'Go to top',
            )
          : null,
      bottomNavigationBar: ScrollToHide(
        controller: _scrollController,
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
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
