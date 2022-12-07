import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/bloc/detail_bloc.dart';
import 'package:submission/ui/views/detail/detail_view.dart';

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
        const Divider(),
        BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if(state is DetailHasData) {
              if(state.recommendedMovie.isEmpty) {
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
                    itemCount: state.recommendedMovie.length,
                    itemBuilder: (context, index) {
                      final movie = state.recommendedMovie[index];
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
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
