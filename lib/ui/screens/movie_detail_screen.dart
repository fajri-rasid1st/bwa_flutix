import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/models/Movie.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: movie.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: Text(
                movie.title,
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
                        '${movie.runtime} mins',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
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
                        '${movie.voteCount} votes',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
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
                          imageUrl: movie.backdropUrl,
                          fit: BoxFit.cover,
                          height: 240,
                          fadeInDuration: const Duration(
                            milliseconds: 500,
                          ),
                          fadeOutDuration: const Duration(
                            milliseconds: 500,
                          ),
                          placeholder: (BuildContext context, String url) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            );
                          },
                          errorWidget: (
                            BuildContext context,
                            String url,
                            dynamic error,
                          ) {
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
                    width: MediaQuery.of(context).size.width,
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
                                imageUrl: movie.posterUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 175,
                                fadeInDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                fadeOutDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                placeholder: (
                                  BuildContext context,
                                  String url,
                                ) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: accentColor,
                                    ),
                                  );
                                },
                                errorWidget: (
                                  BuildContext context,
                                  String url,
                                  dynamic error,
                                ) {
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
                                SizedBox(
                                  child: Text(
                                    movie.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: backgroundColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  movie.getReleaseDate,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: backgroundColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: movie.voteAverage / 2,
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
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
                                      movie.voteAverage.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: backgroundColor,
                                      ),
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
          ],
        ),
      ),
    );
  }
}
