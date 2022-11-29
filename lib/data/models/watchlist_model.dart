import 'package:submission/domain/entities/watchlist.dart';

class WatchlistModel extends Watchlist {
  const WatchlistModel({
    final int? id,
    final String? title,
    final String? posterPath,
    final String? overview,
    final double? voteAverage,
    final bool? isMovie,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          overview: overview,
          voteAverage: voteAverage,
          isMovie: isMovie,
        );

  factory WatchlistModel.fromJson(Map<String, dynamic> json) => WatchlistModel(
        id: json['id'],
        title: json['title'],
        posterPath: json['posterPath'],
        overview: json['overview'],
        voteAverage: json['voteAverage'],
        isMovie: json['isMovie'] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'voteAverage': voteAverage,
        'isMovie': (isMovie!) ? 1 : 0,
      };
}
