import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:submission/ui/widgets/colored_status_bar.dart';

import '../../../core/constant/network_state.dart';
import 'components/detail_content_view.dart';
import 'components/recommended_component.dart';

class DetailView extends StatefulWidget {
  static const route = '/detail';
  const DetailView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<DetailProvider>(context, listen: false)
          .loadMovieDetail(widget.id);
      Provider.of<DetailProvider>(context, listen: false)
          .loadRecommendedMovie(widget.id);
      Provider.of<DetailProvider>(context, listen: false)
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
          child: Consumer<DetailProvider>(builder: (context, provider, child) {
            if (provider.detailState == RequestState.success) {
              provider.hasAddedToWatchlist;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (provider.hasAddedToWatchlist == false) {
                      await provider.addWatchlist(provider.detailMovie);
                    } else {
                      await provider.removeFromWatchlist(provider.detailMovie);
                    }
                    if (mounted) {
                      _buildAlertSnackBar(context, provider.watchlistMessage);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        provider.hasAddedToWatchlist ? Icons.check : Icons.add,
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
          }),
        ),
        body: Stack(
          children: [
            Consumer<DetailProvider>(
              builder: (context, provider, child) {
                if (provider.detailState == RequestState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (provider.detailState == RequestState.success) {
                  final movie = provider.detailMovie;
                  return SafeArea(
                    child: DetailContent(
                      key: const Key('detail_content'),
                      imageUrl: '${Constant.baseUrlImage}${movie.posterPath}',
                      title: movie.title.toString(),
                      status: movie.status.toString(),
                      overview: movie.overview.toString(),
                      runtime: movie.runtime ?? 0,
                      genres: movie.genres ?? [],
                      voteAverage: movie.voteAverage ?? 0,
                      voteCount: movie.voteCount ?? 0,
                      recommendedView: const RecommendedComponent(),
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
