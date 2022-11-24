import 'package:get_it/get_it.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:submission/ui/views/home/home_provider.dart';
import 'package:submission/ui/views/popular/popular_provider.dart';
import 'package:submission/ui/views/search/search_provider.dart';
import 'package:submission/ui/views/top_rated/top_rated_provider.dart';
import 'package:submission/ui/views/watchlist/watchlist_provider.dart';
import 'package:http/http.dart' as http;

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

final locator = GetIt.instance;

void init() {
  // Http Client
  locator.registerLazySingleton(() => http.Client());

  // Provider
  locator.registerFactory(
    () => HomeProvider(
      getNowPlayingMovies: locator<GetNowPlayingMovies>(),
    ),
  );

  locator.registerFactory(
    () => WatchlistProvider(),
  );
  locator.registerFactory(
    () => SearchProvider(
      searchMovie: locator<SearchMovie>(),
    ),
  );
  locator.registerFactory(
    () => PopularProvider(
      getPopularMovies: locator<GetPopularMovies>(),
    ),
  );

  locator.registerFactory(
    () => TopRatedProvider(
      getTopRatedMovies: locator<GetTopRatedMovies>(),
    ),
  );

  locator.registerFactory(
    () => DetailProvider(
      getDetailMovie: locator<GetDetailMovie>(),
      getRecommendationsMovies: locator<GetRecommendedMovies>(),
    ),
  );

  // Usecases
  locator.registerLazySingleton(
    () => GetNowPlayingMovies(
      repository: locator<MovieRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GetPopularMovies(
      repository: locator<MovieRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTopRatedMovies(
      repository: locator<MovieRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GetDetailMovie(
      repository: locator<MovieRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GetRecommendedMovies(
      repository: locator<MovieRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchMovie(
      repository: locator<MovieRepository>(),
    ),
  );

  // Repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(serverSource: locator<MovieServerSource>()),
  );

  // Sources
  locator.registerLazySingleton<MovieServerSource>(
    () => MovieServerSourceImpl(
      client: locator<http.Client>(),
    ),
  );
}
