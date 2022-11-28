import '../repositories/movie_repository.dart';

class GetWatchlistMovieExistStatus {
  final MovieRepository repository;

  GetWatchlistMovieExistStatus({required this.repository});

  Future<bool> call(int id) {
    return repository.hasAddedToWatchlist(id);
  }
}