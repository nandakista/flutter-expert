import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/bloc/tv_detail_bloc.dart';
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
        BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            if (state is TvDetailHasData) {
              if (state.recommendedTv.isEmpty) {
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
              } else {
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recommendedTv.length,
                    itemBuilder: (context, index) {
                      final tv = state.recommendedTv[index];
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
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
