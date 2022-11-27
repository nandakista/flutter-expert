import 'package:submission/domain/entities/movie_watchlist.dart';

class MovieWatchlistModel extends MovieWatchlist {
  const MovieWatchlistModel({
    final int? id,
    final String? title,
    final String? posterPath,
    final String? overview,
    final double? voteAverage,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          overview: overview,
          voteAverage: voteAverage,
        );

  factory MovieWatchlistModel.fromJson(Map<String, dynamic> json) =>
      MovieWatchlistModel(
        id: json['id'],
        title: json['title'],
        posterPath: json['posterPath'],
        overview: json['overview'],
        voteAverage: json['voteAverage'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'voteAverage': voteAverage,
      };
}
