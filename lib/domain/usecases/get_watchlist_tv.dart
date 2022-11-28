import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetWatchlistTv {
  final TvRepository repository;

  GetWatchlistTv({required this.repository});

  Future<Either<Failure, List<Tv>>> call() {
    return repository.getAllWatchlist();
  }
}
