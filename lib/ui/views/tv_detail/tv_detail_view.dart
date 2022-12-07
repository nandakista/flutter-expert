import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/components/detail_content_view.dart';
import 'package:submission/ui/widgets/colored_status_bar.dart';

import 'bloc/tv_detail_bloc.dart';
import 'components/recommended_tv_component.dart';

class TvDetailView extends StatelessWidget {
  static const route = '/tv/detail';
  const TvDetailView({Key? key, required this.id}) : super(key: key);

  final int id;

  void _mapBlocListener(BuildContext context, TvDetailState state) {
    if (state is TvDetailHasData) {
      if (state.watchlistMessage != '') {
        if (state.watchlistMessage == 'Added to Watchlist' ||
            state.watchlistMessage == 'Removed from Watchlist') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.watchlistMessage)));
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.watchlistMessage),
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredStatusBar(
      color: Colors.black,
      brightness: Brightness.light,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: BlocConsumer<TvDetailBloc, TvDetailState>(
            listener: _mapBlocListener,
            builder: (context, state) {
              if (state is TvDetailHasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (state.hasAddedToWatchList == false) {
                        context.read<TvDetailBloc>().add(
                            AddWatchlist(state.detail, state.recommendedTv));
                      } else {
                        context.read<TvDetailBloc>().add(RemoveFromWatchlist(
                            state.detail, state.recommendedTv));
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.hasAddedToWatchList ? Icons.check : Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Watchlist',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            BlocBuilder<TvDetailBloc, TvDetailState>(
              bloc: context.read<TvDetailBloc>()..add(LoadDetailTv(id)),
              builder: (context, state) {
                if (state is TvDetailHasData) {
                  final tv = state.detail;
                  return SafeArea(
                    child: DetailContent(
                      key: const Key('detail_content'),
                      imageUrl: '${Constant.baseUrlImage}${tv.posterPath}',
                      title: tv.name.toString(),
                      status: tv.status.toString(),
                      overview: tv.overview.toString(),
                      genres: tv.genres ?? [],
                      voteAverage: tv.voteAverage ?? 0,
                      voteCount: tv.voteCount ?? 0,
                      recommendedView: const RecommendedTvComponent(),
                    ),
                  );
                } else if (state is TvDetailError) {
                  return Text(
                    key: const Key('error_message'),
                    state.message,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
