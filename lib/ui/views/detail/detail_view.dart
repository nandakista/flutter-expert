import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/bloc/detail_bloc.dart';
import 'package:submission/ui/widgets/colored_status_bar.dart';

import 'components/detail_content_view.dart';
import 'components/recommended_component.dart';

class DetailView extends StatelessWidget {
  static const route = '/detail';
  const DetailView({Key? key, required this.id}) : super(key: key);

  final int id;

  void _mapBlocListener(BuildContext context, DetailState state) {
    if (state is DetailHasData) {
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
          child: BlocConsumer<DetailBloc, DetailState>(
            listener: _mapBlocListener,
            builder: (context, state) {
              if (state is DetailHasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (state.hasAddedToWatchList == false) {
                        context.read<DetailBloc>().add(
                            AddWatchlist(state.detail, state.recommendedMovie));
                      } else {
                        context.read<DetailBloc>().add(RemoveFromWatchlist(
                            state.detail, state.recommendedMovie));
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
            BlocBuilder<DetailBloc, DetailState>(
              bloc: context.read<DetailBloc>()..add(LoadDetailMovies(id)),
              builder: (context, state) {
                if (state is DetailHasData) {
                  final movie = state.detail;
                  return SafeArea(
                    child: DetailContent(
                      key: const Key('detail_content'),
                      imageUrl: '${Constant.baseUrlImage}${movie.posterPath}',
                      title: movie.title.toString(),
                      status: movie.status.toString(),
                      overview: movie.overview.toString(),
                      runtime: movie.runtime ?? 0,
                      genres: movie.genres ?? [],
                      voteAverage: movie.voteAverage ?? 0,
                      voteCount: movie.voteCount ?? 0,
                      recommendedView: const RecommendedComponent(),
                    ),
                  );
                } else if (state is DetailError) {
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
