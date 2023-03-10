import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StampPage extends StatefulWidget {
  const StampPage({Key? key}) : super(key: key);

  @override
  State<StampPage> createState() => _StampPageState();
}

class _StampPageState extends State<StampPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Get.back();
            }),
        centerTitle: true,
        title: const Text(
          '스템프 페이지',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(child: Text('개발 중입니다'),),
    ));
  }
}
