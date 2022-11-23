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
      appBar: AppBar(title: const Text('Popular Movies'),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<PopularProvider>(
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
