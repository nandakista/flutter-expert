import 'package:submission/domain/entities/watchlist.dart';

class WatchlistModel extends Watchlist {
  const WatchlistModel({
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

  factory WatchlistModel.fromJson(Map<String, dynamic> json) =>
      WatchlistModel(
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
