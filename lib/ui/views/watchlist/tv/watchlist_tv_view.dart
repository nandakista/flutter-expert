import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/widgets/card_item.dart';

import 'bloc/watchlist_tv_bloc.dart';

class WatchlistTvView extends StatelessWidget {
  static const route = '/watchlist/tv';
  const WatchlistTvView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
        builder: (context, state) {
          if (state is WatchlistTvHasData) {
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                final tv = state.result[index];
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
                    ).then((_) {
                      context.read<WatchlistTvBloc>().add(LoadWatchlistTv());
                    });
                  },
                );
              },
            );
          } else if (state is WatchlistTvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistTvEmpty) {
            return Center(
              child: Text(
                key: const Key('empty_message'),
                state.message,
              ),
            );
          } else if (state is WatchlistTvError) {
            return Center(
              child: Text(
                key: const Key('error_message'),
                state.message,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
