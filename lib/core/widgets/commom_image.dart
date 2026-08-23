import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import '../utils/app_image.dart';
import '../utils/app_urls.dart';

enum ImageType { png, svg, network, file }

class CommonImage extends StatelessWidget {
  final String imageSrc;
  final String defaultImage;
  final Color? imageColor;
  final double height;
  final double width;
  final double borderRadius;
  final double? size;
  final ImageType imageType;
  final BoxFit fill;
  BorderRadius? borderRadiusLogic;

  CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height = 24,
    this.borderRadius = 0,
    this.width = 24,
    this.size,
    this.imageType = ImageType.svg,
    this.fill = BoxFit.fill,
    this.defaultImage = AppImage.noImage,
    this.borderRadiusLogic,
    super.key,
  });

  late Widget imageWidget;

  @override
  Widget build(BuildContext context) {
    borderRadiusLogic ??= BorderRadius.circular(borderRadius.r);
    if (imageType == ImageType.svg) {
      imageWidget = SvgPicture.asset(
        imageSrc,
        // ignore: deprecated_member_use
        color: imageColor,
        height: size?.sp ?? height.h,
        width: size?.sp ?? width.w,
        fit: fill,
      );
    }

    if (imageType == ImageType.png) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imageSrc,
          color: imageColor,
          height: size?.sp ?? height.h,
          width: size?.sp ?? width.w,
          fit: fill,
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode) {
              print("imageError : $error");
            }
            return Image.asset(defaultImage);
          },
        ),
      );
    }

    if (imageType == ImageType.file) {
      final file = File(imageSrc.toString());

      imageWidget = file.existsSync()
          ? ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          file,
          color: imageColor,
          height: size?.sp ?? height.h,
          width: size?.sp ?? width.w,
          fit: fill,
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode) {
              print("Image Load Error: $error");
            }
            return Image.asset(defaultImage);
          },
        ),
      )
          : Image.asset(defaultImage);
    }

    if (imageType == ImageType.network) {
      String resolvedUrl = imageSrc.trim();
      if (resolvedUrl.startsWith("http://51.21.66.176:8899/http://") ||
          resolvedUrl.startsWith("http://51.21.66.176:8899/https://")) {
        resolvedUrl = resolvedUrl.replaceFirst("http://51.21.66.176:8899/", "");
      } else if (!resolvedUrl.startsWith("http://") && !resolvedUrl.startsWith("https://")) {
        resolvedUrl = AppUrl.getFullUrl(resolvedUrl);
      }

      if (resolvedUrl.isEmpty ||
          resolvedUrl.toLowerCase().endsWith("/null") ||
          resolvedUrl.toLowerCase().endsWith("null") ||
          !resolvedUrl.startsWith("http")) {
        imageWidget = Image.asset(defaultImage, fit: fill);
      } else {
        imageWidget = CachedNetworkImage(
          height: size?.sp ?? height.h,
          width: size?.sp ?? width.w,
          imageUrl: resolvedUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: borderRadiusLogic,
              image: DecorationImage(image: imageProvider, fit: fill),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                color: AppColor.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            if (kDebugMode) {
              print("CachedNetworkImage Error: $error, url: $url");
            }
            return Image.asset(defaultImage, fit: fill);
          },
        );
      }
    }

    return SizedBox(
      height: size?.sp ?? height.h,
      width: size?.sp ?? width.w,
      child: imageWidget,
    );
  }
}
