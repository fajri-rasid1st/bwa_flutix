import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/cast.dart';
import 'package:cick_movie_app/data/models/tv_show.dart';
import 'package:cick_movie_app/data/models/video.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/custom_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvShowDetailScreen extends StatefulWidget {
  final int tvShowId;

  const TvShowDetailScreen({@required this.tvShowId});

  @override
  _TvShowDetailScreenState createState() => _TvShowDetailScreenState();
}

class _TvShowDetailScreenState extends State<TvShowDetailScreen> {
  // initialize atribute
  bool _isLoading = true;

  // declaration attribute
  ScrollController _scrollController;
  Icon _buttonIcon;
  String _buttonText;
  bool _isChanged;

  // this attribute will be filled in the future
  TvShow _tvShow;
  Video _video;
  List<Cast> _casts;
  YoutubePlayerController _youtubePlayerController;
  String _tvShowFailureMessage, _videoFailureMessage, _castsFailureMessage;

  @override
  void initState() {
    // first, get all tv show data from server
    Future.wait([
      TvShowServices.getTvShow(
        tvShowId: widget.tvShowId,
        onSuccess: (tvShow) => _tvShow = tvShow,
        onFailure: (message) => _tvShowFailureMessage = message,
      ),
      TvShowServices.getTvShowVideo(
        tvShowId: widget.tvShowId,
        onSuccess: (video) => _video = video,
        onFailure: (message) => _videoFailureMessage = message,
      ),
      TvShowServices.getTvShowCasts(
        tvShowId: widget.tvShowId,
        onSuccess: (casts) => _casts = casts,
        onFailure: (message) => _castsFailureMessage = message,
      ),
    ]).then((_) {
      setState(() {
        if (_video != null) {
          _youtubePlayerController = YoutubePlayerController(
            initialVideoId: _video.videoId,
            flags: YoutubePlayerFlags(
              autoPlay: false,
              controlsVisibleAtStart: true,
              disableDragSeek: true,
              enableCaption: false,
              loop: true,
            ),
          );
        }

        _isLoading = false;
      });
    });

    _scrollController = ScrollController();
    _buttonIcon = Icon(Icons.play_arrow_outlined);
    _buttonText = 'Watch Trailer';
    _isChanged = false;
    super.initState();
  }

  @override
  void dispose() {
    if (_youtubePlayerController != null) {
      _youtubePlayerController.dispose();
    }

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const FutureOnLoad(text: 'Fetching data...');
    } else {
      if (_tvShow == null) {
        return FutureOnLoad(text: _tvShowFailureMessage, isError: true);
      } else {
        return buildMainScreen(screenWidth, _tvShow, _video);
      }
    }
  }

  // function to build main screen
  Widget buildMainScreen(double screenWidth, TvShow tvShow, Video video) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[CustomAppbar(title: tvShow.title)];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Tv Show Title
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  tvShow.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
              ),
              // Tv Show Runtime and Vote Average
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
                          '${tvShow.episodeRuntime} mins per episode',
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
              // Tv Show Detail or Video
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 750),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _isChanged
                    ? buildTvShowVideo(screenWidth)
                    : buildTvShowDetail(screenWidth, tvShow),
              ),
              // Tv Show Total Episodes and Seasons
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          '${tvShow.numberOfSeasons}',
                          style: TextStyle(
                            fontSize: 28,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          'Total Seasons',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      decoration: BoxDecoration(
                        color: dividerColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0.25, 0),
                            blurRadius: 0.5,
                            color: secondaryColor,
                          ),
                          BoxShadow(
                            offset: Offset(-0.25, 0),
                            blurRadius: 0.5,
                            color: secondaryColor,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '${tvShow.numberOfEpisodes}',
                          style: TextStyle(
                            fontSize: 28,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          'Total Episodes',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tv Show Button For Switch Between Detail and Video
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (video != null) {
                        if (video.site == 'YouTube') {
                          _isChanged = !_isChanged;

                          if (_isChanged) {
                            _youtubePlayerController.play();
                            _buttonText = 'Show Details';
                            _buttonIcon = Icon(Icons.info_outline);
                          } else {
                            _youtubePlayerController.pause();
                            _buttonText = 'Watch Trailer';
                            _buttonIcon = Icon(Icons.play_arrow_outlined);
                          }
                        } else {
                          showSnackBarMessage(text: _videoFailureMessage);
                        }
                      } else {
                        showSnackBarMessage(text: _videoFailureMessage);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buttonIcon,
                      const SizedBox(width: 4),
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
              // Tv Show Genres
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Genres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
                          label: Text(genres[index].name),
                          labelStyle: TextStyle(color: primaryTextColor),
                        );
                      },
                      itemCount: tvShow.genres.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 4);
                      },
                    ),
                  )
                ],
              ),
              // Divider
              buildDivider(),
              // Tv Show Casts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Casts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _casts == null
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(_castsFailureMessage),
                        )
                      : Container(
                          height: 228,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 112,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${Const.IMG_URL_200}/${_casts[index].profilePath}',
                                        width: 112,
                                        height: 165,
                                        fit: BoxFit.cover,
                                        fadeInDuration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        fadeOutDuration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        placeholder: (context, url) {
                                          return Center(
                                            child: SpinKitThreeBounce(
                                              size: 24,
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
                                    const SizedBox(height: 2),
                                    Text(
                                      _casts[index].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: appBarTitleTextStyle,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _casts[index].character,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: _casts.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 16);
                            },
                          ),
                        ),
                ],
              ),
              // Divider
              buildDivider(),
              // Tv Show Overview
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
      ),
    );
  }

  // function to build tv show detail
  Widget buildTvShowDetail(double screenWidth, TvShow tvShow) {
    return SizedBox(
      height: 290,
      child: Stack(
        children: <Widget>[
          SizedBox(
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: '${Const.IMG_URL_500}/${tvShow.backdropPath}',
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
                      child: SpinKitThreeBounce(
                        size: 24,
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
            top: 90,
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
                        imageUrl: '${Const.IMG_URL_300}/${tvShow.posterPath}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                        fadeInDuration: const Duration(
                          milliseconds: 500,
                        ),
                        fadeOutDuration: const Duration(
                          milliseconds: 500,
                        ),
                        placeholder: (context, url) {
                          return Center(
                            child: SpinKitThreeBounce(
                              size: 24,
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
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 46),
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
                          tvShow.firstandLastAirDateParse,
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

  // function to build tv show vidoe
  Widget buildTvShowVideo(double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      height: 240,
      child: YoutubePlayer(
        controller: _youtubePlayerController,
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

  // function to create divider
  Widget buildDivider() {
    return Container(
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
    );
  }

  // function to show snackbar with message
  void showSnackBarMessage({@required String text, int duration = 1500}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: duration),
      ),
    );
  }
}
