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
  List<Favorite> _tvShowFavorites;
  Favorite _deletedFavorite;

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
                      item.title,
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
                          item: item,
                          icon: Icons.delete_outline,
                          text: 'Delete',
                          onTap: removeFromFavorite,
                        ),
                        const SizedBox(width: 20),
                        buildDialogOption(
                          item: item,
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

  Widget buildDialogOption({
    Favorite item,
    IconData icon,
    String text,
    Future<void> Function(Favorite item) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
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
        ),
      ),
    );
  }

  Future<List<Favorite>> getTvShowFavorites() async {
    return await FavoriteDatabase.instance.readFavorites('tv_show');
  }

  Future<void> removeFromFavorite(Favorite item) async {
    await FavoriteDatabase.instance.deleteFavoriteById(item.id).then((_) {
      _deletedFavorite = item;

      getTvShowFavorites().then((favorites) {
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
      action: retrieveFavorite,
    );
  }

  Future<void> retrieveFavorite() async {
    await FavoriteDatabase.instance.createFavorite(_deletedFavorite).then((_) {
      getTvShowFavorites().then((favorites) {
        setState(() {
          _tvShowFavorites = favorites;
        });
      });
    });
  }
}
