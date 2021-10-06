import 'dart:async';
import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/pages/favorite_page.dart';
import 'package:cick_movie_app/ui/pages/movie_page.dart';
import 'package:cick_movie_app/ui/pages/tv_show_page.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/widgets/default_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/favorite_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/scroll_to_hide.dart';
import 'package:cick_movie_app/ui/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // initialize atributes
  List<Widget> _pages = [];
  int _currentIndex = 0;
  bool _isFabVisible = true;

  // declaration attributes
  String _title;

  // declaration controller attributes
  TabController _tabController;
  ScrollController _scrollController;
  TextEditingController _searchController;

  // search atributes
  Timer _debouncer;
  bool _isSearching = false;
  String _query = '';

  @override
  void initState() {
    _title = 'Movies';

    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    _pages.addAll([
      MoviePage(),
      TvShowPage(),
      FavoritePage(controller: _tabController),
    ]);

    _searchController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();

    if (_debouncer != null) _debouncer.cancel();

    FavoriteDatabase.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: buildMainScreen(),
    );
  }

  Widget buildMainScreen() {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              if (_currentIndex != 2) ...[
                DefaultAppBar(
                  title: _isSearching ? buildSearchField() : buildTitle(_title),
                  leading: _isSearching ? buildLeading() : null,
                  actions: _isSearching ? null : buildActions(),
                )
              ] else ...[
                FavoriteAppBar(
                  title: _title,
                  controller: _tabController,
                )
              ]
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
      ),
      floatingActionButton: _isFabVisible && _currentIndex != 2
          ? FloatingActionButton(
              onPressed: () => _scrollController.jumpTo(0),
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
              _isSearching = false;

              switch (index) {
                case 0:
                  _title = 'Movies';

                  break;
                case 1:
                  _title = 'Tv Shows';

                  break;
                case 2:
                  _tabController.index = 0;
                  _title = 'Favorites';

                  break;
              }
            });

            _searchController.clear();
          },
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/cickmovie_sm.png',
          width: 32,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: appBarTitleTextStyle,
        )
      ],
    );
  }

  Widget buildSearchField() {
    return SearchField(
      query: _query,
      controller: _searchController,
      onChanged: searchContent,
    );
  }

  Widget buildLeading() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        onPressed: () {
          setState(() => _isSearching = false);
          _searchController.clear();
        },
        icon: Icon(
          Icons.arrow_back,
          color: defaultTextColor,
        ),
        tooltip: 'Back',
      ),
    );
  }

  List<Widget> buildActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          setState(() => _isSearching = true);
        },
        icon: Icon(
          Icons.search,
          color: defaultTextColor,
        ),
        tooltip: 'Search',
      )
    ];
  }

  Future<bool> onWillPop() {
    if (_isSearching) {
      setState(() => _isSearching = false);
      _searchController.clear();

      return Future.value(false);
    }

    return Future.value(true);
  }

  Future<void> searchContent(String query) async {
    if (query.isNotEmpty) {
      switch (_currentIndex) {
        case 0:
          debounce(() async {
            await MovieServices.searchMovies(
              query: query,
              onSuccess: (movies) {},
              onFailure: (message) {
                Utils.showSnackBarMessage(context: context, text: message);
              },
            ).then((_) {
              if (!mounted) return;

              setState(() {
                _query = query;
                print(_query);
              });
            });
          });

          break;
        case 1:
          debounce(() async {
            await TvShowServices.searchTvShows(
              query: query,
              onSuccess: (tvShows) {
                for (var item in tvShows) {
                  print('${item.posterPath} - ${item.title}');
                }
              },
              onFailure: (message) {
                Utils.showSnackBarMessage(context: context, text: message);
              },
            ).then((_) {
              if (!mounted) return;

              setState(() {
                _query = query;
                print(_query);
              });
            });
          });

          break;
      }
    }
  }

  void debounce(VoidCallback callback) {
    if (_debouncer != null) _debouncer.cancel();

    _debouncer = Timer(const Duration(seconds: 1), callback);
  }
}
