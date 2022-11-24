import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/components/recommended_component.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';

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
    return Scaffold(
      body: Consumer<DetailProvider>(
        builder: (context, provider, child) {
          if (provider.detailState == NetworkState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.detailState == NetworkState.loaded) {
            final movie = provider.detailMovie;
            return SafeArea(
              child: DetailContent(
                key: const Key('detail_content'),
                movie: movie,
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
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail? movie;
  final List<Movie>? recommendations;
  final bool? isAddedWatchlist;

  const DetailContent({
    super.key,
    this.movie,
    this.recommendations,
    this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie?.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${movie?.title}',
                              style: AppStyle.subtitle3,
                            ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     if (!isAddedWatchlist) {
                            //       await Provider.of<DetailProvider>(
                            //           context,
                            //           listen: false)
                            //           .addWatchlist(movie);
                            //     } else {
                            //       await Provider.of<DetailProvider>(
                            //           context,
                            //           listen: false)
                            //           .removeFromWatchlist(movie);
                            //     }
                            //
                            //     final message =
                            //         Provider.of<DetailProvider>(context,
                            //             listen: false)
                            //             .watchlistMessage;
                            //
                            //     if (message ==
                            //         DetailProvider
                            //             .watchlistAddSuccessMessage ||
                            //         message ==
                            //             DetailProvider
                            //                 .watchlistRemoveSuccessMessage) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(content: Text(message)));
                            //     } else {
                            //       showDialog(
                            //           context: context,
                            //           builder: (context) {
                            //             return AlertDialog(
                            //               content: Text(message),
                            //             );
                            //           });
                            //     }
                            //   },
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       isAddedWatchlist
                            //           ? Icon(Icons.check)
                            //           : Icon(Icons.add),
                            //       Text('Watchlist'),
                            //     ],
                            //   ),
                            // ),
                            Text(
                              _showGenres(movie?.genres ?? []),
                            ),
                            Text(
                              _showDuration(movie?.runtime ?? 0),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie?.voteAverage ?? 0 / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie?.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: AppStyle.subtitle4,
                            ),
                            Text(
                              '${movie?.overview}',
                            ),
                            const SizedBox(height: 16),
                            const RecommendedComponent()
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.black,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            // backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
