import 'dart:io';

import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    Key? key,
    this.mainContext,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
    this.onTabDelete,
    required this.needDeleteButton,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final dynamic mainContext;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItem> galleryItems;
  final Axis scrollDirection;
  final Function(GalleryItem item)? onTabDelete;
  final bool needDeleteButton;

  @override
  State<GalleryPhotoViewWrapper> createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  //
  // void onPageChanged(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      persistentFooterButtons: [
        widget.needDeleteButton
            ? TextButton.icon(
                label: const Text('삭제',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
                onPressed: () {
                  if (currentIndex == 0) {
                    pushSnackbar('사진 수정', '썸네일에 사용한 사진은 지우지 못 합니다');
                    return;
                  }
                  if (widget.onTabDelete != null) {
                    widget.onTabDelete!(widget.galleryItems[currentIndex]);
                    Get.back();
                  }
                },
                icon: const Icon(
                  Icons.delete, color: Colors.red,
                  // color: Colors.cyan[700],
                ))
            : const SizedBox(width: 0),
        widget.needDeleteButton
            ? const SizedBox(width: 20)
            : const SizedBox(width: 0),
        TextButton.icon(
            label: const Text('돌아가기',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900)),
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.cancel_rounded, color: Colors.white,
              // color: Colors.cyan[700],
            )),
      ],
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: _buildItem,
          itemCount: widget.galleryItems.length,
          loadingBuilder: widget.loadingBuilder,
          backgroundDecoration: widget.backgroundDecoration,
          pageController: widget.pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          scrollDirection: widget.scrollDirection,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: SvgPicture.asset(
                item.resource,
                height: 200.0,
              ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.heroId),
          )
        : PhotoViewGalleryPageOptions(
            imageProvider: item.isLocal
                ? FileImage(File(item.resource)) as ImageProvider
                : NetworkImage(item.resource),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.heroId),
          );
  }
}
