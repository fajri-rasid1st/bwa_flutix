import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/screens/movie_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/favorite_empty.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:cick_movie_app/ui/widgets/list_items.dart';
import 'package:flutter/material.dart';

class FavoriteMoviePage extends StatefulWidget {
  const FavoriteMoviePage({Key key}) : super(key: key);

  @override
  _FavoriteMoviePageState createState() => _FavoriteMoviePageState();
}

class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  List<Favorite> _movieFavorites;

  bool _isLoading = true;

  @override
  void initState() {
    getMovieFavorites().then((favorites) {
      setState(() {
        _movieFavorites = favorites;
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
      if (_movieFavorites.isEmpty) {
        return FavoriteEmpty(text: 'Movie');
      } else {
        return buildMovieFavoriteList(_movieFavorites);
      }
    }
  }

  Widget buildMovieFavoriteList(List<Favorite> movieFavorites) {
    return ListItems(
      items: movieFavorites,
      onTap: routeToMovieDetailScreen,
      onLongPress: showMovieFavoriteDialog,
    );
  }

  Future<void> routeToMovieDetailScreen(
    BuildContext context,
    Favorite item,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MovieDetailScreen(movieId: item.favoriteId);
        },
      ),
    ).then((_) {
      getMovieFavorites().then((favorites) {
        setState(() => _movieFavorites = favorites);
      });
    });
  }

  Future<void> showMovieFavoriteDialog(
    BuildContext context,
    Favorite item,
  ) async {
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
          Text(
            text,
            style: cardTitleTextStyle,
          )
        ],
      ),
    );
  }

  Future<List<Favorite>> getMovieFavorites() async {
    return await FavoriteDatabase.instance.readFavorites('movie');
  }
}
