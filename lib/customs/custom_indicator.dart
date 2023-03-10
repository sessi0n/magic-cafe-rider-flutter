import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class CustomIndicator extends StatefulWidget {
  const CustomIndicator({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  _CustomIndicatorState createState() => _CustomIndicatorState();
}

class _CustomIndicatorState extends State<CustomIndicator> {
  int frontCount = 0;
  int backCount = 0;

  List<String> frontImages = [
    'assets/icons/quest3.png',
    'assets/icons/box4.png',
  ];
  List<String> backImages = [
    'assets/icons/map.png',
    'assets/icons/equip.png',
  ];
  late Timer _timer;
  bool isUnder = false;

  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();

    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      _controller.toggleCard();
      setState(() {
        if (isUnder) {
          frontCount++;
        } else {
          backCount++;
        }
        isUnder = !isUnder;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      constraints: BoxConstraints.tight(Size.square(widget.size)),
      child: FlipCard(
        speed: 400,
          fill: Fill.fillBack,
          // Fill the back side of the card to make in the same size as the front.
          direction: FlipDirection.HORIZONTAL,
          // default
          // key: cardKey,
          controller: _controller,
          flipOnTouch: false,
          front: Card(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image(
                image: AssetImage(
                  frontImages[frontCount % frontImages.length],
                ),
              ),
            ),
          ),
          back: Card(
            child: Image(
              image: AssetImage(
                backImages[backCount % backImages.length],
              ),
            ),
          )),
    ));
  }

// Widget changeImages(count) {
//   switch(count) {
//     case 0: AssetImage(images[imageCount % 4]),
//   }
// }
}
