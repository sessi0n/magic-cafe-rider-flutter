import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgitMemberPage extends StatefulWidget {
  const AgitMemberPage({Key? key}) : super(key: key);

  @override
  State<AgitMemberPage> createState() => _AgitMemberPageState();
}

class _AgitMemberPageState extends State<AgitMemberPage> {
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
          '아지트 멤버 리스트',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(child: Text('개발 중입니다'),),
    ));
  }
}
