import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/top_rated/bloc/top_rated_bloc.dart';
import 'package:submission/ui/widgets/card_item.dart';

class TopRatedView extends StatelessWidget {
  static const route = '/top-rated';

  const TopRatedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TopRatedBloc, TopRatedState>(
            builder: (context, state) {
              if (state is TopRatedLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedError) {
                return Center(
                  child: Text(
                    key: const Key('error_message'),
                    state.message,
                  ),
                );
              } else if (state is TopRatedHasData) {
                return ListView.builder(
                  itemCount: state.result.length,
                  itemBuilder: (context, index) {
                    final movie = state.result[index];
                    return CardItem(
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
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
