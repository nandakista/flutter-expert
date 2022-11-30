import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission/ui/views/home/home_view.dart';
import 'package:submission/ui/views/tv_home/components/tv_on_air_components.dart';
import 'package:submission/ui/views/tv_home/components/tv_popular_components.dart';
import 'package:submission/ui/views/tv_home/components/tv_top_rated_components.dart';
import 'package:submission/ui/views/tv_search/tv_search_view.dart';

import '../watchlist/watchlist_view.dart';

class TvHomeView extends StatelessWidget {
  static const route = '/tv/home';

  const TvHomeView({Key? key}) : super(key: key);

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
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomeView.route),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.tv),
              title: const Text('TV'),
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
        title: const Text('Sky TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TvSearchView.route);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TvOnAirComponents(),
              SizedBox(height: 4),
              Divider(
                thickness: 1,
                height: 24,
              ),
              TvPopularComponents(),
              SizedBox(height: 4),
              Divider(
                thickness: 1,
                height: 24,
              ),
              TvTopRatedComponents(),
            ],
          ),
        ),
      ),
    );
  }
}
