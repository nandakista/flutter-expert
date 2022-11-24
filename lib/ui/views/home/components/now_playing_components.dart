import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';

import '../home_provider.dart';
import '../widgets/movie_item.dart';

class NowPlayingComponents extends StatelessWidget {
  const NowPlayingComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Text(
            'Now Playing',
            style: AppStyle.subtitle2,
          ),
          const SizedBox(height: 12),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case NetworkState.initial:
                  return Container();
                case NetworkState.empty:
                  return const Text(
                    key: Key('now_playing_component_empty'),
                    'Empty Movie',
                  );
                case NetworkState.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                      key: Key('now_playing_component_loading'),
                    ),
                  );
                case NetworkState.loaded:
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.data.length,
                      itemBuilder: (context, index) {
                        final item = provider.data[index];
                        return MovieItem(data: item);
                      },
                    ),
                  );
                case NetworkState.error:
                  return Text(
                    key: const Key('now_playing_component_error'),
                    'Failed : ${provider.message}',
                  );
              }
            },
          )
        ],
      ),
    );
  }
}
