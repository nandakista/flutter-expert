import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/top_rated/top_rated_provider.dart';
import 'package:submission/ui/widgets/card_item.dart';

import '../../../core/constant/network_state.dart';

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
          child: Consumer<TopRatedProvider>(
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
}
