import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/ui/pages/favorite_page.dart';
import 'package:cick_movie_app/ui/pages/movie_page.dart';
import 'package:cick_movie_app/ui/pages/tv_show_page.dart';
import 'package:cick_movie_app/ui/screens/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/default_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/favorite_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/scroll_to_hide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // initialize final atribute
  final List<Widget> _pages = [];

  // initialize atribute
  int _currentIndex = 0;
  bool _isFabVisible = true;

  // declaration attribute
  ScrollController _scrollController;
  TabController _tabController;
  Widget _appBar;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _appBar = const DefaultAppBar(title: 'Movies');

    _pages.addAll([
      MoviePage(),
      TvShowPage(),
      FavoritePage(controller: _tabController),
    ]);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();

    FavoriteDatabase.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[_appBar];
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
      floatingActionButton: _isFabVisible && _currentIndex != 2
          ? FloatingActionButton(
              onPressed: () => Utils.scrollToTop(controller: _scrollController),
              child: Icon(Icons.arrow_upward_rounded),
              foregroundColor: accentColor,
              backgroundColor: primaryTextColor,
              tooltip: 'Go to top',
            )
          : null,
      bottomNavigationBar: ScrollToHide(
        controller: _scrollController,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            opacity: 1,
            color: primaryColor,
          ),
          unselectedIconTheme: IconThemeData(
            opacity: 1,
            color: secondaryColor,
          ),
          selectedFontSize: 0, // fix bug when clicking bottom nav label
          unselectedFontSize: 0, // fix bug when clicking bottom nav label
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
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;

              switch (index) {
                case 0:
                  _appBar = DefaultAppBar(title: 'Movies');
                  break;
                case 1:
                  _appBar = DefaultAppBar(title: 'TV Shows');
                  break;
                case 2:
                  _appBar = FavoriteAppBar(
                    title: 'Favorites',
                    controller: _tabController,
                  );
                  break;
              }
            });
          },
        ),
      ),
    );
  }
}
