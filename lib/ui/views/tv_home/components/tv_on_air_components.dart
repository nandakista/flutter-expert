import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/views/tv_on_air/bloc/tv_on_air_bloc.dart';
import 'package:submission/ui/views/tv_on_air/tv_on_air_view.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContentWrapper(
                child: Text(
                  'On The Air',
                  style: AppStyle.subtitle2,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, TvOnAirView.route),
                child: const ContentWrapper(
                  child: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          BlocBuilder<TvOnAirBloc, TvOnAirState>(
            builder: (context, state) {
              if (state is TvOnAirLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('now_playing_component_loading'),
                  ),
                );
              } else if (state is TvOnAirError) {
                return Text(
                  key: const Key('now_playing_component_error'),
                  'Failed : ${state.message}',
                );
              } else if (state is TvOnAirHasData) {
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
                        onTap: () {
                          Navigator.pushNamed(context, TvDetailView.route,
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
