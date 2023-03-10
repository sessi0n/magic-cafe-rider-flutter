import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MyAcceptQuestController extends GetxController {

  static MyAcceptQuestController get to => Get.find();
  final ProfileController _profileController = Get.find<ProfileController>();

  RxList questList = <Quest>[].obs;
  // var scrollController = ScrollController().obs;
  var isLoading = true.obs;
  var hasMore = false.obs;

  getData() async {
    // isLoading.value = true; //첫 페이지 그릴때 변경하면 오류남.

    questList.clear();
    await _profileController.getQuestData('ACCEPTED', questList);

    if (kDebugMode) {
      print('QuestController length: ${questList.length}');
    }
    isLoading.value = false;
  }

  // reload() async {
  //   isLoading.value = true;
  //   questList.clear();
  //   await Future.delayed(Duration(seconds: 2));
  //   getData();
  //   update();
  // }

}
