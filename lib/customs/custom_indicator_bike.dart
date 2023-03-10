import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomIndicatorBike extends StatefulWidget {
  const CustomIndicatorBike({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  _CustomIndicatorBikeState createState() => _CustomIndicatorBikeState();
}

class _CustomIndicatorBikeState extends State<CustomIndicatorBike> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      constraints: BoxConstraints.tight(Size.square(widget.size)),
      child: Lottie.asset('assets/lottie/97383-yellow-delivery-guy.zip'),
    ));
  }

// Widget changeImages(count) {
//   switch(count) {
//     case 0: AssetImage(images[imageCount % 4]),
//   }
// }
}
