import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/ui/screens/movie_detail_screen.dart';
import 'package:cick_movie_app/ui/screens/tv_show_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewItems extends StatelessWidget {
  final List<dynamic> items;

  const GridViewItems({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.extentBuilder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      maxCrossAxisExtent: 200,
      staggeredTileBuilder: (index) => const StaggeredTile.extent(1, 320),
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return item is MoviePopular
                        ? MovieDetailScreen(movieId: item.id)
                        : TvShowDetailScreen(tvShowId: item.id);
                  },
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: '${Const.IMG_URL_300}/${item.posterPath}',
                        fit: BoxFit.cover,
                        height: 240,
                        width: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: (context, url) {
                          return Center(
                            child: SpinKitPulse(color: secondaryColor),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Center(
                            child: Icon(
                              Icons.nearby_error,
                              color: secondaryTextColor,
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(4),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Icon(Icons.star, color: accentColor, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '${item.voteAverage}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: backgroundColor,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: primaryTextColor.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.title,
                  style: titleTextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.releaseDateParse,
                  style: subtitleTextStyle,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: items.length,
    );
  }
}
