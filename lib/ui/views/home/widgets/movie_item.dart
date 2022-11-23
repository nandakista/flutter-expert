import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:submission/core/constant/constant.dart';
import 'package:submission/ui/views/detail/detail_view.dart';

import '../../../../domain/entities/movie.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({Key? key, required this.data}) : super(key: key);

  final Movie data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, DetailView.route, arguments: data.id);
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: '${Constant.baseUrlImage}${data.posterPath}',
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
