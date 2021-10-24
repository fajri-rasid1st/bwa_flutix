import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/screens/movie_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/utils.dart';
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
  // declaration attribute
  List<Favorite> _movieFavorites;

  // initialization attribute
  bool _isLoading = true;

  @override
  void initState() {
    // get all favorite movies from database
    getFavoriteMovies().then((favorites) {
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

  // function to build movie favorite list items
  Widget buildMovieFavoriteList(List<Favorite> movieFavorites) {
    return ListItems(
      items: movieFavorites,
      onTap: routeToMovieDetailScreen,
      onLongPress: showMovieFavoriteDialog,
    );
  }

  // function to build dialog option
  Widget buildDialogOption({
    Favorite movie,
    IconData icon,
    String text,
    Future<void> Function(Favorite movie) onTap,
  }) {
    return InkWell(
      onTap: () => onTap(movie),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: defaultTextColor,
              ),
              const SizedBox(height: 4),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }

  // function to route to movie detail screen, when tapped favorite movie item
  Future<void> routeToMovieDetailScreen(Favorite movie) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MovieDetailScreen(movieId: movie.favoriteId);
        },
      ),
    ).then((_) {
      getFavoriteMovies().then((favorites) {
        setState(() => _movieFavorites = favorites);
      });
    });
  }

  // function to show movie favorite dialog, when on long pressed favorite movie item
  Future<void> showMovieFavoriteDialog(Favorite movie) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionBuilder: (context, animStart, animEnd, widget) {
        final curvedValue = Curves.ease.transform(animStart.value) - 3.75;

        return Transform(
          transform: Matrix4.translationValues(0, (curvedValue * -100), 0),
          child: Opacity(
            opacity: animStart.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      movie.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: titleTextStyle,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildDialogOption(
                          movie: movie,
                          icon: Icons.delete_outline,
                          text: 'Delete',
                          onTap: removeMovieFromFavorite,
                        ),
                        const SizedBox(width: 20),
                        buildDialogOption(
                          movie: movie,
                          icon: Icons.info_outlined,
                          text: 'Details',
                          onTap: routeToMovieDetailScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animStart, animEnd) => Container(),
    );
  }

  // function to get all favorite movies from database
  Future<List<Favorite>> getFavoriteMovies() async {
    return await FavoriteDatabase.instance.readFavorites('movie');
  }

  // function to remove movie from favorite movie list
  Future<void> removeMovieFromFavorite(Favorite movie) async {
    final deletedMovie = movie;

    await FavoriteDatabase.instance.deleteFavoriteById(movie.id).then((_) {
      getFavoriteMovies().then((favorites) {
        setState(() {
          _movieFavorites = favorites;
        });
      }).then((_) {
        Navigator.pop(context);
      });
    });

    Utils.showSnackBarMessage(
      context: context,
      text: 'Successfully removed movie from favorite',
      duration: 3000,
      showAction: true,
      action: () => retrieveDeletedFavoriteMovie(deletedMovie),
    );
  }

  // function to retrieve previously deleted movie
  Future<void> retrieveDeletedFavoriteMovie(Favorite movie) async {
    await FavoriteDatabase.instance.createFavorite(movie).then((_) {
      getFavoriteMovies().then((favorites) {
        setState(() {
          _movieFavorites = favorites;
        });
      });
    });
  }
}
