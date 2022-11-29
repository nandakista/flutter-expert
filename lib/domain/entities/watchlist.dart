import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';

import 'movie.dart';
import 'movie_detail.dart';

class Watchlist extends Equatable {
  const Watchlist({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    this.isMovie,
  });

  final int? id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;
  final bool? isMovie;

  Movie toMovieEntity() => Movie(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        voteAverage: voteAverage,
      );

  factory Watchlist.fromMovieEntity({
    required MovieDetail data,
    required bool isMovie,
  }) =>
      Watchlist(
        id: data.id,
        title: data.title,
        posterPath: data.posterPath,
        overview: data.overview,
        voteAverage: data.voteAverage,
        isMovie: isMovie,
      );

  Tv toTvEntity() => Tv(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: title,
        voteAverage: voteAverage,
      );

  factory Watchlist.fromTvEntity({
    required TvDetail data,
    required bool isMovie,
  }) =>
      Watchlist(
        id: data.id,
        title: data.name,
        posterPath: data.posterPath,
        overview: data.overview,
        voteAverage: data.voteAverage,
        isMovie: isMovie,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview, voteAverage];
}
