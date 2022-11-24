import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/detail_view.dart';

import '../detail_provider.dart';

class RecommendedComponent extends StatelessWidget {
  const RecommendedComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: AppStyle.subtitle4,
        ),
        Consumer<DetailProvider>(
          builder: (context, provider, child) {
            switch (provider.recommendationState) {
              case NetworkState.initial:
                return Container();
              case NetworkState.empty:
                return const Center(
                  child: Text(
                    key: Key('empty_recommend_message'),
                    'No Recommendations',
                  ),
                );
              case NetworkState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case NetworkState.loaded:
                if (provider.recommendedMovies.isEmpty) {
                  return Center(
                    child: Text(provider.message),
                  );
                } else {
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.recommendedMovies.length,
                      itemBuilder: (context, index) {
                        final movie = provider.recommendedMovies[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                DetailView.route,
                                arguments: movie.id,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
              case NetworkState.error:
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
