import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';

abstract class MovieServerSource {
  Future<MovieDetail> getMovieDetail(int id);
  Future<List<Movie>> getRecommendedMovies(int id);
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> searchMovies(String query);
}