import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/screens/tv_show_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/favorite_empty.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/list_items.dart';
import 'package:flutter/material.dart';

class FavoriteTvShowPage extends StatefulWidget {
  const FavoriteTvShowPage({Key key}) : super(key: key);

  @override
  _FavoriteTvShowPageState createState() => _FavoriteTvShowPageState();
}

class _FavoriteTvShowPageState extends State<FavoriteTvShowPage> {
  List<Favorite> _tvShowFavorites;

  bool _isLoading = true;

  @override
  void initState() {
    getTvShowFavorites().then((favorites) {
      setState(() {
        _tvShowFavorites = favorites;
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const FutureOnLoad();
    } else {
      if (_tvShowFavorites.isEmpty) {
        return FavoriteEmpty(text: 'Tv Show');
      } else {
        return buildTvShowFavoriteList(_tvShowFavorites);
      }
    }
  }

  Widget buildTvShowFavoriteList(List<Favorite> tvShowFavorites) {
    return ListItems(
      items: tvShowFavorites,
      onTap: routeToTvShowDetailScreen,
      onLongPress: showTvShowFavoriteDialog,
    );
  }

  Future<void> routeToTvShowDetailScreen(Favorite item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TvShowDetailScreen(tvShowId: item.favoriteId);
        },
      ),
    ).then((_) {
      getTvShowFavorites().then((favorites) {
        setState(() => _tvShowFavorites = favorites);
      });
    });
  }

  Future<void> showTvShowFavoriteDialog(Favorite item) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: titleTextStyle,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildDialogOption(Icons.delete_outline, 'Delete'),
                    const SizedBox(width: 24),
                    buildDialogOption(Icons.info_outline, 'Detail'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDialogOption(IconData icon, String text) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: defaultTextColor,
          ),
          const SizedBox(height: 4),
          Text(text)
        ],
      ),
    );
  }

  Future<List<Favorite>> getTvShowFavorites() async {
    return await FavoriteDatabase.instance.readFavorites('tv_show');
  }
}
