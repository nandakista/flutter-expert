import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/widgets/content_wrapper.dart';

import '../home_provider.dart';
import '../../../widgets/cover_item.dart';

class NowPlayingComponents extends StatelessWidget {
  const NowPlayingComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ContentWrapper(
            child: Text(
              'Now Playing',
              style: AppStyle.subtitle2,
            ),
          ),
          const SizedBox(height: 4),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case RequestState.initial:
                  return Container();
                case RequestState.empty:
                  return const Text(
                    key: Key('now_playing_component_empty'),
                    'Empty Movie',
                  );
                case RequestState.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                      key: Key('now_playing_component_loading'),
                    ),
                  );
                case RequestState.success:
                  return SizedBox(
                    height: 500,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: provider.data.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        mainAxisExtent: 180,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = provider.data[index];
                        return CoverItem(
                          imageUrl:
                              '${Constant.baseUrlImage}${item.posterPath}',
                          onTap: () {
                            Navigator.pushNamed(context, DetailView.route,
                                arguments: item.id);
                          },
                        );
                      },
                    ),
                  );
                case RequestState.error:
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
