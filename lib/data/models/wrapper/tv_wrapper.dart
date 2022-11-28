import 'package:equatable/equatable.dart';
import 'package:submission/data/models/tv_model.dart';

import '../movie_model.dart';

class TvWrapper extends Equatable {
  final List<TvModel> data;

  const TvWrapper({required this.data});

  factory TvWrapper.fromJson(Map<String, dynamic> json) => TvWrapper(
        data: List<TvModel>.from(
          (json["results"] as List)
              .map((x) => TvModel.fromJson(x))
              .where((element) => element.posterPath != null),
        ),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(
          data.map(
            (x) => x.toJson(),
          ),
        ),
      };

  @override
  List<Object> get props => [data];
}
