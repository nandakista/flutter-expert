import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/repositories/tv_repository.dart';

import '../../core/error/failure.dart';

class GetDetailTv {
  final TvRepository repository;

  GetDetailTv({required this.repository});

  Future<Either<Failure, TvDetail>> call(int id) {
    return repository.getDetailTv(id);
  }
}