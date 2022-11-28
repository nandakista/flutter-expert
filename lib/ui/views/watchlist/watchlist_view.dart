import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/route_observer.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/watchlist/watchlist_provider.dart';
import 'package:submission/ui/widgets/movie_item.dart';

class WatchlistView extends StatefulWidget {
  static const route = '/watchlist';

  const WatchlistView({Key? key}) : super(key: key);

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> with RouteAware {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<WatchlistProvider>(context, listen: false).loadData();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistProvider>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<WatchlistProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case RequestState.initial:
                  return Container();
                case RequestState.empty:
                  return Center(
                    child: Text(
                      key: const Key('empty_message'),
                      provider.message,
                    ),
                  );
                case RequestState.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case RequestState.success:
                  return ListView.builder(
                    itemCount: provider.data.length,
                    itemBuilder: (context, index) {
                      final movie = provider.data[index];
                      return MovieItem(
                        title: movie.title.toString(),
                        overview: movie.overview.toString(),
                        imageUrl: '${Constant.baseUrlImage}${movie.posterPath}',
                        voteAverage: movie.voteAverage ?? 0,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            DetailView.route,
                            arguments: movie.id,
                          );
                        },
                      );
                    },
                  );
                case RequestState.error:
                  return Center(
                    child: Text(
                      key: const Key('error_message'),
                      provider.message,
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
