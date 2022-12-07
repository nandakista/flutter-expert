import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:submission/data/sources/local/watchlist_local_source.dart';
import 'package:submission/data/sources/local/watchlist_local_source_impl.dart';
import 'package:submission/domain/usecases/get_detail_tv.dart';
import 'package:submission/domain/usecases/get_popular_tv.dart';
import 'package:submission/domain/usecases/get_recommended_tv.dart';
import 'package:submission/domain/usecases/get_top_rated_tv.dart';
import 'package:submission/domain/usecases/get_watchlist_movie.dart';
import 'package:submission/domain/usecases/get_watchlist_movie_exist_status.dart';
import 'package:submission/domain/usecases/get_watchlist_tv.dart';
import 'package:submission/domain/usecases/remove_watchlist_movie.dart';
import 'package:submission/domain/usecases/remove_watchlist_tv.dart';
import 'package:submission/domain/usecases/save_watchlist_movie.dart';
import 'package:submission/domain/usecases/save_watchlist_tv.dart';
import 'package:submission/domain/usecases/search_tv.dart';
import 'package:submission/ui/views/detail/bloc/detail_bloc.dart';
import 'package:submission/ui/views/home/bloc/home_bloc.dart';
import 'package:submission/ui/views/popular/bloc/popular_bloc.dart';
import 'package:submission/ui/views/watchlist/movie/watchlist_movie_provider.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_provider.dart';

import 'core/database/dao/watchlist_dao.dart';
import 'core/network/pinning_client.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'data/repositories/tv_repository_impl.dart';
import 'data/sources/server/movie_server_source.dart';
import 'data/sources/server/movie_server_source_impl.dart';
import 'data/sources/server/tv_server_source.dart';
import 'data/sources/server/tv_server_source_impl.dart';
import 'domain/repositories/movie_repository.dart';
import 'domain/repositories/tv_repository.dart';
import 'domain/usecases/get_detail_movie.dart';
import 'domain/usecases/get_now_playing_movies.dart';
import 'domain/usecases/get_on_air_tv.dart';
import 'domain/usecases/get_popular_movies.dart';
import 'domain/usecases/get_recommended_movies.dart';
import 'domain/usecases/get_top_rated_movies.dart';
import 'domain/usecases/get_watchlist_tv_exist_status.dart';
import 'domain/usecases/search_movie.dart';
import 'ui/views/search/bloc/search_bloc.dart';
import 'ui/views/top_rated/bloc/top_rated_bloc.dart';
import 'ui/views/tv_detail/bloc/tv_detail_bloc.dart';
import 'ui/views/tv_on_air/bloc/tv_on_air_bloc.dart';
import 'ui/views/tv_popular/bloc/tv_popular_bloc.dart';
import 'ui/views/tv_search/bloc/tv_search_bloc.dart';
import 'ui/views/tv_top_rated/bloc/tv_top_rated_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Http Client
  final IOClient client = await getHttpClient();
  sl.registerLazySingleton(() => client);

  // Bloc
  sl.registerFactory(
    () => SearchBloc(
      sl<SearchMovie>(),
    ),
  );
  sl.registerFactory(
    () => HomeBloc(
      sl<GetNowPlayingMovies>(),
    ),
  );
  sl.registerFactory(
    () => PopularBloc(
      sl<GetPopularMovies>(),
    ),
  );
  sl.registerFactory(
    () => TopRatedBloc(
      sl<GetTopRatedMovies>(),
    ),
  );
  sl.registerFactory(
    () => TvSearchBloc(
      sl<SearchTv>(),
    ),
  );
  sl.registerFactory(
    () => TvOnAirBloc(
      sl<GetOnAirTv>(),
    ),
  );
  sl.registerFactory(
    () => TvPopularBloc(
      sl<GetPopularTv>(),
    ),
  );
  sl.registerFactory(
    () => TvTopRatedBloc(
      sl<GetTopRatedTv>(),
    ),
  );
  sl.registerFactory(
    () => DetailBloc(
      getDetailMovie: sl<GetDetailMovie>(),
      getRecommendationsMovies: sl<GetRecommendedMovies>(),
      getWatchlistExist: sl<GetWatchlistMovieExistStatus>(),
      saveWatchlist: sl<SaveWatchlistMovie>(),
      removeWatchlist: sl<RemoveWatchlistMovie>(),
    ),
  );
  sl.registerFactory(
        () => TvDetailBloc(
      getDetailTv: sl<GetDetailTv>(),
      getRecommendationsTv: sl<GetRecommendedTv>(),
      getWatchlistExist: sl<GetWatchlistTvExistStatus>(),
      saveWatchlist: sl<SaveWatchlistTv>(),
      removeWatchlist: sl<RemoveWatchlistTv>(),
    ),
  );

  // Provider
  sl.registerFactory(
    () => WatchlistTvProvider(
      getWatchlist: sl<GetWatchlistTv>(),
    ),
  );
  sl.registerFactory(
    () => WatchlistMovieProvider(
      getWatchlist: sl<GetWatchlistMovie>(),
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
  sl.registerLazySingleton(
    () => GetOnAirTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetPopularTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTopRatedTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDetailTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetRecommendedTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => SearchTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => SaveWatchlistTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => RemoveWatchlistTv(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWatchlistTvExistStatus(
      repository: sl<TvRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWatchlistTv(
      repository: sl<TvRepository>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      serverSource: sl<MovieServerSource>(),
      localDataSource: sl<WatchlistLocalSource>(),
    ),
  );
  sl.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      serverSource: sl<TvServerSource>(),
      localDataSource: sl<WatchlistLocalSource>(),
    ),
  );

  // Sources
  sl.registerLazySingleton<MovieServerSource>(
    () => MovieServerSourceImpl(
      client: sl<IOClient>(),
    ),
  );
  sl.registerLazySingleton<TvServerSource>(
    () => TvServerSourceImpl(
      client: sl<IOClient>(),
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
