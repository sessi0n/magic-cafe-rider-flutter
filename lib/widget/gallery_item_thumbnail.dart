import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class GalleryItem {
  GalleryItem({
    required this.id,
    required this.resource,
    this.isSvg = false,
    this.isLocal = false,
  });

  final int id;
  final String resource;
  final bool isSvg;
  final bool isLocal;
  String heroId = '';
}

class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final GalleryItem item;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    if (item.heroId.isEmpty) {
      item.heroId = uuid.v4();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: item.heroId,
          // child: Image.asset(item.resource, height: 80.0),
          child: item.isLocal
              ? Transform.scale(
                  scale: 1.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(item.resource)),
                    )),
                  ))
              : Image.network(item.resource, height: 80.0),
        ),
      ),
    );
  }
}
