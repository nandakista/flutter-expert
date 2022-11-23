import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/home/home_provider.dart';
import 'package:submission/ui/views/home/widgets/movie_item.dart';
import 'package:submission/ui/views/search/search_view.dart';

import '../../../core/constant/network_state.dart';
import '../popular/popular_view.dart';
import '../top_rated/top_rated_view.dart';
import '../watchlist/watchlist_view.dart';

class HomeView extends StatelessWidget {
  static const route = '/home';

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/ic_avatar.png'),
              ),
              accountName: Text('SkyMovie'),
              accountEmail: Text('nanda@skyriver.com'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.film),
              title: const Text('Movies'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.square_favorites),
              title: const Text('Watchlist'),
              onTap: () => Navigator.pushNamed(context, WatchlistView.route),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Sky Movie'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchView.route);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: AppStyle.subtitle2,
            ),
            const SizedBox(height: 12),
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                final state = provider.nowPlayingState;
                if (state == NetworkState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == NetworkState.loaded) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.nowPlayingMovies.length,
                      itemBuilder: (context, index) {
                        final item = provider.nowPlayingMovies[index];
                        return MovieItem(data: item);
                      },
                    ),
                  );
                } else {
                  return Text('Failed : ${provider.message}');
                }
              },
            ),
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
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                final state = provider.popularState;
                if (state == NetworkState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == NetworkState.loaded) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.popularMovies.length,
                      itemBuilder: (context, index) {
                        final item = provider.popularMovies[index];
                        return MovieItem(data: item);
                      },
                    ),
                  );
                } else {
                  return Text('Failed : ${provider.message}');
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Rate',
                  style: AppStyle.subtitle2,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, TopRatedView.route),
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
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                final state = provider.topRateState;
                if (state == NetworkState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == NetworkState.loaded) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.topRateMovies.length,
                      itemBuilder: (context, index) {
                        final item = provider.topRateMovies[index];
                        return MovieItem(data: item);
                      },
                    ),
                  );
                } else {
                  return Text('Failed : ${provider.message}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
