import 'package:submission/domain/entities/movie_table.dart';

class MovieTableModel extends MovieTable {
  const MovieTableModel({
    required final int id,
    final String? title,
    final String? posterPath,
    final String? overview,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          overview: overview,
        );

  factory MovieTableModel.fromJson(Map<String, dynamic> json) =>
      MovieTableModel(
        id: json['id'],
        title: json['title'],
        posterPath: json['posterPath'],
        overview: json['overview'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
  };
}
