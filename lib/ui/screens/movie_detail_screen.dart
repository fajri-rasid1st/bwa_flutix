import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/cast.dart';
import 'package:cick_movie_app/data/models/movie.dart';
import 'package:cick_movie_app/data/models/video.dart';
import 'package:cick_movie_app/data/services/movie_services.dart';
import 'package:cick_movie_app/ui/screens/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/custom_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/future_on_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({@required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // initialize atribute
  bool _isLoading = true;

  // declaration attribute
  ScrollController _scrollController;
  Icon _buttonIcon;
  String _buttonText;
  bool _isChanged;

  // this attribute will be filled in the future
  Movie _movie;
  Video _video;
  List<Cast> _casts;
  YoutubePlayerController _youtubePlayerController;
  String _movieFailureMessage, _videoFailureMessage, _castsFailureMessage;

  @override
  void initState() {
    // first, get all movie data from server
    Future.wait([
      MovieServices.getMovie(
        movieId: widget.movieId,
        onSuccess: (movie) => _movie = movie,
        onFailure: (message) => _movieFailureMessage = message,
      ),
      MovieServices.getMovieVideo(
        movieId: widget.movieId,
        onSuccess: (video) => _video = video,
        onFailure: (message) => _videoFailureMessage = message,
      ),
      MovieServices.getMovieCasts(
        movieId: widget.movieId,
        onSuccess: (casts) => _casts = casts,
        onFailure: (message) => _castsFailureMessage = message,
      )
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
      if (_movie == null) {
        return FutureOnLoad(text: _movieFailureMessage, isError: true);
      } else {
        return buildMainScreen(screenWidth, _movie, _video);
      }
    }
  }

  // function to build main screen
  Widget buildMainScreen(double screenWidth, Movie movie, Video video) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[CustomAppbar(title: movie.title)];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Movie Title
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
              ),
              // Movie Runtime and Vote Average
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
                          '${movie.runtime} mins',
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
                          '${movie.voteCount} votes',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Movie Detail or Video
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 750),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _isChanged
                    ? buildMovieVideo(screenWidth)
                    : buildMovieDetail(screenWidth, movie),
              ),
              // Movie Button For Switch Between Detail and Video
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => checkMovieVideo(video));
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
              // Movie Genres
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
                        final genres = movie.genres;

                        return Chip(
                          label: Text(genres[index].name),
                          labelStyle: TextStyle(color: primaryTextColor),
                        );
                      },
                      itemCount: movie.genres.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 4);
                      },
                    ),
                  )
                ],
              ),
              // Divider
              Utils.buildDivider(),
              // Movie Casts
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
                                        vertical: 4,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
              Utils.buildDivider(),
              // Movie Overview
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
                      movie.overview,
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

  // function to build movie detail
  Widget buildMovieDetail(double screenWidth, Movie movie) {
    return SizedBox(
      height: 290,
      child: Stack(
        children: <Widget>[
          SizedBox(
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: '${Const.IMG_URL_500}/${movie.backdropPath}',
                  fit: BoxFit.cover,
                  height: 240,
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '${Const.IMG_URL_300}/${movie.posterPath}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
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
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 46),
                        Text(
                          movie.title,
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
                          movie.releaseDateParse,
                          style: TextStyle(color: backgroundColor),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RatingBarIndicator(
                              rating: movie.voteAverage / 2,
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
                              movie.voteAverage.toString(),
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

  // function to build movie video
  Widget buildMovieVideo(double screenWidth) {
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

  // function to determine behavior when movie video is empty or not
  void checkMovieVideo(Video video) {
    if (video != null) {
      if (video.site == 'YouTube') {
        Utils.scrollToTop(controller: _scrollController);

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
        Utils.showSnackBarMessage(context: context, text: _videoFailureMessage);
      }
    } else {
      Utils.showSnackBarMessage(context: context, text: _videoFailureMessage);
    }
  }
}
