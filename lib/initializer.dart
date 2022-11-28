import 'package:get_it/get_it.dart';
import 'package:submission/data/sources/local/watchlist_local_source.dart';
import 'package:submission/data/sources/local/watchlist_local_source_impl.dart';
import 'package:submission/domain/usecases/get_watchlist_movie.dart';
import 'package:submission/domain/usecases/get_watchlist_movie_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_movie.dart';
import 'package:submission/domain/usecases/save_watchlist_movie.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:submission/ui/views/home/home_provider.dart';
import 'package:submission/ui/views/popular/popular_provider.dart';
import 'package:submission/ui/views/search/search_provider.dart';
import 'package:submission/ui/views/top_rated/top_rated_provider.dart';
import 'package:submission/ui/views/watchlist/watchlist_provider.dart';
import 'package:http/http.dart' as http;

import 'core/database/dao/watchlist_dao.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'data/sources/server/movie_server_source.dart';
import 'data/sources/server/movie_server_source_impl.dart';
import 'domain/repositories/movie_repository.dart';
import 'domain/usecases/get_detail_movie.dart';
import 'domain/usecases/get_now_playing_movies.dart';
import 'domain/usecases/get_popular_movies.dart';
import 'domain/usecases/get_recommended_movies.dart';
import 'domain/usecases/get_top_rated_movies.dart';
import 'domain/usecases/search_movie.dart';

final sl = GetIt.instance;

void init() {
  // Http Client
  sl.registerLazySingleton(() => http.Client());

  // Provider
  sl.registerFactory(
    () => HomeProvider(
      getNowPlayingMovies: sl<GetNowPlayingMovies>(),
    ),
  );

  sl.registerFactory(
    () => WatchlistProvider(getWatchlist: sl<GetWatchlistMovie>()),
  );
  sl.registerFactory(
    () => SearchProvider(
      searchMovie: sl<SearchMovie>(),
    ),
  );
  sl.registerFactory(
    () => PopularProvider(
      getPopularMovies: sl<GetPopularMovies>(),
    ),
  );

  sl.registerFactory(
    () => TopRatedProvider(
      getTopRatedMovies: sl<GetTopRatedMovies>(),
    ),
  );

  sl.registerFactory(
    () => DetailProvider(
      getDetailMovie: sl<GetDetailMovie>(),
      getRecommendationsMovies: sl<GetRecommendedMovies>(),
      getWatchlistExist: sl<GetWatchlistMovieExistStatus>(),
      saveWatchlist: sl<SaveWatchlistMovie>(),
      removeWatchlist: sl<RemoveWatchlistMovie>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(
    () => GetNowPlayingMovies(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetPopularMovies(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTopRatedMovies(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDetailMovie(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetRecommendedMovies(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => SearchMovie(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWatchlistMovie(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWatchlistMovieExistStatus(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => RemoveWatchlistMovie(
      repository: sl<MovieRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => SaveWatchlistMovie(
      repository: sl<MovieRepository>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      serverSource: sl<MovieServerSource>(),
      localDataSource: sl<WatchlistLocalSource>(),
    ),
  );

  // Sources
  sl.registerLazySingleton<MovieServerSource>(
    () => MovieServerSourceImpl(
      client: sl<http.Client>(),
    ),
  );
  sl.registerLazySingleton<WatchlistLocalSource>(
    () => WatchlistLocalSourceImpl(
      dao: sl<WatchlistDao>(),
    ),
  );

  // Dao
  sl.registerLazySingleton<WatchlistDao>(() => WatchlistDao());
}
