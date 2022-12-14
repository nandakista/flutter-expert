import 'package:submission/data/models/season_model.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/season.dart';
import 'package:submission/domain/entities/tv_detail.dart';

import 'genre_model.dart';

class TvDetailModel extends TvDetail {
  const TvDetailModel({
    final bool? adult,
    final String? backdropPath,
    final List<int>? episodeRunTime,
    final String? firstAirDate,
    final List<Genre>? genres,
    final String? homepage,
    final int? id,
    final bool? inProduction,
    final List<String>? languages,
    final String? lastAirDate,
    final String? name,
    final dynamic nextEpisodeToAir,
    final int? numberOfEpisodes,
    final int? numberOfSeasons,
    final List<String>? originCountry,
    final String? originalLanguage,
    final String? originalName,
    final String? overview,
    final double? popularity,
    final String? posterPath,
    final List<Season>? seasons,
    final String? status,
    final String? tagline,
    final String? type,
    final double? voteAverage,
    final int? voteCount,
  }) : super(
          adult: adult,
          backdropPath: backdropPath,
          episodeRunTime: episodeRunTime,
          firstAirDate: firstAirDate,
          genres: genres,
          homepage: homepage,
          id: id,
          inProduction: inProduction,
          languages: languages,
          lastAirDate: lastAirDate,
          name: name,
          nextEpisodeToAir: nextEpisodeToAir,
          numberOfEpisodes: numberOfEpisodes,
          numberOfSeasons: numberOfSeasons,
          originCountry: originCountry,
          originalLanguage: originalLanguage,
          originalName: originalName,
          overview: overview,
          popularity: popularity,
          posterPath: posterPath,
          seasons: seasons,
          status: status,
          tagline: tagline,
          type: type,
          voteAverage: voteAverage,
          voteCount: voteCount,
        );

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate: json["first_air_date"],
        genres:
            List<Genre>.from(json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        inProduction: json["in_production"],
        languages: List<String>.from(json["languages"].map((x) => x)),
        lastAirDate: json["last_air_date"],
        name: json["name"],
        nextEpisodeToAir: json["next_episode_to_air"],
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        seasons: List<Season>.from(
            json["seasons"].map((x) => SeasonModel.fromJson(x))),
        status: json["status"],
        tagline: json["tagline"],
        type: json["type"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "episode_run_time":
            List<dynamic>.from(episodeRunTime?.map((x) => x) ?? []),
        "first_air_date": firstAirDate,
        "genres": List<dynamic>.from(genres?.map(
              (x) => GenreModel(id: x.id, name: x.name).toJson(),
            ) ??
            []),
        "homepage": homepage,
        "id": id,
        "in_production": inProduction,
        "languages": List<dynamic>.from(languages?.map((x) => x) ?? []),
        "last_air_date": lastAirDate,
        "name": name,
        "next_episode_to_air": nextEpisodeToAir,
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "origin_country":
            List<dynamic>.from(originCountry?.map((x) => x) ?? []),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "seasons": List<dynamic>.from(seasons?.map((x) => SeasonModel(
                  seasonNumber: x.seasonNumber,
                  posterPath: x.posterPath,
                  overview: x.overview,
                  name: x.name,
                  id: x.id,
                  episodeCount: x.episodeCount,
                  airDate: x.airDate,
                ).toJson()) ??
            []),
        "status": status,
        "tagline": tagline,
        "type": type,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
