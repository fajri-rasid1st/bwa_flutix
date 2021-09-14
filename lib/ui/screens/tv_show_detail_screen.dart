import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/models/TvShow.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class TvShowDetailScreen extends StatelessWidget {
  final TvShow tvShow;

  const TvShowDetailScreen({@required this.tvShow});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: tvShow.title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: Text(
                tvShow.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: primaryTextColor,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.av_timer_outlined,
                        size: 20,
                        color: secondaryTextColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${tvShow.runtime ?? 0} mins',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 2.5,
                    backgroundColor: secondaryTextColor,
                  ),
                  SizedBox(width: 12),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 20,
                        color: secondaryTextColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${tvShow.voteCount} votes',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: tvShow.backdropUrl,
                          fit: BoxFit.cover,
                          height: 240,
                          fadeInDuration: const Duration(
                            milliseconds: 500,
                          ),
                          fadeOutDuration: const Duration(
                            milliseconds: 500,
                          ),
                          placeholder: (context, url) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
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
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black87, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black45, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 100,
                    width: screenWidth,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Card(
                              elevation: 4,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: tvShow.posterUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 175,
                                fadeInDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                fadeOutDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                placeholder: (context, url) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: accentColor,
                                    ),
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
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 40),
                                Text(
                                  tvShow.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: backgroundColor,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  tvShow.getReleaseDate,
                                  style: TextStyle(color: backgroundColor),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: tvShow.voteAverage / 2,
                                      itemBuilder: (context, index) {
                                        return Icon(
                                          Icons.star,
                                          color: accentColor,
                                        );
                                      },
                                      itemSize: 18,
                                      unratedColor: secondaryTextColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      tvShow.voteAverage.toString(),
                                      style: TextStyle(color: backgroundColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.play_arrow),
                    SizedBox(width: 2),
                    Text(
                      'Watch Trailer',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Genres',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final genres = tvShow.genres;

                      return Chip(
                        label: Text(genres[index]),
                        labelStyle: TextStyle(color: primaryTextColor),
                      );
                    },
                    itemCount: tvShow.genres.length,
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: dividerColor,
              ),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 0.5),
                    blurRadius: 1,
                    color: dividerColor,
                  ),
                  BoxShadow(
                    offset: Offset(0.5, 0),
                    blurRadius: 1,
                    color: dividerColor,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  ReadMoreText(
                    tvShow.overview.isEmpty ? 'None' : tvShow.overview,
                    colorClickableText: primaryColor,
                    trimMode: TrimMode.Line,
                    trimLength: 200,
                    trimLines: 4,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                    lessStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
