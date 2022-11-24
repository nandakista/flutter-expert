import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/popular/popular_provider.dart';
import 'package:submission/ui/views/popular/popular_view.dart';

import '../widgets/movie_item.dart';

class PopularComponents extends StatelessWidget {
  const PopularComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular',
              style: AppStyle.subtitle2,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, PopularView.route),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text('See More'),
                    Icon(Icons.arrow_forward_ios, size: 16)
                  ],
                ),
              ),
            ),
          ],
        ),
        Consumer<PopularProvider>(
          builder: (context, provider, child) {
            switch (provider.state) {
              case NetworkState.empty:
                return const Text('Empty Movie');
              case NetworkState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case NetworkState.loaded:
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.data.length,
                    itemBuilder: (context, index) {
                      final item = provider.data[index];
                      return MovieItem(data: item);
                    },
                  ),
                );
              case NetworkState.error:
                return Text('Failed : ${provider.message}');
            }
          },
        ),
      ],
    );
  }
}
