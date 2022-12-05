import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/ui/views/search/search_provider.dart';
import 'package:submission/ui/widgets/card_item.dart';

import '../detail/detail_view.dart';
import 'bloc/search_bloc.dart';

class SearchView extends StatelessWidget {
  static const route = '/search';

  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<SearchProvider>(context, listen: false)
    //   ..toInitial();
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
                context.read<SearchBloc>().add(OnQueryChanged(query));
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
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if(state is SearchLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is SearchEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        key: const Key('empty_message'),
                        state.message,
                      ),
                    ),
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(
                      key: const Key('error_message'),
                      state.message,
                    ),
                  );
                } else if (state is SearchHasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.result.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = state.result[index];
                        return CardItem(
                          title: movie.title.toString(),
                          overview: movie.overview.toString(),
                          imageUrl: '${Constant.baseUrlImage}${movie.posterPath}',
                          voteAverage: movie.voteAverage ?? 0,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              DetailView.route,
                              arguments: movie.id,
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text("Let's find your favorite movie"),
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
