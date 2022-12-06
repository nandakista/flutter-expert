import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/widgets/card_item.dart';

import 'bloc/tv_search_bloc.dart';

class TvSearchView extends StatelessWidget {
  static const route = '/tv/search';
  const TvSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<TvSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: AppStyle.subtitle3,
            ),
            BlocBuilder<TvSearchBloc, TvSearchState>(
              builder: (context, state) {
                if(state is TvSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      key: Key('loading_indicator_state'),
                    ),
                  );
                } else if (state is TvSearchEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        key: const Key('empty_message'),
                        state.message,
                      ),
                    ),
                  );
                } else if (state is TvSearchError) {
                  return Center(
                    child: Text(
                      key: const Key('error_message'),
                      state.message,
                    ),
                  );
                } else if (state is TvSearchHasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.result.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = state.result[index];
                        return CardItem(
                          title: tv.name.toString(),
                          overview: tv.overview.toString(),
                          imageUrl:
                          '${Constant.baseUrlImage}${tv.posterPath}',
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
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text("Let's find your favorite TV Series"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
