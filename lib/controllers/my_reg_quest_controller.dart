
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRegQuestController extends GetxController {
  static MyRegQuestController get to => Get.find();
  final ProfileController _profileController = Get.find<ProfileController>();

  RxList questList = <Quest>[].obs;
  var scrollController = ScrollController().obs;
  var isLoading = false.obs;
  var hasMore = false.obs;

  // @override
  // void onInit() {
  //   scrollController.value.addListener(() {
  //     if (scrollController.value.position.pixels ==
  //         scrollController.value.position.maxScrollExtent &&
  //         hasMore.value) {
  //       getData();
  //     }
  //   });
  //   super.onInit();
  // }

  getQuestData() async {
    isLoading.value = true;

    questList.clear();
    await _profileController.getQuestData('REGISTER', questList);

    if (kDebugMode) {
      print('QuestController length: ${questList.length}');
    }
    isLoading.value = false;
  }

  reload() async {
    isLoading.value = true;
    questList.clear();
    await Future.delayed(Duration(seconds: 2));
    getQuestData();
  }

}
