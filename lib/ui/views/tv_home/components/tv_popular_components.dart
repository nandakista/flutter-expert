import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/views/tv_popular/tv_popular_provider.dart';
import 'package:submission/ui/views/tv_popular/tv_popular_view.dart';
import 'package:submission/ui/widgets/content_wrapper.dart';
import 'package:submission/ui/widgets/cover_item.dart';

class TvPopularComponents extends StatelessWidget {
  const TvPopularComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContentWrapper(
                child: Text(
                  'Popular',
                  style: AppStyle.subtitle2,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, TvPopularView.route),
                child: const ContentWrapper(
                  child: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Consumer<TvPopularProvider>(
            builder: (context, provider, child) {
              switch (provider.state) {
                case RequestState.initial:
                  return Container();
                case RequestState.empty:
                  return const Text(
                    key: Key('popular_component_empty'),
                    'Empty Tv',
                  );
                case RequestState.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                      key: Key('popular_component_loading'),
                    ),
                  );
                case RequestState.success:
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      key: const Key('list_popular_component'),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.data.length,
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
                    key: const Key('popular_component_error'),
                    'Failed : ${provider.message}',
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
