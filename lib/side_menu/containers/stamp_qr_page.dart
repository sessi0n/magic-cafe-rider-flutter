import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StampQRPage extends StatelessWidget {
  const StampQRPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
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
            'QR',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child:             QrImage(
                data: profileController.profile!.uid,
                version: QrVersions.auto,
                size: 220,
                gapless: false,
              ),

            ),
            SizedBox(height: 20,),
            Text('${profileController.profile!.uid}')
          ],
        ));
  }
}
