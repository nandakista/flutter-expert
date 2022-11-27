import 'package:equatable/equatable.dart';

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

  Movie toEntity() => Movie(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        voteAverage: voteAverage,
      );

  factory MovieWatchlist.fromEntity(MovieDetail movie) => MovieWatchlist(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview, voteAverage];
}
