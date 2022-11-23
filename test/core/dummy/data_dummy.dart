import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';

const dummyMovie = Movie(
  adult: false,
  backdropPath: '/url.jpg',
  genreIds: [
    28,
    14,
    878,
  ],
  id: 436270,
  originalTitle: 'Black Adam',
  overview: 'Some Overview',
  popularity: 23828.993,
  posterPath: '/url.jpg',
  releaseDate: '2022-10-19',
  title: 'Black Adam',
  video: false,
  voteAverage: 6.8,
  voteCount: 1270,
);

final dummyMovieList = [
  dummyMovie,
];

const dummyMovieDetail = MovieDetail(
  adult: false,
  backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
  genres: [
    Genre(id: 28, name: 'Action'),
  ],
  homepage: 'https://www.dc.com/BlackAdam',
  id: 436270,
  originalTitle: 'Black Adam',
  overview: 'Some Overview',
  posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
  releaseDate: '2022-10-19',
  runtime: 125,
  title: 'Black Adam',
  voteAverage: 6.8,
  voteCount: 1284,
  budget: 200000000,
  imdbId: 'tt6443346',
  originalLanguage: '',
  popularity: 23828.993,
  revenue: 351000000,
  status: 'Released',
  tagline: 'The world needed a hero. It got Black Adam.',
  video: false,
);
