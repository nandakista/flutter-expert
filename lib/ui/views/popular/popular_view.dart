import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/ui/views/popular/popular_provider.dart';

import '../../../core/constant/network_state.dart';
import '../../widgets/movie_item_list.dart';

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
          child: Consumer<PopularProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case NetworkState.initial:
                  return Container();
                case NetworkState.empty:
                  return Center(
                    child: Text(
                      key: const Key('empty_message'),
                      provider.message,
                    ),
                  );
                case NetworkState.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case NetworkState.loaded:
                  return ListView.builder(
                    itemCount: provider.data.length,
                    itemBuilder: (context, index) {
                      final movie = provider.data[index];
                      return MovieItemList(data: movie);
                    },
                  );
                case NetworkState.error:
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
