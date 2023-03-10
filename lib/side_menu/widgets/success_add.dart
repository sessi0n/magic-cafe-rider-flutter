import 'dart:async';

import 'package:bike_adventure/main_page.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessAdd extends StatefulWidget {
  const SuccessAdd({Key? key,required this.text,required this.assetPath}) : super(key: key);
  final String text;
  final String assetPath;

  @override
  State<SuccessAdd> createState() => _SuccessAddState();
}

class _SuccessAddState extends State<SuccessAdd> {
  late FlipCardController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();

    _timer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      _controller.toggleCard();
    });

    Future.delayed(const Duration(seconds: 2), () {
      // Get.back(result: {'result': true});
      Get.offAll(()=>const MainPage());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints.tight(const Size.square(100)),
              child: FlipCard(
                  // speed: 500,
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
                        color: Colors.orangeAccent,
                        image: AssetImage(
                          widget.assetPath,
                        ),
                      ),
                    ),
                  ),
                  back: Card(
                    child: Image(
                      color: Colors.orangeAccent,
                      image: AssetImage(
                        widget.assetPath,
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 20,),
            Text('${widget.text} 가 성공적으로 등록됐습니다!'),
          ],
        ),
      ),
    );
  }
}
