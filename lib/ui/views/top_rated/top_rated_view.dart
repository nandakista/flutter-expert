import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/ui/views/top_rated/top_rated_provider.dart';
import 'package:submission/ui/widgets/movie_item_list.dart';

import '../../../core/constant/network_state.dart';

class TopRatedView extends StatelessWidget {
  static const route = '/top-rated';

  const TopRatedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Movies'),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<TopRatedProvider>(
            builder: (context, provider, child) {
              if (provider.state == NetworkState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (provider.state == NetworkState.loaded) {
                return ListView.builder(
                  itemCount: provider.data.length,
                  itemBuilder: (context, index) {
                    final movie = provider.data[index];
                    return MovieItemList(data: movie);
                  },
                );
              } else {
                return Center(
                  child: Text(provider.message),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
