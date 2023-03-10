import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DetailPhotoViewer extends StatelessWidget {
  const DetailPhotoViewer({Key? key, required this.pictures, this.index = 0, this.onPageChanged}) : super(key: key);
  final List<String> pictures;
  final int index;
  final onPageChanged;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: index);

    return PhotoViewGallery.builder(
        // key: _scaffoldKey,
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(pictures[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: index),
          );
        },
        itemCount: pictures.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        // backgroundDecoration: widget.backgroundDecoration,
        pageController: _pageController,
        onPageChanged: onPageChanged,

    );

  }
}
