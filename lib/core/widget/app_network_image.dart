import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppNetworkImage extends StatefulWidget {
  final String networkImage;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget? placeHolder;
  final Widget? errorBuilder;
  const AppNetworkImage(
      {super.key,
      required this.networkImage,
      this.width,
      this.height,
      this.fit,
      this.borderRadius,
      this.placeHolder,
      this.errorBuilder});

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  Key _imageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
          key: _imageKey,
          imageUrl: widget.networkImage,
          fit: widget.fit ?? BoxFit.cover,
          height: widget.height,
          width: widget.width,
          placeholder: (context, url) =>
              widget.placeHolder ?? _buildPlaceholder(),
          errorWidget: (context, url, error) =>
              widget.errorBuilder ?? _buildErrorWidget()),
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return ColoredBox(
      color: Colors.grey[300]!,
      child: Center(
        child: IconButton(
            onPressed: _retryLoading,
            icon: Icon(
              Icons.refresh_outlined,
              color: AppColors.white,
              size: 40.sp,
            )),
      ),
    );
  }

  void _retryLoading() {
    setState(() {
      _imageKey = UniqueKey();
    });
  }
}
