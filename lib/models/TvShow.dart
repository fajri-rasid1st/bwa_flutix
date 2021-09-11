import 'package:cick_movie_app/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TvShow {
  String title;
  String overview;
  String releaseDate;
  String lastAirDate;
  String posterUrl;
  String backdropUrl;
  double voteAverage;
  int voteCount;
  int runtime;
  int episodes;
  int seasons;
  List<String> genres;

  TvShow({
    @required this.title,
    @required this.overview,
    @required this.releaseDate,
    @required this.lastAirDate,
    @required this.posterUrl,
    @required this.backdropUrl,
    @required this.voteAverage,
    @required this.voteCount,
    @required this.runtime,
    @required this.episodes,
    @required this.seasons,
    @required this.genres,
  });

  String get getReleaseDate {
    return DateFormat('MMM, dd y').format(DateTime.parse(releaseDate));
  }
}

var tvShows = [
  TvShow(
    title: 'What If...?',
    overview:
        'Taking inspiration from the comic books of the same name, each episode explores a pivotal moment from the Marvel Cinematic Universe and turns it on its head, leading the audience into uncharted territory.',
    releaseDate: '2021-08-11',
    lastAirDate: '2021-09-01',
    posterUrl: '${Const.IMG_URL_300}/lztz5XBMG1x6Y5ubz7CxfPFsAcW.jpg',
    backdropUrl: '${Const.IMG_URL_500}/4N6zEMfZ57zNEQcM8gWeERFupMv.jpg',
    voteAverage: 8.5,
    voteCount: 1218,
    runtime: 34,
    episodes: 9,
    seasons: 1,
    genres: ['Animation', 'Action & Adventure', 'Sci-Fi & Fantasy'],
  ),
  TvShow(
    title: 'The Bond',
    overview: '',
    releaseDate: '2021-08-17',
    lastAirDate: '2021-09-04',
    posterUrl: '${Const.IMG_URL_300}/dLUJGSrFWA1h3pnAqygAHK7ShVb.jpg',
    backdropUrl: '${Const.IMG_URL_500}/zN8vBX1jDRxIDqFQ2ARcodTHhdt.jpg',
    voteAverage: 5.5,
    voteCount: 2,
    runtime: 45,
    episodes: 36,
    seasons: 1,
    genres: ['Drama', 'Family'],
  ),
  TvShow(
    title: 'Ilha Record',
    overview:
        'Ilha Record is a Brazilian reality television competition format originally created and aired by RecordTV. The series is hosted by Sabrina Sato and premiered on Monday, July 26, 2021 at 10:30 p.m. / 9:30 p.m.  www.youtube.com/channel/UCW3Ve61iGOQQoE8UrPMOZcQ',
    releaseDate: '2021-07-26',
    lastAirDate: '2021-09-04',
    posterUrl: '${Const.IMG_URL_300}/43pX5G2eL4H6EppxVcirMxdkcGN.jpg',
    backdropUrl: '${Const.IMG_URL_500}/bjsoOPkViI5WIREQb94XDeXrZlF.jpg',
    voteAverage: 3.4,
    voteCount: 9,
    runtime: null,
    episodes: 40,
    seasons: 1,
    genres: ['Reality'],
  ),
  TvShow(
    title: 'The Good Doctor',
    overview:
        'A young surgeon with Savant syndrome is recruited into the surgical unit of a prestigious hospital. The question will arise: can a person who doesn\'t have the ability to relate to people actually save their lives',
    releaseDate: '2017-09-25',
    lastAirDate: '2021-06-07',
    posterUrl: '${Const.IMG_URL_300}/6tfT03sGp9k4c0J3dypjrI8TSAI.jpg',
    backdropUrl: '${Const.IMG_URL_500}/Al1NiPYGzKddngu8L5NNtsoANYU.jpg',
    voteAverage: 8.6,
    voteCount: 9263,
    runtime: 43,
    episodes: 86,
    seasons: 5,
    genres: ['Drama'],
  ),
  TvShow(
    title: 'The Young and the Restless',
    overview:
        'The rivalries, romances, hopes and fears of the residents of the fictional Midwestern metropolis, Genoa City. The lives and loves of a wide variety of characters mingle through the generations, dominated by the Newman, Abbott, Baldwin and Winters families.',
    releaseDate: '1973-03-26',
    lastAirDate: '2021-09-03',
    posterUrl: '${Const.IMG_URL_300}/5h58tbqpUhpdiQR1i4FawKWOidh.jpg',
    backdropUrl: '${Const.IMG_URL_500}/9abMIArcm95q0CtTOTZnLdUIoSm.jpg',
    voteAverage: 6.4,
    voteCount: 92,
    runtime: 30,
    episodes: 1810,
    seasons: 49,
    genres: ['Soap'],
  ),
  TvShow(
    title: 'Loki',
    overview:
        'After stealing the Tesseract during the events of “Avengers: Endgame,” an alternate version of Loki is brought to the mysterious Time Variance Authority, a bureaucratic organization that exists outside of time and space and monitors the timeline. They give Loki a choice: face being erased from existence due to being a “time variant” or help fix the timeline and stop a greater threat.',
    releaseDate: '2021-06-09',
    lastAirDate: '2021-07-14',
    posterUrl: '${Const.IMG_URL_300}/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg',
    backdropUrl: '${Const.IMG_URL_500}/kXja7L9cRlsRmINMpxyWEdp9r3u.jpg',
    voteAverage: 8.2,
    voteCount: 7526,
    runtime: 52,
    episodes: 6,
    seasons: 1,
    genres: ['Drama', 'Sci-Fi & Fantasy'],
  ),
  TvShow(
    title: 'DC\'s Stargirl',
    overview:
        'Courtney Whitmore, a smart, athletic and above all else kind girl, discovers her step-father has a secret: he used to be the sidekick to a superhero. \"Borrowing\" the long-lost hero’s cosmic staff, she becomes the unlikely inspiration for an entirely new generation of superheroes.',
    releaseDate: '2020-05-18',
    lastAirDate: '2021-08-31',
    posterUrl: '${Const.IMG_URL_300}/rbkGgrEHOPyAEZqPk609QN1Ird6.jpg',
    backdropUrl: '${Const.IMG_URL_500}/pXjpqrx65mlQskf9mfTWSszYODn.jpg',
    voteAverage: 7.9,
    voteCount: 811,
    runtime: 43,
    episodes: 26,
    seasons: 3,
    genres: ['Sci-Fi & Fantasy', 'Action & Adventure', 'Drama'],
  ),
  TvShow(
    title: 'Riverdale',
    overview:
        'Set in the present, the series offers a bold, subversive take on Archie, Betty, Veronica and their friends, exploring the surreality of small-town life, the darkness and weirdness bubbling beneath Riverdale’s wholesome facade.',
    releaseDate: '2017-01-26',
    lastAirDate: '2021-09-01',
    posterUrl: '${Const.IMG_URL_300}/wRbjVBdDo5qHAEOVYoMWpM58FSA.jpg',
    backdropUrl: '${Const.IMG_URL_500}/qZtAf4Z1lazGQoYVXiHOrvLr5lI.jpg',
    voteAverage: 8.6,
    voteCount: 11851,
    runtime: 45,
    episodes: 94,
    seasons: 6,
    genres: ['Mystery', 'Drama', 'Crime'],
  ),
  TvShow(
    title: 'Lucifer',
    overview:
        'Bored and unhappy as the Lord of Hell, Lucifer Morningstar abandoned his throne and retired to Los Angeles, where he has teamed up with LAPD detective Chloe Decker to take down criminals. But the longer he\'s away from the underworld, the greater the threat that the worst of humanity could escape.',
    releaseDate: '2010-10-31',
    lastAirDate: '2021-08-29',
    posterUrl: '${Const.IMG_URL_300}/ekZobS8isE6mA53RAiGDG93hBxL.jpg',
    backdropUrl: '${Const.IMG_URL_500}/ktDJ21QQscbMNQfPpZBsNORxdDx.jpg',
    voteAverage: 8.1,
    voteCount: 11509,
    runtime: 42,
    episodes: 161,
    seasons: 11,
    genres: ['Action & Adventure', 'Drama', 'Sci-Fi & Fantasy'],
  ),
  TvShow(
    title: 'Demi-Gods and Semi-Devils',
    overview: '',
    releaseDate: '2021-08-14',
    lastAirDate: '2021-09-03',
    posterUrl: '${Const.IMG_URL_300}/gyk1nHbz7EKoYagNWDCg4pIy4Et.jpg',
    backdropUrl: '${Const.IMG_URL_500}/aSFDMJGik0vLzUoyl9uQPWstmup.jpg',
    voteAverage: 7.7,
    voteCount: 3,
    runtime: 45,
    episodes: 50,
    seasons: 1,
    genres: ['Sci-Fi & Fantasy'],
  ),
];
