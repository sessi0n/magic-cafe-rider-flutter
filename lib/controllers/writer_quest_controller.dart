import 'dart:convert';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/constants/area_num.dart';
import 'package:bike_adventure/constants/error_type.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/models/my_quest.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriterQuestController extends GetxController {
  static WriterQuestController get to => Get.find();
  final ProfileController _profileController = Get.find<ProfileController>();
  final QuestController _questController = Get.find<QuestController>();

  final RxBool isCompletedOpenMap = RxBool(false);
  final RxBool isCompletedOpenPicture = RxBool(false);
  final RxBool isCompletedOpenInfo = RxBool(false);

  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var addressName = ''.obs;

  // var countPicture = 0.obs;
  var uploadPictures = <GalleryItem>[].obs;
  var mainPicture = ''.obs;

  var addressEditingController = TextEditingController();
  var nameEditingController = TextEditingController();
  var youtubeEditingController = TextEditingController();

  eQuestType questType = eQuestType.CAFE;
  eParkingSize parkingSize = eParkingSize.parking;

  @override
  void onInit() {
    nameEditingController.addListener(() {
      if (nameEditingController.text.isNotEmpty) {
        isCompletedOpenInfo.value = true;
      } else {
        isCompletedOpenInfo.value = false;
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    youtubeEditingController.dispose();
    addressEditingController.dispose();
    super.dispose();
  }

  completedOpenMapState(lat, lng, addressName) {
    this.lat.value = lat;
    this.lng.value = lng;
    this.addressName.value = addressName;

    isCompletedOpenMap.value = true;
    update();
  }

  completedOpenPicture(GalleryItem? mainItem) {
    if (uploadPictures.isEmpty) {
      isCompletedOpenPicture.value = false;
      mainPicture.value = '';
    } else {
      isCompletedOpenPicture.value = true;
      if (mainItem != null) {
        mainPicture.value = mainItem.resource;
      }
    }

    update();
  }

  completedOpenMultiPicture() {
    if (uploadPictures.isEmpty) {
      isCompletedOpenPicture.value = false;
      mainPicture.value = '';
    } else {
      isCompletedOpenPicture.value = true;
      mainPicture.value = uploadPictures[0].resource;
    }

    update();
  }

  clear() {
    isCompletedOpenMap.value = false;
    isCompletedOpenPicture.value = false;
    isCompletedOpenInfo.value = false;
    mainPicture.value = '';

    uploadPictures.clear();
    nameEditingController.clear();
    youtubeEditingController.clear();

    questType = eQuestType.CAFE;

    update();
  }

  completedOpenInfo() {
    isCompletedOpenInfo.value = true;
    update();
  }

  addUploadPicture(path) {
    uploadPictures.add(path);
    update();
  }

  setMainPicture(index) {
    if (index < uploadPictures.length) {
      mainPicture.value = uploadPictures[index].resource;
    }
  }

  int isValidAddQuest() {
    if (isCompletedOpenMap.isFalse) {
      return ERR_NOT_SET_LOCATION;
    }
    if (isCompletedOpenPicture.isFalse) {
      return ERR_NOT_SET_PICTURE;
    }
    if (isCompletedOpenInfo.isFalse) {
      return ERR_NOT_SET_NAME;
    }
    if (youtubeEditingController.text.isNotEmpty) {
      if (!getUrlValid(youtubeEditingController.text)) {
        return ERR_NOT_VALID_YOUTUBE;
      }
    }

    return 0;
  }

  insertQuest() async {
    var areaCode = _profileController.getAreaCode(addressName.value);
    // var cityCode = _profileController.getCityCode(areaCode, addressName.value);
    var sendObj = {
      'quest': json.encode({
        'qid': 0,
        'uid': _profileController.profile!.uid,
        'name': nameEditingController.text,
        'location': addressName.value,
        'area': areaCode,
        'city': 0,
        'type': questType.name,
        'lat': lat.value,
        'lng': lng.value,
        // 'acceptCount': 0,
        // 'completeCount': 0,
        // 'level': 0,
        'youtubeUrl': youtubeEditingController.text,
        // 'deleted': false,
        // 'thumbId' : '',
      })
    };

    var ret = false;
    ApiRequest request = ApiRequest(url: '/quest/add', body: sendObj);

    print(uploadPictures.length);
    var data = await request
        .uploadFormData(uploadPictures.map((e) => e.resource).toList());

    if (data != null) {
      _profileController.regQuestList.clear();
      for (var e in data['userRegisterQuests'] as List) {
        _profileController.regQuestList.add(MyQuest.fromJson(e));
      }
      ret = true;
    }

    await _questController.getSearchQuestData(type: SearchType.NONE, isInit: true);

    return ret;
  }

  modifyQuest(Quest quest, List<GalleryItem> deletedIds) async {
    var areaCode = _profileController.getAreaCode(addressName.value);
    // var cityCode = _profileController.getCityCode(areaCode, addressName.value);
    quest.name = nameEditingController.text;
    quest.location = addressName.value;
    quest.area = areaCode;
    quest.city = 0;
    quest.lat = lat.value;
    quest.lng = lng.value;
    quest.type = questType;
    quest.youtubeUrl = youtubeEditingController.text;

    Quest ret = quest;

    var data;
    if (uploadPictures.isNotEmpty) {

      var sendObj = {
        'delImages' : json.encode(deletedIds.map((e)=>e.id).toList()),
        'quest': json.encode(quest.toJson())
      };
      debugPrint('modifyQuest:$sendObj');

      ApiRequest request = ApiRequest(url: '/quest/modify/with_picture', body: sendObj);

      debugPrint('length ${uploadPictures.length}');
      data = await request
          .uploadFormData(uploadPictures.where((e) {
        return e.isLocal == true;
      }).map((e) => e.resource).toList());

        debugPrint('Response data: $data');
    }
    else {
      var sendObj = {
        'delImages' : deletedIds.map((e)=>e.id).toList(),
        'quest': quest.toJson()
      };
      debugPrint('modifyQuest:$sendObj');

      ApiRequest request = ApiRequest(url: '/quest/modify/no_picture', body: sendObj);

      await request.post().then((value) {
        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');
        if (value.statusCode == 200) {
          data  = json.decode(value.body);
        }
      }).catchError((onError) {
        print(onError);
      });
    }

    if (data != null) { //data['questInfo']
      ret = _questController.modifyQuest(data['questInfo']);
    }

    // await _questController.getSearchQuestData(type: SearchType.NONE, isInit: true);

    return ret;
  }


}
