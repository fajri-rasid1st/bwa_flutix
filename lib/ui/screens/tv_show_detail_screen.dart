import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/data/models/cast.dart';
import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:cick_movie_app/data/models/tv_show.dart';
import 'package:cick_movie_app/data/models/video.dart';
import 'package:cick_movie_app/data/services/tv_show_services.dart';
import 'package:cick_movie_app/ui/utils.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/detail_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/custom_divider.dart';
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
  bool _isErrorButtonDisabled = false;
  Widget _errorButtonChild = const Text('Try again');

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

  // favorite attributes
  Icon _favoriteIcon;
  bool _isFavorite;

  @override
  void initState() {
    // first, get all tv show data from server
    getAllTvShowData();

    // determine favorite icon action
    setFavoriteIconAction();

    // initialize declaration attribute
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
    if (_isLoading) {
      return const FutureOnLoad();
    } else {
      if (_tvShow == null) {
        return FutureOnLoad(
          text: _tvShowFailureMessage,
          isError: true,
          onPressedErrorButton:
              _isErrorButtonDisabled ? null : getAllTvShowData,
          errorButtonChild: _errorButtonChild,
        );
      } else {
        return buildMainScreen(_tvShow, _video);
      }
    }
  }

  // function to build main screen
  Widget buildMainScreen(TvShow tvShow, Video video) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            DetailAppBar(
              title: tvShow.title,
              favoriteIcon: _favoriteIcon,
              onPressedFavoriteIcon:
                  _isFavorite ? removeFromFavorite : addToFavorite,
              innerBoxIsScrolled: innerBoxIsScrolled,
            )
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Tv Show Title
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  tvShow.title,
                  style: detailMainTitleTextStyle,
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
                          style: secondaryTextStyle,
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
                          style: secondaryTextStyle,
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
                child:
                    _isChanged ? buildTvShowVideo() : buildTvShowDetail(tvShow),
              ),
              // Tv Show Total Episodes and Seasons
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          '${tvShow.numberOfSeasons}',
                          style: tvShowTextStyle1,
                        ),
                        Text(
                          'Total Seasons',
                          style: tvShowTextStyle2,
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
                          style: tvShowTextStyle1,
                        ),
                        Text(
                          'Total Episodes',
                          style: tvShowTextStyle2,
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
                      checkTvShowVideo(video);
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
                        style: buttonTextStyle,
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
                      style: detailTextStyle,
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

                        return Chip(label: Text(genres[index].name));
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
              CustomDivider(),
              // Tv Show Casts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Casts',
                      style: detailTextStyle,
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
                                          milliseconds: 200,
                                        ),
                                        fadeOutDuration: const Duration(
                                          milliseconds: 200,
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
                                      style: cardTitleTextStyle,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _casts[index].character,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: cardSubTitleTextStyle,
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
              CustomDivider(),
              // Tv Show Overview
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Overview',
                      style: detailTextStyle,
                    ),
                    const SizedBox(height: 4),
                    ReadMoreText(
                      tvShow.overview,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle: tvShowTextStyle2,
                      lessStyle: tvShowTextStyle2,
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
  Widget buildTvShowDetail(TvShow tvShow) {
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
                  width: double.infinity,
                  height: 240,
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeOutDuration: const Duration(milliseconds: 200),
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
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(left: 14, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Card(
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '${Const.IMG_URL_300}/${tvShow.posterPath}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 200),
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
                        const SizedBox(height: 48),
                        Text(
                          tvShow.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: detailTitleTextStyle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tvShow.firstandLastAirDateParse,
                          style: backgroundTextStyle,
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
                              '${tvShow.voteAverage}',
                              style: backgroundTextStyle,
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
  Widget buildTvShowVideo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      width: double.infinity,
      height: 240,
      child: YoutubePlayer(
        controller: _youtubePlayerController,
        aspectRatio: 16 / 9,
        bottomActions: [
          const SizedBox(width: 12.0),
          CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 8.0),
          RemainingDuration(),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }

  // function to determine behavior when tv show video is empty or not
  void checkTvShowVideo(Video video) {
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

  // function to fetch all tv show data
  Future<void> getAllTvShowData() async {
    setState(() {
      _isErrorButtonDisabled = true;
      _errorButtonChild = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Fetching data...'),
        ],
      );
    });

    Future.wait([
      TvShowServices.getTvShow(
        tvShowId: widget.tvShowId,
        onSuccess: (tvShow) => _tvShow = tvShow,
        onFailure: (message) {
          _tvShowFailureMessage = message;

          Utils.showSnackBarMessage(
            context: context,
            text: _tvShowFailureMessage,
          );
        },
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

        _isErrorButtonDisabled = false;
        _errorButtonChild = const Text('Try again');
        _isLoading = false;
      });
    });
  }

  // function to determine favorite icon action
  Future<void> setFavoriteIconAction() async {
    final isExist = await FavoriteDatabase.instance
        .isFavoriteAlreadyExist(widget.tvShowId, 'tv_show');

    if (isExist) {
      setState(() {
        _favoriteIcon = Icon(Icons.favorite, color: Colors.red);
        _isFavorite = true;
      });
    } else {
      setState(() {
        _favoriteIcon = Icon(Icons.favorite_outline, color: defaultTextColor);
        _isFavorite = false;
      });
    }
  }

  // function to add tv show to favorite
  Future<void> addToFavorite() async {
    final favorite = Favorite(
      favoriteId: widget.tvShowId,
      title: _tvShow.title,
      posterPath: _tvShow.posterPath,
      overview: _tvShow.overview,
      type: 'tv_show',
      createdAt: DateTime.now(),
    );

    await FavoriteDatabase.instance.createFavorite(favorite);

    setState(() {
      _favoriteIcon = Icon(Icons.favorite, color: Colors.red);
      _isFavorite = true;
    });

    Utils.showSnackBarMessage(
      context: context,
      text: 'Successfully added tv show to favorite',
    );
  }

  // function to remove tv show from favorite
  Future<void> removeFromFavorite() async {
    await FavoriteDatabase.instance
        .deleteFavoriteByType(widget.tvShowId, 'tv_show');

    setState(() {
      _favoriteIcon = Icon(Icons.favorite_outline, color: defaultTextColor);
      _isFavorite = false;
    });

    Utils.showSnackBarMessage(
      context: context,
      text: 'Successfully removed tv show from favorite',
    );
  }
}
