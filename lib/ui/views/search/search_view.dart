import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/ui/views/search/search_provider.dart';
import 'package:submission/ui/widgets/movie_item_list.dart';

class SearchView extends StatelessWidget {
  static const route = '/search';

  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context, listen: false)
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
                provider.onSearchMovie(query);
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
            Consumer<SearchProvider>(
              builder: (context, provider, child) {
                switch (provider.state) {
                  case NetworkState.initial:
                    return Container();
                  case NetworkState.empty:
                    return Center(
                      child: Text(
                        key: const Key('empty_message'),
                        provider.message,
                      ),
                    );
                  case NetworkState.loading:
                    return const Center(
                      child: CircularProgressIndicator(
                        key: Key('loading_indicator_state'),
                      ),
                    );
                  case NetworkState.loaded:
                    return Expanded(
                      child: ListView.builder(
                        itemCount: provider.data.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = provider.data[index];
                          return MovieItemList(data: movie);
                        },
                      ),
                    );
                  case NetworkState.error:
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
