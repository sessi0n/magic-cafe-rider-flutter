import 'dart:convert';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/constants/error_type.dart';
import 'package:bike_adventure/controllers/npc_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/my_npc.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriterNpcController extends GetxController {
  static WriterNpcController get to => Get.find();
  final ProfileController _profileController = Get.find<ProfileController>();
  final NpcController _npcController = Get.find<NpcController>();

  final RxBool isCompletedOpenMap = RxBool(false);
  final RxBool isCompletedOpenPicture = RxBool(false);
  final RxBool isCompletedOpenInfo = RxBool(false);

  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var addressName = ''.obs;

  // var countPicture = 0.obs;
  var uploadPictures = <GalleryItem>[].obs;
  var mainPicutre = ''.obs;

  var nameEditingController = TextEditingController();
  var youtubeEditingController = TextEditingController();
  var storeUrlEditingController = TextEditingController();

  eNpcType npcType = eNpcType.STORE;
  // eParkingSize parkingSize = eParkingSize.parking;

  @override
  void onInit() {
    nameEditingController.addListener(() {
      if (nameEditingController.text.isNotEmpty) {
        isCompletedOpenInfo.value = true;
      }
      else {
        isCompletedOpenInfo.value = false;
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    youtubeEditingController.dispose();
    storeUrlEditingController.dispose();
    super.dispose();
  }

  clear() {
    isCompletedOpenMap.value = false;
    isCompletedOpenPicture.value = false;
    isCompletedOpenInfo.value = false;
    mainPicutre.value = '';
    uploadPictures.clear();
    nameEditingController.clear();
    youtubeEditingController.clear();
    storeUrlEditingController.clear();
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
      mainPicutre.value = '';
    }
    else {
      isCompletedOpenPicture.value = true;
      if (mainItem != null) {
        mainPicutre.value = mainItem.resource;
      }
    }

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
      mainPicutre.value = uploadPictures[index].resource;
    }
  }

  int isValidAddNpc() {
    if (isCompletedOpenMap.isFalse && npcType != eNpcType.WEBSTORE) {
      return ERR_NOT_SET_LOCATION;
    }
    if (isCompletedOpenPicture.isFalse) {
      return ERR_NOT_SET_PICTURE;
    }
    if (isCompletedOpenInfo.isFalse) {
      return ERR_NOT_SET_NAME;
    }
    if (npcType == eNpcType.WEBSTORE) {
      if (storeUrlEditingController.text.isEmpty) {
        return ERR_NOT_SET_WEB_STORE;
      }
      if (!getUrlValid(storeUrlEditingController.text)) {
        return ERR_NOT_VALID_WEB_STORE;
      }
    }

    if (youtubeEditingController.text.isNotEmpty) {
      if (!getUrlValid(youtubeEditingController.text)) {
        return ERR_NOT_VALID_YOUTUBE;
      }
    }

    return 0;
  }

  insertNpc() async {
    int areaCode = npcType == eNpcType.WEBSTORE ? 0 : _profileController.getAreaCode(addressName.value);
    // int cityCode = _profileController.getCityCode(areaCode, addressName.value);
    var sendObj = {
      'npc': json.encode({
        'nid': 0,
        'uid': _profileController.profile!.uid,
        'name': nameEditingController.text,
        'location': addressName.value,
        'area': areaCode,
        'city': 0,
        'type': npcType.name,
        'lat': lat.value,
        'lng': lng.value,
        'youtubeUrl': youtubeEditingController.text,
        'webUrl' : storeUrlEditingController.text,
        'deleted': false,
      })
    };

    var ret = false;
    ApiRequest request = ApiRequest(url: '/npc/add', body: sendObj);

    var data = await request
        .uploadFormData(uploadPictures.map((e) => e.resource).toList());

    if (data != null) {
      _profileController.regNpcList.clear();
      for (var e in data['userRegisterNpcs'] as List) {
        _profileController.regNpcList.add(MyNpc.fromJson(e));
      }
      ret = true;
    }

    await _npcController.getSearchNpcData(isInit: true);

    return ret;
  }

  modifyNpc(Npc npc, List<GalleryItem> deletedIds) async {
    var areaCode = _profileController.getAreaCode(addressName.value);

    npc.name = nameEditingController.text;
    npc.location = addressName.value;
    npc.area = areaCode;
    npc.city = 0;
    npc.lat = lat.value;
    npc.lng = lng.value;
    npc.type = npcType;
    npc.youtubeUrl = youtubeEditingController.text;

    Npc ret = npc;

    var data;
    if (uploadPictures.isNotEmpty) {

      var sendObj = {
        'delImages' : json.encode(deletedIds.map((e)=>e.id).toList()),
        'npc': json.encode(npc.toJson())
      };
      debugPrint('modifyQuest:$sendObj');

      ApiRequest request = ApiRequest(url: '/npc/modify/with_picture', body: sendObj);

      debugPrint('length: ${uploadPictures.length}');
      data = await request
          .uploadFormData(uploadPictures.where((e) {
        return e.isLocal == true;
      }).map((e) => e.resource).toList());


      debugPrint('Response data: $data');
    }
    else {
      var sendObj = {
        'delImages' : deletedIds.map((e)=>e.id).toList(),
        'npc': npc.toJson()
      };
      debugPrint('modifyQuest:$sendObj');

      ApiRequest request = ApiRequest(url: '/npc/modify/no_picture', body: sendObj);

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

    ret = _npcController.parseNpcInfo(data['npcInfo']) ?? npc;

    return ret;
  }
}
