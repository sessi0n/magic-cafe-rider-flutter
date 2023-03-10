import 'package:flutter/material.dart';

class DetailPagePictureViewerModal extends StatelessWidget {
  const DetailPagePictureViewerModal({Key? key,required this.pictures,required this.index}) : super(key: key);
  final List<String> pictures;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // width: 200,
        // height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(pictures[index]),
                fit: BoxFit.fitWidth
            )
        ),
      ),
    );
  }
}
