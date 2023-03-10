import 'dart:io';

import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/models/agit.dart';
import 'package:bike_adventure/widget/qe_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddFriendQr extends StatefulWidget {
  const AddFriendQr({Key? key, required this.onScanQR}) : super(key: key);
  final Future<bool> Function(String? code) onScanQR;

  @override
  State<AddFriendQr> createState() => _AddFriendQrState();
}

class _AddFriendQrState extends State<AddFriendQr> {
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
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
            '동행 추가 QR',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: QRScanner(onScanQR: widget.onScanQR,)));
  }
}
