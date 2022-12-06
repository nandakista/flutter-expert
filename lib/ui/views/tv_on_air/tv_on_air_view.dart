import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/widgets/card_item.dart';

import 'bloc/tv_on_air_bloc.dart';

class TvOnAirView extends StatelessWidget {
  static const route = '/tv/on-air';
  const TvOnAirView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air Tv Series'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TvOnAirBloc, TvOnAirState>(
            builder: (context, state) {
              if (state is TvOnAirLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvOnAirError) {
                return Center(
                  child: Text(
                    key: const Key('error_message'),
                    state.message,
                  ),
                );
              } else if (state is TvOnAirHasData) {
                return ListView.builder(
                  itemCount: state.result.length,
                  itemBuilder: (context, index) {
                    final tv = state.result[index];
                    return CardItem(
                      title: tv.name.toString(),
                      overview: tv.overview.toString(),
                      imageUrl: '${Constant.baseUrlImage}${tv.posterPath}',
                      voteAverage: tv.voteAverage ?? 0,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TvDetailView.route,
                          arguments: tv.id,
                        );
                      },
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
