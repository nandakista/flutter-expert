import '../repositories/movie_repository.dart';

class GetWatchlistExistStatus {
  final MovieRepository repository;

  GetWatchlistExistStatus({required this.repository});

  Future<bool> call(int id) {
    return repository.hasAddedToWatchlist(id);
  }
}