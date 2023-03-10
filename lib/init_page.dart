import 'package:bike_adventure/logo_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.to(() => const LogoPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.white,
          ),

        ],
      ),
    );
  }
}
