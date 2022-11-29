import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/ui/views/detail/components/detail_content_view.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_provider.dart';
import 'package:submission/ui/widgets/colored_status_bar.dart';

import 'components/recommended_tv_component.dart';

class TvDetailView extends StatefulWidget {
  static const route = '/tv/detail';
  const TvDetailView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<TvDetailView> createState() => _TvDetailViewState();
}

class _TvDetailViewState extends State<TvDetailView> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<TvDetailProvider>(context, listen: false)
          .loadTvDetail(widget.id);
      Provider.of<TvDetailProvider>(context, listen: false)
          .loadRecommendedTv(widget.id);
      Provider.of<TvDetailProvider>(context, listen: false)
          .loadWatchlistExistStatus(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredStatusBar(
      color: Colors.black,
      brightness: Brightness.light,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Consumer<TvDetailProvider>(
            builder: (context, provider, child) {
              if (provider.detailState == RequestState.success) {
                provider.hasAddedToWatchlist;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (provider.hasAddedToWatchlist == false) {
                        await provider.addWatchlist(provider.detailTv);
                      } else {
                        await provider.removeFromWatchlist(provider.detailTv);
                      }
                      if (mounted) {
                        _buildAlertSnackBar(context, provider.watchlistMessage);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          provider.hasAddedToWatchlist
                              ? Icons.check
                              : Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Watchlist',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Consumer<TvDetailProvider>(
              builder: (context, provider, child) {
                if (provider.detailState == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (provider.detailState == RequestState.success) {
                  final tv = provider.detailTv;
                  return SafeArea(
                    child: DetailContent(
                      key: const Key('detail_content'),
                      imageUrl: '${Constant.baseUrlImage}${tv.posterPath}',
                      title: tv.name.toString(),
                      status: tv.status.toString(),
                      overview: tv.overview.toString(),
                      genres: tv.genres ?? [],
                      voteAverage: tv.voteAverage ?? 0,
                      voteCount: tv.voteCount ?? 0,
                      recommendedView: const RecommendedTvComponent(),
                    ),
                  );
                } else {
                  return Text(
                    key: const Key('error_message'),
                    provider.message,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildAlertSnackBar(BuildContext context, String message) {
    if (message == 'Added to Watchlist' ||
        message == 'Removed from Watchlist') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
          );
        },
      );
    }
  }
}
