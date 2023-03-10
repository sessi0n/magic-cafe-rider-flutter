import 'dart:convert';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NpcSearchType {
  NONE,
  NAME,
  AREA,
  JOB,
}

enum eTabType {
  WITH_BIKE,
  NON_BIKE,
}

class NpcController extends GetxController {
  static NpcController get to => Get.find();

  RxList npcList = <Npc>[].obs;
  var scrollController = ScrollController().obs;
  var isLoading = false.obs;
  // var isFirstLoading = true.obs;
  var hasMore = false.obs;
  var pageNum = 0;
  var pageSize = 20;

  eTabType tabType = eTabType.WITH_BIKE;

  NpcSearchType searchType = NpcSearchType.NONE;
  String searchName = '';
  int searchArea = 0;
  eNpcType searchNpcType = eNpcType.STORE;

  @override
  void onInit() {
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent &&
          hasMore.value) {
        pageNum++;
        // getSearchNpcData();
        getNpcList(isInit: false, eType: tabType);
      }
    });
    super.onInit();
  }


  getSearchNpcData(
      {NpcSearchType? type,
        bool isInit = false,
        int? area,
        String? name,
        eQuestType? qType, eNpcType? nType}) async {
    if (type != null) {
      searchType = type;
    }
    if (isInit) {
      pageNum = 0;
      // isFirstLoading.value = true;
    }
    if (area != null) {
      searchArea = area;
    }
    if (name != null) {
      searchName = name;
    }
    if (nType != null) {
      searchNpcType = nType;
    }

    if (pageNum == 0) {
      npcList.clear();
      hasMore.value = false;
    }

    isLoading.value = true;
    switch (searchType) {
      case NpcSearchType.NONE:
        await getNpcData();
        break;
      case NpcSearchType.NAME:await getSearchNameNpcData();
      break;
      case NpcSearchType.AREA:await getSearchAreaNpcData();
      break;
      case NpcSearchType.JOB:await getSearchJobNpcData();
      break;
    }
    isLoading.value = false;
    // isFirstLoading.value = false;

    if (kDebugMode) {
      print('QuestController length: ${npcList.length}');
    }
  }

  getNpcData() async {
    isLoading.value = true;
    var body = {
      'pageNum': pageNum,
      'pageSize':pageSize,
    };

    if (pageNum == 0) {
      npcList.clear();
      hasMore.value = false;
    }

    ApiRequest request = ApiRequest(url: '/npc/list', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseNpcListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });

    if (kDebugMode) {
      print('NpcController length: ${npcList.length}');
    }
    isLoading.value = false;
    // isFirstLoading.value = false;
  }

  getSearchNameNpcData() async {
    var body = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'name': searchName,
    };

    ApiRequest request = ApiRequest(url: '/npc/list/name', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseNpcListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getSearchJobNpcData() async {
    var body = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'npcType': searchNpcType.name,
    };

    ApiRequest request = ApiRequest(url: '/npc/list/job', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseNpcListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getSearchAreaNpcData() async {
    var body = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'area': searchArea,
    };

    ApiRequest request = ApiRequest(url: '/npc/list/area', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseNpcListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void parseNpcListBody(body) {
    for (var e in body['npcInfos'] as List) {
      var npc = Npc.fromJson(e['npc']);
      npc.writer = User.fromJson(e['user']);

      if (e['npcImages'] != null) {
        for (var image in e['npcImages'] as List) {
          var imgUrl = '${Environment.cdnUrl + image['imgUrl']}/${image['imgFile']}';
          // npc.pictures.add(imgUrl);
          PictureImage npcImages = PictureImage.fromJsonNpc(image);
          npcImages.pictureUrl = imgUrl;
          npc.pictures.add(npcImages);
        }
      }

      npc.thumbnail = Environment.cdnUrl + npc.thumbnail;

      debugPrint('data: ${npc.toJson()}');

      npcList.add(npc);
    }


    hasMore.value = !((body['npcInfos'] as List).length < pageSize);
  }

  modifyUrl(Npc npc, String uid, String text, String url) async {
    var sendObj = {
      'id' : npc.nid,
      'uid': uid,
      'url' : text
    };

    ApiRequest request = ApiRequest(url: '/npc/modify/'+url, body: sendObj);
    Npc ret = npc;
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var npcInfo = json.decode(value.body);
        ret = parseNpcInfo(npcInfo['npcInfo']) ?? npc;
      }
    }).catchError((onError) {
      print(onError);
    });

    return ret;
  }

  parseNpcInfo(npcInfo) {
    var npc = Npc.fromJson(npcInfo['npc']);
    npc.writer = User.fromJson(npcInfo['user']);
    for (var image in npcInfo['npcImages'] as List) {
      var imgUrl = '${Environment.cdnUrl + image['imgUrl']}/${image['imgFile']}';
      PictureImage npcImages = PictureImage.fromJsonNpc(image);
      npcImages.pictureUrl = imgUrl;
      npc.pictures.add(npcImages);
    }
    npc.thumbnail = Environment.cdnUrl + npc.thumbnail;

    debugPrint('data: ${npc.toJson()}');

    return npc;
  }

  getNpcSingleData(int id) async {
    ApiRequest request = ApiRequest(url: '/npc/id/'+id.toString());

    var npc;
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          npc = Npc.fromJson(data['npc']) as Npc;
          npc.writer = User.fromJson(data['user']);
          for (var image in data['npcImages'] as List) {
            var imgUrl = Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];
            npc.pictures.add(imgUrl);
          }
          npc.thumbnail = Environment.cdnUrl + npc.thumbnail;
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return npc;
  }

  getNpcList({required bool isInit, required eTabType eType}) async {
    if (isInit) {
      pageNum = 0;
    }
    if (pageNum == 0) {
      npcList.clear();
      hasMore.value = false;
    }

    isLoading.value = true;

    tabType = eType;
    await getNpcListByTabType();

    isLoading.value = false;

    debugPrint('QuestController length: ${npcList.length}');

  }

  getNpcListByTabType() async {
    isLoading.value = true;
    var body = {
      'pageNum': pageNum,
      'pageSize':pageSize,
      'tabType': tabType.name,
    };

    if (pageNum == 0) {
      npcList.clear();
      hasMore.value = false;
    }

    ApiRequest request = ApiRequest(url: '/npc/list/tab', body: body);
    await request.post().then((value) {

        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseNpcListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });

    if (kDebugMode) {
      print('NpcController length: ${npcList.length}');
    }
    isLoading.value = false;
  }

  getNpcImages(int nid) async {
    List<PictureImage> images = [];
    ApiRequest request = ApiRequest(url: '/npc/images/$nid');
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        for (var image in obj['npcImages'] as List) {
          var imgUrl =
              Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];
          PictureImage npcImages = PictureImage.fromJsonNpc(image);
          npcImages.pictureUrl = imgUrl;
          // quest.questImages.add(questImage);
          images.add(npcImages);
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return images;
  }
}
