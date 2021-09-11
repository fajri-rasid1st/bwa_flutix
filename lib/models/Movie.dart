import 'package:cick_movie_app/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Movie {
  String title;
  String overview;
  String releaseDate;
  String posterUrl;
  String backdropUrl;
  double voteAverage;
  int voteCount;
  int runtime;
  List<String> genres;

  Movie({
    @required this.title,
    @required this.overview,
    @required this.releaseDate,
    @required this.posterUrl,
    @required this.backdropUrl,
    @required this.voteAverage,
    @required this.voteCount,
    @required this.runtime,
    @required this.genres,
  });

  String get getReleaseDate {
    return DateFormat('MMM, dd y').format(DateTime.parse(releaseDate));
  }
}

var movies = [
  Movie(
    title: 'The Suicide Squad',
    overview:
        'Supervillains Harley Quinn, Bloodsport, Peacemaker and a collection of nutty cons at Belle Reve prison join the super-secret, super-shady Task Force X as they are dropped off at the remote, enemy-infused island of Corto Maltese.',
    releaseDate: '2021-07-28',
    posterUrl: '${Const.IMG_URL_300}/iXbWpCkIauBMStSTUT9v4GXvdgH.jpg',
    backdropUrl: '${Const.IMG_URL_500}/jlGmlFOcfo8n5tURmhC7YVd4Iyy.jpg',
    voteAverage: 8,
    voteCount: 3322,
    runtime: 132,
    genres: ['Action', 'Adventure', 'Fantasy', 'Comedy'],
  ),
  Movie(
    title: 'Jungle Cruise',
    overview:
        'Dr. Lily Houghton enlists the aid of wisecracking skipper Frank Wolff to take her down the Amazon in his dilapidated boat. Together, they search for an ancient tree that holds the power to heal – a discovery that will change the future of medicine.',
    releaseDate: '2021-07-28',
    posterUrl: '${Const.IMG_URL_300}/9dKCd55IuTT5QRs989m9Qlb7d2B.jpg',
    backdropUrl: '${Const.IMG_URL_500}/7WJjFviFBffEJvkAms4uWwbcVUk.jpg',
    voteAverage: 7.9,
    voteCount: 2297,
    runtime: 127,
    genres: ['Adventure', 'Fantasy', 'Comedy', 'Action'],
  ),
  Movie(
    title: 'Sweet Girl',
    overview:
        'A devastated husband vows to bring justice to the people responsible for his wife\'s death while protecting the only family he has left, his daughter.',
    releaseDate: '2021-08-18',
    posterUrl: '${Const.IMG_URL_300}/cP7odDzzFBD9ycxj2laTeFWGLjD.jpg',
    backdropUrl: '${Const.IMG_URL_500}/nprqOIEfiMMQx16lgKeLf3rmPrR.jpg',
    voteAverage: 6.9,
    voteCount: 408,
    runtime: 110,
    genres: ['Action', 'Thriller', 'Drama'],
  ),
  Movie(
    title: 'PAW Patrol: The Movie',
    overview:
        'Ryder and the pups are called to Adventure City to stop Mayor Humdinger from turning the bustling metropolis into a state of chaos.',
    releaseDate: '2021-08-09',
    posterUrl: '${Const.IMG_URL_300}/ic0intvXZSfBlYPIvWXpU1ivUCO.jpg',
    backdropUrl: '${Const.IMG_URL_500}/mtRW6eAwOO27h3zrfU2foQFW7Hg.jpg',
    voteAverage: 8.1,
    voteCount: 319,
    runtime: 90,
    genres: ['Animation', 'Family', 'Adventure', 'Comedy'],
  ),
  Movie(
    title: 'Black Widow',
    overview:
        'Natasha Romanoff, also known as Black Widow, confronts the darker parts of her ledger when a dangerous conspiracy with ties to her past arises. Pursued by a force that will stop at nothing to bring her down, Natasha must deal with her history as a spy and the broken relationships left in her wake long before she became an Avenger.',
    releaseDate: '2021-07-07',
    posterUrl: '${Const.IMG_URL_300}/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg',
    backdropUrl: '${Const.IMG_URL_500}/dq18nCTTLpy9PmtzZI6Y2yAgdw5.jpg',
    voteAverage: 7.8,
    voteCount: 4680,
    runtime: 134,
    genres: ['Action', 'Adventure', 'Thriller', 'Science Fiction'],
  ),
  Movie(
    title: 'The Tomorrow War',
    overview:
        'The world is stunned when a group of time travelers arrive from the year 2051 to deliver an urgent message: Thirty years in the future, mankind is losing a global war against a deadly alien species. The only hope for survival is for soldiers and civilians from the present to be transported to the future and join the fight. Among those recruited is high school teacher and family man Dan Forester. Determined to save the world for his young daughter, Dan teams up with a brilliant scientist and his estranged father in a desperate quest to rewrite the fate of the planet.',
    releaseDate: '2021-09-03',
    posterUrl: '${Const.IMG_URL_300}/34nDCQZwaEvsy4CFO5hkGRFDCVU.jpg',
    backdropUrl: '${Const.IMG_URL_500}/yizL4cEKsVvl17Wc1mGEIrQtM2F.jpg',
    voteAverage: 8.1,
    voteCount: 137,
    runtime: 138,
    genres: ['Action', 'Science Fiction', 'Adventure'],
  ),
  Movie(
    title: 'Sinaliento',
    overview: '',
    releaseDate: '2021-08-11',
    posterUrl: '${Const.IMG_URL_300}/oxNoVgbu2v9ETL93Kri1pw8osYf.jpg',
    backdropUrl: '${Const.IMG_URL_500}/1Txzm4bY5ZDqvgMl7MmHeBMl7HH.jpg',
    voteAverage: 7.7,
    voteCount: 15,
    runtime: 106,
    genres: ['Crime', 'Drama', 'Thriller'],
  ),
  Movie(
    title: 'Un rescate de huevitos',
    overview:
        'A rooster and his fowl partner embark on a dangerous trip to the Congo to recover their stolen eggs from a group of Russian goons.',
    releaseDate: '2021-08-12',
    posterUrl: '${Const.IMG_URL_300}/wrlQnKHLCBheXMNWotyr5cVDqNM.jpg',
    backdropUrl: '${Const.IMG_URL_500}/uHmvk8FnoxpgujDU0RIXLkv2fNt.jpg',
    voteAverage: 8.3,
    voteCount: 198,
    runtime: 0,
    genres: ['Animation', 'Comedy'],
  ),
  Movie(
    title: 'Space Jam: A New Legacy',
    overview:
        'When LeBron and his young son Dom are trapped in a digital space by a rogue A.I., LeBron must get them home safe by leading Bugs, Lola Bunny and the whole gang of notoriously undisciplined Looney Tunes to victory over the A.I.\'s digitized champions on the court. It\'s Tunes versus Goons in the highest-stakes challenge of his life.',
    releaseDate: '2021-07-08',
    posterUrl: '${Const.IMG_URL_300}/5bFK5d3mVTAvBCXi5NPWH0tYjKl.jpg',
    backdropUrl: '${Const.IMG_URL_500}/8s4h9friP6Ci3adRGahHARVd76E.jpg',
    voteAverage: 7.4,
    voteCount: 2049,
    runtime: 115,
    genres: ['Animation', 'Comedy', 'Family', 'Science Fiction'],
  ),
  Movie(
    title: 'Narco Sub',
    overview:
        'A man will become a criminal to save his family.  Director: Shawn Welling  Writer: Derek H. Potts  Stars: Tom Vera, Tom Sizemore, Lee Majors |',
    releaseDate: '2021-07-22',
    posterUrl: '${Const.IMG_URL_300}/7p0O4mKYLIhU2E5Zcq9Z3vOZ4e9.jpg',
    backdropUrl: '${Const.IMG_URL_500}/AjQgFtfXTmmMVuaH2VfQDdGbeQH.jpg',
    voteAverage: 7.1,
    voteCount: 42,
    runtime: 93,
    genres: ['Action', 'Drama', 'Crime'],
  ),
];
