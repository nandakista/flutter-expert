import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/top_rated/bloc/top_rated_bloc.dart';
import 'package:submission/ui/views/top_rated/top_rated_view.dart';
import 'package:submission/ui/widgets/content_wrapper.dart';

import '../../../widgets/cover_item.dart';

class TopRatedComponents extends StatelessWidget {
  const TopRatedComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContentWrapper(
                child: Text(
                  'Top Rate',
                  style: AppStyle.subtitle2,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, TopRatedView.route),
                child: const ContentWrapper(
                  child: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          BlocBuilder<TopRatedBloc, TopRatedState>(
            builder: (context, state) {
              if (state is TopRatedLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('top_rated_component_loading'),
                  ),
                );
              } else if (state is TopRatedError) {
                return Text(
                  key: const Key('top_rated_component_error'),
                  'Failed : ${state.message}',
                );
              } else if (state is TopRatedHasData) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.result.length,
                    itemBuilder: (context, index) {
                      final item = state.result[index];
                      return CoverItem(
                        onTap: () {
                          Navigator.pushNamed(context, DetailView.route,
                              arguments: item.id);
                        },
                        imageUrl: '${Constant.baseUrlImage}${item.posterPath}',
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
