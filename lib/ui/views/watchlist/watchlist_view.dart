import 'package:flutter/material.dart';
import 'package:submission/ui/views/watchlist/movie/watchlist_movie_view.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_view.dart';

class WatchlistView extends StatefulWidget {
  static const route = '/watchlist';

  const WatchlistView({Key? key}) : super(key: key);

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> with RouteAware {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist Movies'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movie'),
              Tab(text: 'Tv Series'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              WatchlistMovieView(),
              WatchlistTvView()
            ],
          ),
        ),
      ),
    );
  }
}
