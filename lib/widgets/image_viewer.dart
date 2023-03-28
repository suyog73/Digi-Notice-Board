// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_full_image_screen/custom_full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/helpers/constants.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key? key,
    required this.urlDownload,
    this.width = 150,
    this.height = 150,
    required this.finalWidth,
    required this.finalHeight,
    required this.isAdmin,
  }) : super(key: key);

  final String urlDownload;
  final double width, height;
  final double finalHeight, finalWidth;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    Color mainColor = isAdmin ? kOrangeColor : kVioletShade;

    return ImageCachedFullscreen(
      imageUrl: urlDownload,
      imageBorderRadius: 300,
      imageWidth: width,
      imageHeight: height,
      imageDetailsHeight: finalHeight,
      imageDetailsWidth: finalWidth,
      // iconBackButtonColor: kGreenShadeColor,
      // hideBackButtonDetails: false,
      // backgroundColorDetails: ,
      imageDetailsFit: BoxFit.contain,
      // hideAppBarDetails: true,
      imageFit: BoxFit.cover,
      withHeroAnimation: false,
      placeholderDetails: CircularProgressIndicator(color: mainColor),
      placeholder: CircularProgressIndicator(color: mainColor),
      errorWidget: urlDownload == ''
          ? CircularProgressIndicator(color: mainColor)
          : Center(
              child: Text(
                'Image corrupted',
                style: TextStyle(color: Colors.red, fontSize: 32),
              ),
            ),
    );
  }
}

class ImageViewer1 extends StatelessWidget {
  const ImageViewer1({
    Key? key,
    required this.urlDownload,
    this.width = 150,
    this.height = 150,
    required this.finalWidth,
    required this.finalHeight,
    required this.isAdmin,
  }) : super(key: key);

  final String urlDownload;
  final double width, height;
  final double finalHeight, finalWidth;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    Color mainColor = isAdmin ? kOrangeColor : kVioletShade;

    return ImageCachedFullscreen(
      imageUrl: urlDownload,
      imageWidth: width,
      imageHeight: height,
      imageDetailsHeight: finalHeight,
      imageDetailsWidth: finalWidth,
      iconBackButtonColor: mainColor,
      imageDetailsFit: BoxFit.contain,
      imageFit: BoxFit.contain,
      withHeroAnimation: false,
      placeholderDetails:
          Center(child: CircularProgressIndicator(color: mainColor)),
      placeholder: Center(
        child: CircularProgressIndicator(color: mainColor),
      ),
      errorWidget: urlDownload == ''
          ? Center(child: CircularProgressIndicator(color: mainColor))
          : Center(
              child: Text(
                'Image corrupted',
                style: TextStyle(color: Colors.red, fontSize: 32),
              ),
            ),
    );
  }
}

class ImageViewer2 extends StatelessWidget {
  const ImageViewer2({
    Key? key,
    required this.width,
    required this.height,
    required this.imageUrl,
  }) : super(key: key);

  final double width, height;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) {
        return SizedBox(
          height: height,
          width: width,
          child: CircularProgressIndicator(
            color: mainColor(context),
            strokeWidth: 2,
          ),
        );
      },
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageBuilder: (context, image) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(300),
          child: Image(
            image: image,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
