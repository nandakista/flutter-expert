import 'package:equatable/equatable.dart';

class MovieTable extends Equatable {
  const MovieTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  @override
  List<Object?> get props => [id, title, posterPath, overview];
}
