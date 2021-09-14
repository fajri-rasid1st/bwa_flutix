import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/models/Movie.dart';
import 'package:cick_movie_app/ui/screens/movie_detail_screen.dart';
import 'package:cick_movie_app/ui/screens/tv_show_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class GridViewItems extends StatelessWidget {
  final List<dynamic> items;

  const GridViewItems({@required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.53,
      ),
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
                    return item is Movie
                        ? MovieDetailScreen(movie: item)
                        : TvShowDetailScreen(tvShow: item);
                  },
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: item.posterUrl,
                        fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: (context, url) {
                          return Center(
                            child:
                                CircularProgressIndicator(color: accentColor),
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
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: accentColor,
                              size: 22,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${item.voteAverage}',
                              style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: primaryTextColor.withOpacity(0.5),
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
                  // textWidthBasis: TextWidthBasis.longestLine,
                ),
                Text(
                  item.releaseDate.split('-')[0],
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
