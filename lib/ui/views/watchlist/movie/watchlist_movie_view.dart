import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/watchlist/movie/bloc/watchlist_movie_bloc.dart';
import 'package:submission/ui/widgets/card_item.dart';

class WatchlistMovieView extends StatelessWidget {
  const WatchlistMovieView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieHasData) {
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return CardItem(
                  title: movie.title.toString(),
                  overview: movie.overview.toString(),
                  imageUrl: '${Constant.baseUrlImage}${movie.posterPath}',
                  voteAverage: movie.voteAverage ?? 0,
                  onTap: () async {
                    Navigator.pushNamed(
                      context,
                      DetailView.route,
                      arguments: movie.id,
                    ).then((_) {
                      context
                          .read<WatchlistMovieBloc>()
                          .add(LoadWatchlistMovie());
                    });
                  },
                );
              },
            );
          } else if (state is WatchlistMovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieEmpty) {
            return Center(
              child: Text(
                key: const Key('empty_message'),
                state.message,
              ),
            );
          } else if (state is WatchlistMovieError) {
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
