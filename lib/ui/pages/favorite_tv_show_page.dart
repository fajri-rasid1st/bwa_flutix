import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/screens/tv_show_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/utils.dart';
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
  // declaration attribute
  List<Favorite> _tvShowFavorites;

  // initialization attribute
  bool _isLoading = true;

  @override
  void initState() {
    // get all favorite tv shows from database
    getFavoriteTvShows().then((favorites) {
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

  // function to build tv show favorite list items
  Widget buildTvShowFavoriteList(List<Favorite> tvShowFavorites) {
    return ListItems(
      items: tvShowFavorites,
      onTap: routeToTvShowDetailScreen,
      onLongPress: showTvShowFavoriteDialog,
    );
  }

  // function to build dialog option
  Widget buildDialogOption({
    Favorite tvShow,
    IconData icon,
    String text,
    Future<void> Function(Favorite tvShow) onTap,
  }) {
    return InkWell(
      onTap: () => onTap(tvShow),
      borderRadius: BorderRadius.circular(16),
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

  // function to route to tv show detail screen, when tapped favorite tv show item
  Future<void> routeToTvShowDetailScreen(Favorite tvShow) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TvShowDetailScreen(tvShowId: tvShow.favoriteId);
        },
      ),
    ).then((_) {
      getFavoriteTvShows().then((favorites) {
        setState(() => _tvShowFavorites = favorites);
      });
    });
  }

  // function to show tv show favorite dialog, when on long pressed favorite tv show item
  Future<void> showTvShowFavoriteDialog(Favorite tvShow) async {
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
                      tvShow.title,
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
                          tvShow: tvShow,
                          icon: Icons.delete_outline,
                          text: 'Delete',
                          onTap: removeTvShowFromFavorite,
                        ),
                        const SizedBox(width: 20),
                        buildDialogOption(
                          tvShow: tvShow,
                          icon: Icons.info_outlined,
                          text: 'Details',
                          onTap: routeToTvShowDetailScreen,
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

  // function to get all favorite tv show from database
  Future<List<Favorite>> getFavoriteTvShows() async {
    return FavoriteDatabase.instance.readFavorites('tv_show');
  }

  // function to remove tv show from favorite tv show list
  Future<void> removeTvShowFromFavorite(Favorite tvShow) async {
    final deletedTvShow = tvShow;

    FavoriteDatabase.instance.deleteFavoriteById(tvShow.id).then((_) {
      getFavoriteTvShows().then((favorites) {
        setState(() {
          _tvShowFavorites = favorites;
        });
      }).then((_) {
        Navigator.pop(context);
      });
    });

    Utils.showSnackBarMessage(
      context: context,
      text: 'Successfully removed tv show from favorite',
      duration: 3000,
      showAction: true,
      action: () => retrieveDeletedFavoriteTvShow(deletedTvShow),
    );
  }

  // function to retrieve previously deleted tv show
  Future<void> retrieveDeletedFavoriteTvShow(Favorite tvShow) async {
    FavoriteDatabase.instance.createFavorite(tvShow).then((_) {
      getFavoriteTvShows().then((favorites) {
        setState(() {
          _tvShowFavorites = favorites;
        });
      });
    });
  }
}
