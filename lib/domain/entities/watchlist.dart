import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';

import 'movie.dart';
import 'movie_detail.dart';

class MovieWatchlist extends Equatable {
  const MovieWatchlist({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });

  final int? id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;

  Movie toMovieEntity() => Movie(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        voteAverage: voteAverage,
      );

  factory MovieWatchlist.fromMovieEntity(MovieDetail movie) => MovieWatchlist(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
      );

  Tv toTvEntity() => Tv(
    id: id,
    overview: overview,
    posterPath: posterPath,
    name: title,
    voteAverage: voteAverage,
  );

  factory MovieWatchlist.fromTvEntity(TvDetail movie) => MovieWatchlist(
    id: movie.id,
    title: movie.name,
    posterPath: movie.posterPath,
    overview: movie.overview,
    voteAverage: movie.voteAverage,
  );

  @override
  List<Object?> get props => [id, title, posterPath, overview, voteAverage];
}
