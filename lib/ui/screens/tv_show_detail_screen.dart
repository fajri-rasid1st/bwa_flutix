import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/models/TvShow.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvShowDetailScreen extends StatefulWidget {
  final TvShow tvShow;

  const TvShowDetailScreen({@required this.tvShow});

  @override
  _TvShowDetailScreenState createState() => _TvShowDetailScreenState();
}

class _TvShowDetailScreenState extends State<TvShowDetailScreen> {
  YoutubePlayerController _controller;
  bool _isChanged;
  String _buttonText;
  Icon _buttonIcon;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.tvShow.videoId,
      flags: YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        disableDragSeek: true,
        enableCaption: false,
      ),
    );

    _isChanged = false;
    _buttonText = 'Watch Trailer';
    _buttonIcon = Icon(Icons.play_arrow_outlined);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tvShow = widget.tvShow;

    return Scaffold(
      appBar: CustomAppBar(title: tvShow.title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      const SizedBox(width: 4),
                      Text(
                        '${tvShow.runtime} mins',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 2.5,
                    backgroundColor: secondaryTextColor,
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 20,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${tvShow.voteCount} votes',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _isChanged
                    ? buildTvShowTeaser(screenWidth)
                    : buildTvShowDetail(screenWidth, tvShow)),
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isChanged = !_isChanged;

                    if (_isChanged) {
                      _controller.play();
                      _buttonText = 'Show Details';
                      _buttonIcon = Icon(Icons.info_outline);
                    } else {
                      _controller.reset();
                      _buttonText = 'Watch Trailer';
                      _buttonIcon = Icon(Icons.play_arrow_outlined);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buttonIcon,
                    const SizedBox(width: 2),
                    Text(
                      _buttonText,
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
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
                  const SizedBox(height: 4),
                  ReadMoreText(
                    tvShow.overview,
                    colorClickableText: primaryColor,
                    trimMode: TrimMode.Line,
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

  Widget buildTvShowDetail(double screenWidth, TvShow tvShow) {
    return SizedBox(
      height: 285,
      child: Stack(
        children: <Widget>[
          SizedBox(
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
            top: 95,
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
                        height: 170,
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
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 40),
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
                        const SizedBox(height: 2),
                        Text(
                          tvShow.getReleaseDate,
                          style: TextStyle(color: backgroundColor),
                        ),
                        const SizedBox(height: 4),
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
                            const SizedBox(width: 4),
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
    );
  }

  Widget buildTvShowTeaser(double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 45),
      height: 240,
      child: YoutubePlayer(
        controller: _controller,
        width: screenWidth,
        bottomActions: [
          const SizedBox(width: 12.0),
          CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 8.0),
          RemainingDuration(),
          const SizedBox(width: 4.0),
          PlaybackSpeedButton(),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }
}
