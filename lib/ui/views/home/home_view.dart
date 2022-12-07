import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission/ui/views/home/components/now_playing_components.dart';
import 'package:submission/ui/views/search/search_view.dart';
import 'package:submission/ui/views/tv_home/tv_home_view.dart';

import '../watchlist/watchlist_view.dart';
import 'components/popular_components.dart';
import 'components/top_rated_components.dart';

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
              leading: const Icon(CupertinoIcons.tv),
              title: const Text('TV'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, TvHomeView.route),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              NowPlayingComponents(),
              SizedBox(height: 4),
              Divider(
                thickness: 1,
                height: 24,
              ),
              PopularComponents(),
              SizedBox(height: 4),
              Divider(
                thickness: 1,
                height: 24,
              ),
              TopRatedComponents(),
            ],
          ),
        ),
      ),
    );
  }
}
