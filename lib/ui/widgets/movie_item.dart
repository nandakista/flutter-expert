import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:submission/core/theme/app_style.dart';
import 'package:submission/ui/views/detail/detail_view.dart';
import 'package:submission/ui/widgets/sky_box.dart';
import 'package:submission/ui/widgets/sky_image.dart';

import '../../core/constant/constant.dart';
import '../../domain/entities/movie.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({Key? key, required this.data}) : super(key: key);

  final Movie data;

  @override
  Widget build(BuildContext context) {
    return SkyBox(
      margin: const EdgeInsets.symmetric(vertical: 4),
      onPressed: () {
        Navigator.pushNamed(
          context,
          DetailView.route,
          arguments: data.id,
        );
      },
      child: Row(
        children: [
          SkyImage(
            url: '${Constant.baseUrlImage}${data.posterPath}',
            width: 80,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? '-',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.subtitle3,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: (data.voteAverage ?? 0) / 2,
                      itemCount: 5,
                      unratedColor: Colors.orange.withOpacity(0.3),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      itemSize: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${data.voteAverage?.toStringAsFixed(1)} / 10',
                      style: AppStyle.body3.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.orange),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.overview ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
