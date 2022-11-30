import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/ui/widgets/card_item.dart';

import '../tv_detail/tv_detail_view.dart';
import 'tv_top_rated_provider.dart';

class TvTopRatedView extends StatelessWidget {
  static const route = '/tv/top-rated';
  const TvTopRatedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv Series'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<TvTopRatedProvider>(
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
        ),
      ),
    );
  }
}
