import 'dart:convert';

import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/sale_controller.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriterSaleController extends GetxController {
  static WriterSaleController get to => Get.find();
  final ProfileController profileController = Get.find<ProfileController>();
  final SaleController saleController = Get.find<SaleController>();

  var titleEditingController = TextEditingController();
  var urlEditingController = TextEditingController();
  // var startEditingController = TextEditingController();
  // var endEditingController = TextEditingController();
  bool isWriteStart = false;
  bool isWriteEnd = false;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();


  @override
  void dispose() {
    titleEditingController.dispose();
    urlEditingController.dispose();
    super.dispose();
  }

  clear() {
    urlEditingController.clear();
    titleEditingController.clear();
  }

  insertSale() async {
    var sendObj = {
      'sale': {
        'sid': 0,
        'uid': profileController.profile!.uid,
        'title': titleEditingController.text,
        'url': urlEditingController.text,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'created': DateTime.now().toIso8601String(),
        'deleted': false,
      }
    };


    return await saleController.insertSale(sendObj);

    // await _npcController.getSearchNpcData(isInit: true);

    // return ret;
  }

  isValid() {
    if (urlEditingController.text.isEmpty) {
      print('empty urlEditingController.text');
      return false;
    }

    if (titleEditingController.text.isEmpty) {
      print('empty titleEditingController.text');
      return false;
    }
    if (!isWriteStart || !isWriteEnd) {
      print('isWriteStart isWriteEnd not set');
      return false;
    }

    start = DateTime(start.year, start.month, start.day, 0, 0, 0, 0, 0);
    end = DateTime(end.year, end.month, end.day, 23, 59, 59, 0, 0);

    if (start.isAfter(end)) {
      print('setEnd isAfter setStart $start $end');
      return false;
    }

    return true;
  }
}
