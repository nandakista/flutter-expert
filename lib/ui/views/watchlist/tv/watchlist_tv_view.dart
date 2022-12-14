import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/route_observer.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_provider.dart';
import 'package:submission/ui/widgets/card_item.dart';

class WatchlistTvView extends StatefulWidget {
  static const route = '/watchlist/tv';
  const WatchlistTvView({Key? key}) : super(key: key);

  @override
  State<WatchlistTvView> createState() => _WatchlistTvViewState();
}

class _WatchlistTvViewState extends State<WatchlistTvView> with RouteAware {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<WatchlistTvProvider>(context, listen: false).loadData();
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
    Provider.of<WatchlistTvProvider>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistTvProvider>(
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
                  final tv = provider.data[index];
                  return CardItem(
                    title: tv.name.toString(),
                    overview: tv.overview.toString(),
                    imageUrl: '${Constant.baseUrlImage}${tv.posterPath}',
                    voteAverage: tv.voteAverage ?? 0,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TvDetailView.route,
                        arguments: tv.id,
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
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
