import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/views/tv_home/provider/tv_home_provider.dart';
import 'package:submission/ui/widgets/content_wrapper.dart';
import 'package:submission/ui/widgets/cover_item.dart';

class TvOnAirComponents extends StatelessWidget {
  const TvOnAirComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ContentWrapper(
            child: Text(
              'On The Air',
              style: AppStyle.subtitle2,
            ),
          ),
          const SizedBox(height: 4),
          Consumer<TvHomeProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case RequestState.initial:
                  return Container();
                case RequestState.empty:
                  return const Text(
                    key: Key('now_playing_component_empty'),
                    'Empty Tv',
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
                          onTap: () {
                            Navigator.pushNamed(context, TvDetailView.route,
                                arguments: item.id);
                          },
                          imageUrl:
                              '${Constant.baseUrlImage}${item.posterPath}',
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
