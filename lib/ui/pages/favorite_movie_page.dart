import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/ui/screens/movie_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/favorite_empty.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCard(_movieFavorites[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 4);
      },
      itemCount: _movieFavorites.length,
    );
  }

  Widget buildCard(Favorite item) {
    final dateTime = DateTime.parse(item.createdAt.toString());
    final createdAt = DateFormat('MMM dd, y hh:mm a').format(dateTime);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: '${Const.IMG_URL_300}/${item.posterPath}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeOutDuration: const Duration(milliseconds: 500),
                    placeholder: (context, url) {
                      return Center(
                        child: SpinKitThreeBounce(
                          size: 20,
                          color: secondaryColor,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Icon(
                          Icons.motion_photos_off_outlined,
                          color: secondaryTextColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: titleTextStyle,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.event,
                            size: 18,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            createdAt,
                            style: subTitleTextStyle,
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.overview,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: secondaryTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MovieDetailScreen(
                            movieId: item.favoriteId,
                          );
                        },
                      ),
                    ).then((_) {
                      getMovieFavorites().then((favorites) {
                        setState(() => _movieFavorites = favorites);
                      });
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Favorite>> getMovieFavorites() async {
    return await FavoriteDatabase.instance.readFavorites('movie');
  }
}
