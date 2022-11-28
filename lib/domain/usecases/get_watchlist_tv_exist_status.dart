import '../repositories/tv_repository.dart';

class GetWatchlistTvExistStatus {
  final TvRepository repository;

  GetWatchlistTvExistStatus({required this.repository});

  Future<bool> call(int id) {
    return repository.hasAddedToWatchlist(id);
  }
}