import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/views/home/bloc/home_bloc.dart';
import 'package:submission/ui/widgets/content_wrapper.dart';

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
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('now_playing_component_loading'),
                  ),
                );
              } else if (state is HomeError) {
                return Text(
                  key: const Key('now_playing_component_error'),
                  'Failed : ${state.message}',
                );
              } else if (state is HomeHasData) {
                return SizedBox(
                  height: 500,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.result.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisExtent: 180,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = state.result[index];
                      return CoverItem(
                        imageUrl: '${Constant.baseUrlImage}${item.posterPath}',
                        onTap: () {
                          Navigator.pushNamed(context, DetailView.route,
                              arguments: item.id);
                        },
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
