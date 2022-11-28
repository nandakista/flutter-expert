import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/tv_detail.dart';

import '../../core/error/failure.dart';
import '../repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository repository;

  SaveWatchlistTv({required this.repository});

  Future<Either<Failure, String>> call(TvDetail tv) {
    return repository.saveWatchlist(tv);
  }
}
