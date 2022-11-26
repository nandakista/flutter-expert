import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:submission/ui/widgets/colored_status_bar.dart';

import '../../../core/constant/network_state.dart';
import 'components/detail_content_view.dart';

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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredStatusBar(
      color: Colors.black,
      brightness: Brightness.light,
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<DetailProvider>(
              builder: (context, provider, child) {
                if (provider.detailState == NetworkState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (provider.detailState == NetworkState.loaded) {
                  return SafeArea(
                    child: DetailContent(
                      key: const Key('detail_content'),
                      movie: provider.detailMovie,
                      recommendations: provider.recommendedMovies,
                      // isAddedWatchlist: provider.isAddedToWatchlist,,
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
}
