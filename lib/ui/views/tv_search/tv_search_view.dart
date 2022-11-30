import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_view.dart';
import 'package:submission/ui/views/tv_search/tv_search_provider.dart';
import 'package:submission/ui/widgets/card_item.dart';

class TvSearchView extends StatelessWidget {
  static const route = '/tv/search';
  const TvSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TvSearchProvider>(context, listen: false)
      ..toInitial();
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
              onSubmitted: (query) {
                provider.onSearchTv(query);
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
            Consumer<TvSearchProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case RequestState.initial:
                    return const Expanded(
                      child: Center(
                        child: Text("Let's find your favorite TV Series"),
                      ),
                    );
                  case RequestState.empty:
                    return Expanded(
                      child: Center(
                        child: Text(
                          key: const Key('empty_message'),
                          provider.message,
                        ),
                      ),
                    );
                  case RequestState.loading:
                    return const Center(
                      child: CircularProgressIndicator(
                        key: Key('loading_indicator_state'),
                      ),
                    );
                  case RequestState.success:
                    return Expanded(
                      child: ListView.builder(
                        itemCount: provider.data.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tv = provider.data[index];
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
                  case RequestState.error:
                    return Center(
                      child: Text(
                        key: const Key('error_message'),
                        provider.message,
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
