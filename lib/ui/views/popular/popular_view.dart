import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';

import '../../widgets/card_item.dart';
import '../detail/detail_view.dart';
import 'bloc/popular_bloc.dart';

class PopularView extends StatelessWidget {
  static const route = '/popular';

  const PopularView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularBloc, PopularState>(
            builder: (context, state) {
              if(state is PopularLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(state is PopularError) {
                return Center(
                  child: Text(
                    key: const Key('error_message'),
                    state.message,
                  ),
                );
              } else if (state is PopularHasData) {
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
