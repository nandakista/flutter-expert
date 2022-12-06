import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/home/home_view.dart';
import 'package:submission/initializer.dart' as di;
import 'package:submission/ui/views/popular/popular_provider.dart';
import 'package:submission/ui/views/popular/popular_view.dart';
import 'package:submission/ui/views/search/search_view.dart';
import 'package:submission/ui/views/top_rated/top_rated_provider.dart';
import 'package:submission/ui/views/top_rated/top_rated_view.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_provider.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/views/tv_on_air/tv_on_air_provider.dart';
import 'package:submission/ui/views/tv_on_air/tv_on_air_view.dart';
import 'package:submission/ui/views/tv_popular/tv_popular_provider.dart';
import 'package:submission/ui/views/tv_popular/tv_popular_view.dart';
import 'package:submission/ui/views/tv_top_rated/tv_top_rated_provider.dart';
import 'package:submission/ui/views/tv_home/tv_home_view.dart';
import 'package:submission/ui/views/tv_search/tv_search_provider.dart';
import 'package:submission/ui/views/tv_search/tv_search_view.dart';
import 'package:submission/ui/views/tv_top_rated/tv_top_rated_view.dart';
import 'package:submission/ui/views/watchlist/movie/watchlist_movie_provider.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_provider.dart';
import 'package:submission/ui/views/watchlist/watchlist_view.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_view.dart';

import 'core/route_observer.dart';
import 'firebase_options.dart';
import 'ui/views/home/bloc/home_bloc.dart';
import 'ui/views/search/bloc/search_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<HomeBloc>()..add(LoadData()),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<TvSearchProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<WatchlistMovieProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<TopRatedProvider>().init(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<PopularProvider>().init(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<DetailProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<TvOnAirProvider>().init(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<TvTopRatedProvider>().init(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<TvPopularProvider>().init(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<TvDetailProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<WatchlistTvProvider>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SkyMovie',
        theme: AppTheme.build(),
        home: const HomeView(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeView.route:
              return MaterialPageRoute(builder: (_) => const HomeView());
            case WatchlistView.route:
              return MaterialPageRoute(builder: (_) => const WatchlistView());
            case PopularView.route:
              return MaterialPageRoute(builder: (_) => const PopularView());
            case TopRatedView.route:
              return MaterialPageRoute(builder: (_) => const TopRatedView());
            case DetailView.route:
              final id = settings.arguments as int;
              return MaterialPageRoute(builder: (_) => DetailView(id: id));
            case SearchView.route:
              return MaterialPageRoute(builder: (_) => const SearchView());
            case TvHomeView.route:
              return MaterialPageRoute(builder: (_) => const TvHomeView());
            case TvDetailView.route:
              final id = settings.arguments as int;
              return MaterialPageRoute(builder: (_) => TvDetailView(id: id));
            case TvSearchView.route:
              return MaterialPageRoute(builder: (_) => const TvSearchView());
            case WatchlistTvView.route:
              return MaterialPageRoute(builder: (_) => const WatchlistTvView());
            case TvOnAirView.route:
              return MaterialPageRoute(builder: (_) => const TvOnAirView());
            case TvPopularView.route:
              return MaterialPageRoute(builder: (_) => const TvPopularView());
            case TvTopRatedView.route:
              return MaterialPageRoute(builder: (_) => const TvTopRatedView());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Oops..\nPage not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
