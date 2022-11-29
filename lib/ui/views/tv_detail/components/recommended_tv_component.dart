import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_provider.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';

class RecommendedTvComponent extends StatelessWidget {
  const RecommendedTvComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: AppStyle.subtitle4,
        ),
        const Divider(),
        Consumer<TvDetailProvider>(
          builder: (context, provider, child) {
            switch (provider.recommendationState) {
              case RequestState.initial:
                return Container();
              case RequestState.empty:
                return Column(
                  children: const [
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        key: Key('empty_recommend_message'),
                        'No Recommendations',
                      ),
                    ),
                  ],
                );
              case RequestState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case RequestState.success:
                if (provider.recommendedTv.isEmpty) {
                  return Center(
                    child: Text(provider.message),
                  );
                } else {
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.recommendedTv.length,
                      itemBuilder: (context, index) {
                        final tv = provider.recommendedTv[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                TvDetailView.route,
                                arguments: tv.id,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              case RequestState.error:
                return Center(
                  child: Text(
                    key: const Key('error_recommend_message'),
                    provider.message,
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
