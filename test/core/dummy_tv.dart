import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/season.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/entities/watchlist.dart';

final tTvList = [
  const Tv(
    id: 60625,
    name: 'Rick and Morty',
    posterPath: '/url.jpg',
    overview: 'overview',
    voteAverage: 8.7,
    voteCount: 7426,
    popularity: 1377.974,
    originalName: 'Rick and Morty',
    originalLanguage: 'en',
    originCountry: ['US'],
    firstAirDate: '2013-12-02',
    genreIds: [16, 35, 10765, 10759],
    backdropPath: '/url.jpg',
  ),
];

const tTvDetail = TvDetail(
  adult: false,
  backdropPath: "/url.jpg",
  episodeRunTime: [39],
  firstAirDate: "2021-11-06",
  genres: [
    Genre(id: 16, name: "Animation"),
    Genre(id: 10765, name: "Sci-Fi & Fantasy"),
  ],
  homepage: "https://arcane.com",
  id: 94605,
  inProduction: true,
  languages: ["am", "ar", "en", "hz"],
  lastAirDate: "2021-11-20",
  name: "Arcane",
  nextEpisodeToAir: null,
  numberOfEpisodes: 9,
  numberOfSeasons: 2,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Arcane",
  overview: "overview",
  popularity: 95.866,
  posterPath: "/url.jpg",
  seasons: [
    Season(
        airDate: "2021-11-06",
        episodeCount: 9,
        id: 134187,
        name: "Season 1",
        overview: "",
        posterPath: "/url.jpg",
        seasonNumber: 1)
  ],
  status: "Returning Series",
  tagline: "",
  type: "Scripted",
  voteAverage: 8.746,
  voteCount: 2704,
);

const tTvWatchlistList = [
  Watchlist(
    id: 94605,
    title: 'Arcane',
    posterPath: '/url.jpg',
    overview: 'overview',
    voteAverage: 8.746,
  ),
];

const tTvWatchlist = Watchlist(
  id: 94605,
  title: 'Arcane',
  posterPath: '/url.jpg',
  overview: 'overview',
  voteAverage: 8.746,
);