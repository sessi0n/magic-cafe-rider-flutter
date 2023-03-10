import 'dart:io';

import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/models/agit.dart';
import 'package:bike_adventure/widget/qe_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddCafeOwner extends StatefulWidget {
  const AddCafeOwner({Key? key}) : super(key: key);

  @override
  State<AddCafeOwner> createState() => _AddCafeOwnerState();
}

class _AddCafeOwnerState extends State<AddCafeOwner> {
  final ProfileController profileController = Get.find<ProfileController>();
  final QuestController questController = Get.find<QuestController>();

  var cafe = 0;
  List<Agit> cafeList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cafeList =
      await questController.getAgitList(profileController.profile!.uid);

      setState(() {
        cafeList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

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
            'Add Cafe Owner',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 12),
              child: Text(
                '카페 설정',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 30),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Center(
                  child: PopupMenuButton(
                    child: Text(cafe == 0 ? '카페 선택' : getCafeName(cafe),
                        style: const TextStyle(fontSize: 12)),
                    onSelected: (result) {
                      setState(() {
                        setState(() {
                          cafe = (result as Agit).qid;
                        });
                      });
                    },
                    itemBuilder: (_) =>
                        cafeList
                            .map((e) => PopupMenuItem(
                            value: e,
                            child: Text(
                              e.name,
                              style: const TextStyle(fontSize: 12),
                            )))
                            .toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: QRScanner(onScanQR: onScanQR,)),
            ),
          ],
        ));
  }

  getCafeName(int id) {
    for (Agit cafe in cafeList) {
      if (cafe.qid == id) {
        return cafe.name;
      }
    }

    return '선택한 카페가 없습니다';
  }

  Future<bool> onScanQR(String? code) async {
    if (cafe == 0) {
      return false;
    }

    if (code == null || code.isEmpty) {
      return false;
    }


    bool isSuccess = await profileController.setCafeOwner(code, cafe);
    if (isSuccess) {
      Get.back();
    }
    return isSuccess;
  }
}
