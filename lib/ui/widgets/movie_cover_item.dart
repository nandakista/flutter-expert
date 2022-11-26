import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/detail_view.dart';

import '../../domain/entities/movie.dart';

class MovieCoverItem extends StatelessWidget {
  const MovieCoverItem({Key? key, required this.data, this.height})
      : super(key: key);

  final Movie data;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, DetailView.route, arguments: data.id);
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: CachedNetworkImage(
            imageUrl: '${Constant.baseUrlImage}${data.posterPath}',
            fit: BoxFit.fill,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
