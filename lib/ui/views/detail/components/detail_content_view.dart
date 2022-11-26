import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/components/recommended_component.dart';
import 'package:submission/ui/widgets/content_wrapper.dart';
import 'package:submission/ui/widgets/sky_image.dart';

import '../../../../core/theme/app_style.dart';
import '../../../../domain/entities/genre.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_detail.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          SkyImage(
            url: '${Constant.baseUrlImage}${movie?.posterPath}',
            width: MediaQuery.of(context).size.width,
            height: 500,
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          const SizedBox(height: 12),
          ContentWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${movie?.title}',
                        style: AppStyle.subtitle2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '${movie?.status}',
                        style: AppStyle.body2.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _buildGenre(movie?.genres ?? []),
                  style: AppStyle.body2,
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.time, size: 18,),
                    const SizedBox(width: 4),
                    Text(
                      _buildDuration(movie?.runtime ?? 0),
                      style: AppStyle.body2,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: (movie?.voteAverage ?? 0) / 2,
                      itemCount: 5,
                      unratedColor: Colors.orange.withOpacity(0.3),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      itemSize: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${movie?.voteAverage?.toStringAsFixed(1)} / 10',
                      style: AppStyle.body1.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.orange),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${movie?.voteCount})',
                      style: AppStyle.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Overview',
                  style: AppStyle.subtitle4,
                ),
                const Divider(),
                Text(
                  '${movie?.overview}',
                  style: AppStyle.body2,
                ),
                const SizedBox(height: 16),
                const RecommendedComponent()
              ],
            ),
          ),
        ],
      ),
    );
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '${Constant.baseUrlImage}${movie?.posterPath}',
          width: MediaQuery.of(context).size.width,
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
                              _buildGenre(movie?.genres ?? []),
                            ),
                            Text(
                              _buildDuration(movie?.runtime ?? 0),
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
            initialChildSize: 0.5,
            minChildSize: 0.25,
            maxChildSize: 1.0,
          ),
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
    );
  }

  String _buildGenre(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _buildDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
