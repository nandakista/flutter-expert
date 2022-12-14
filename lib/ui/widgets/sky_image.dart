import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SkyImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final VoidCallback? onTapImage;
  final VoidCallback? onRemoveImage;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  const SkyImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.onTapImage,
    this.onRemoveImage,
    this.borderRadius,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFromRemote = url.startsWith('http');

    return Stack(
      children: [
        isFromRemote
            ? ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(0),
                child: CachedNetworkImage(
                  height: height,
                  width: width,
                  imageUrl: url,
                  fit: fit,
                  placeholder: (context, url) => SizedBox(
                    height: height,
                    width: width,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    height: height,
                    width: width,
                    child: const Icon(
                      Icons.error,
                    ),
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(0),
                child: Image.asset(
                  url,
                  width: width,
                  height: height,
                  fit: fit,
                ),
              ),
        onRemoveImage != null
            ? Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onRemoveImage,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
