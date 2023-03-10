import 'dart:io';
import 'package:bike_adventure/constants/systems.dart';
import 'package:flutter/material.dart';

class CardPicture extends StatelessWidget {
  const CardPicture(
      {this.onCameraTap,
      this.onPhotoTap,
      this.onImageTap,
      this.onRemoveTap,
      this.imagePath,
      this.widthRate = 0,
      Key? key})
      : super(key: key);

  final Function()? onCameraTap;
  final Function()? onPhotoTap;
  final Function()? onImageTap;
  final Function()? onRemoveTap;
  final String? imagePath;
  final double widthRate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (imagePath != null) {
      return InkWell(
        onTap: onImageTap,
        child: Card(
          child: Container(
            // height: 220,
            padding: const EdgeInsets.all(10.0),
            width: size.width * ADD_QUEST_PICTURE_SIZE_RATE,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  fit: BoxFit.fitWidth, image: FileImage(File(imagePath as String))),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 35,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                          blurRadius: 2.0,
                        )
                      ]),
                  child: IconButton(
                      onPressed: onRemoveTap,
                      icon: const Icon(Icons.delete, color: Colors.white, size: 20,)),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Card(
        elevation: 5,
        child: InkWell(
          onTap: onImageTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
            width: size.width * widthRate,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: Text(
                //     '사진',
                //     style: TextStyle(fontSize: 17.0, color: Colors.grey[600]),
                //   ),
                // ),
                Column(
                  children: [
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.photo_camera_rounded,
                    //   ),
                    //   color: Colors.indigo[400],
                    //   onPressed: onCameraTap,
                    // ),

                    IconButton(
                      icon: const Icon(
                        Icons.insert_photo_rounded,
                      ),
                      color: Colors.indigo[400],
                      onPressed: onPhotoTap,
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.attach_file_rounded,
                      ),
                      color: Colors.indigo[400],
                      onPressed: onImageTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
