import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/repositories/tv_repository.dart';

import '../../core/error/failure.dart';

class SearchTv {
  final TvRepository repository;

  SearchTv({required this.repository});

  Future<Either<Failure, List<Tv>>> call(String query) {
    return repository.searchTv(query);
  }
}