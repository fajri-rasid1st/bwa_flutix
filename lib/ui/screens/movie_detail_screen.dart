import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/models/Movie.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: backgroundColor,
                title: Text(
                  movie.title,
                  style: appBarTitleTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.chevron_left,
                    color: primaryTextColor,
                  ),
                  tooltip: 'Back',
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: primaryTextColor,
                    ),
                    tooltip: 'Search',
                  ),
                ],
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    bottom: 12,
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: primarySwatch,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // ----- comment divider between widgets (so you don't get dizzy) -----
                Container(
                  margin: EdgeInsets.only(bottom: 4, left: 16, right: 16),
                  child: Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                // ----- comment divider between widgets (so you don't get dizzy) -----
                Container(
                  margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
                // ----- comment divider between widgets (so you don't get dizzy) -----
                Container(
                  height: 350,
                  color: Colors.blue[50],
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: movie.backdropUrl,
                              fit: BoxFit.cover,
                              height: 280,
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
                                    colors: [
                                      Colors.black87,
                                      Colors.transparent,
                                    ],
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
                                    colors: [
                                      Colors.black45,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 180,
                        child: Card(
                          elevation: 2,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: movie.posterUrl,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 500),
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
                        ),
                      ),
                    ],
                  ),
                ),
                // ----- comment divider between widgets (so you don't get dizzy) -----
              ],
            ),
          ),
        ),
      ),
    );
  }
}
