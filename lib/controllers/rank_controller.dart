import 'dart:convert';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankController extends GetxController {
  static RankController get to => Get.find();

  RxList rankerList = <User>[].obs;
  var scrollController = ScrollController().obs;
  var isLoading = true.obs;
  var hasMore = false.obs;
  var pageNum = 0;
  var pageSize = 20;

  User? ranker;
  // Biker? biker;
  var isRankerLoading = true.obs;
  RxList questList = <Quest>[].obs;

  @override
  void onInit() {
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent &&
          hasMore.value) {
        pageNum++;
        getData();
      }
    });
    super.onInit();
  }

  getData() async {
    isLoading.value = true;

    if (pageNum == 0) {
      rankerList.clear();
      hasMore.value = false;
    }

    var body = {
      'pageNum': pageNum,
      'pageSize':pageSize,
    };

    ApiRequest request = ApiRequest(url: '/rank/leader_board', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        for (var e in body['rankers'] as List) {
          User ranker = User.fromJson(e['user']);
          ranker.ranking = e['rank'];
          rankerList.add(ranker);
        }

        hasMore.value = !((body['rankers'] as List).length < pageSize);
      }
    }).catchError((onError) {
      print(onError);
    });

    if (kDebugMode) {
      print('RankController length: ${rankerList.length}');
    }
    isLoading.value = false;
  }

  getBikerDetail(uid) async {
    isRankerLoading.value = true;

    var body = {
      'uid': uid,
    };

    ApiRequest request = ApiRequest(url: '/user/biker', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        // retCode.addAll(obj['questInfos']);
        ranker = User.fromJson(obj['user']);
        questList.clear();
        for (var e in obj['bikerQuests'] as List) {
          var quest = Quest.fromJson(e['quest']);
          quest.writer = User.fromJson(obj['user']);
          // quest.writer = User.fromJson(ranker!.toJson());
          // quest.mainIndex = e['questImage']['mainIndex'];
          for (var image in e['questImages'] as List) {
            var imgUrl = Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];
            // quest.pictures.add(imgUrl);
            PictureImage questImage = PictureImage.fromJsonQuest(image);
            questImage.pictureUrl = imgUrl;
            quest.questImages.add(questImage);

          }
          quest.thumbnail = Environment.cdnUrl + quest.thumbnail;

          debugPrint('data: ${quest.toJson()}');
          questList.add(quest);
        }
      }
    }).catchError((onError) {
      print(onError);
    });


    // var body = fakeApi.getRanker();
    // var quest_body = fakeApi.getRankerQuest();
    // await Future.delayed(const Duration(seconds: 2));
    //
    // ranker = Ranker.fromJson(json.decode(body));
    // questList.addAll(((json.decode(quest_body) as List)
    //     .map((i) => Quest.fromJson(i))
    //     .toList()));

    isRankerLoading.value = false;
    update();
  }

  getRankerDetail(uid) async {
    isRankerLoading.value = true;

    var body = {
      'uid': uid,
    };

    ApiRequest request = ApiRequest(url: '/user/ranker', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        // retCode.addAll(obj['questInfos']);
        ranker = User.fromJson(obj['user']);
        questList.clear();
        for (var e in obj['bikerQuests'] as List) {
          var quest = Quest.fromJson(e['quest']);
          quest.writer = User.fromJson(obj['user']);
          // quest.writer = User.fromJson(ranker!.toJson());
          // quest.mainIndex = e['questImage']['mainIndex'];
          for (var image in e['questImages'] as List) {
            var imgUrl = Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];
            // quest.pictures.add(imgUrl);
            PictureImage questImage = PictureImage.fromJsonQuest(image);
            questImage.pictureUrl = imgUrl;
            quest.questImages.add(questImage);
          }
          quest.thumbnail = Environment.cdnUrl + quest.thumbnail;

          debugPrint('data: ${quest.toJson()}');
          questList.add(quest);
        }
      }
    }).catchError((onError) {
      print(onError);
    });


    // var body = fakeApi.getRanker();
    // var quest_body = fakeApi.getRankerQuest();
    // await Future.delayed(const Duration(seconds: 2));
    //
    // ranker = Ranker.fromJson(json.decode(body));
    // questList.addAll(((json.decode(quest_body) as List)
    //     .map((i) => Quest.fromJson(i))
    //     .toList()));

    isRankerLoading.value = false;
    update();
  }

  // String getProfileImg() {
  //   return ranker!.profileImg.isEmpty
  //       ? 'https://images.pexels.com/photos/2317408/pexels-photo-2317408.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  //       : ranker!.profileImg;
  // }

  User getRankerByRanking(int ranking) {
    if (ranking > rankerList.length) {
      return User.fromJson({
        'uid': '0',
        'nick': 'NOBODY',
        'email': '@NOBODY',
        'score': 0,
        'ranking': 0,
        // 'regQuestList' : [], //add detail
        'profileImg':'', //add detail
        'avatar': 'assets/icons/nobody_avatar3.png',
      });
    }

    return rankerList.firstWhere((e) => e.ranking == ranking, orElse: null);
  }

  reload() async {
    isLoading.value = true;
    rankerList.clear();
    await Future.delayed(const Duration(seconds: 1));
    getData();
  }
}
