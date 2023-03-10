import 'dart:convert';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/agit.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/review.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/owner.dart';

enum SearchType {
  NONE,
  NAME,
  AREA,
  JOB,
}

class QuestController extends GetxController {
  static QuestController get to => Get.find();

  RxList questList = <Quest>[].obs;
  var scrollController = ScrollController().obs;
  var isLoading = false.obs;
  // var isFirstLoading = true.obs;
  var hasMore = false.obs;
  var pageNum = 0;
  var pageSize = 20;

  SearchType searchType = SearchType.NONE;
  String searchName = '';
  int searchArea = 0;
  eQuestType searchQuestType = eQuestType.CAFE;
  eSortType sortType = eSortType.COMPLETE_COUNT;

  @override
  void onInit() {
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent &&
          hasMore.value) {
        pageNum++;
        getSearchQuestData();
      }
    });
    super.onInit();
  }

  // reload() async {
  //   isLoading.value = true;
  //   questList.clear();
  //   await Future.delayed(Duration(seconds: 1));
  //   getQuestData();
  // }

  getSearchQuestData(
      {SearchType? type,
      bool isInit = false,
      int? area,
      String? name,
      eQuestType? qType, eNpcType? nType, eSortType? eSort}) async {
    final ProfileController _profileController = Get.find<ProfileController>();

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
    if (qType != null) {
      searchQuestType = qType;
    }
    if (eSort != null) {
      sortType = eSort;
    }

    if (pageNum == 0) {
      questList.clear();
      hasMore.value = false;
    }

    isLoading.value = true;
    switch (searchType) {
      case SearchType.NONE:
        await getQuestData(_profileController.profile!.uid);
        break;
      case SearchType.NAME:await getSearchNameQuestData(_profileController.profile!.uid);
      break;
      case SearchType.AREA:await getSearchAreaQuestData(_profileController.profile!.uid);
        break;
      case SearchType.JOB:await getSearchJobQuestData(_profileController.profile!.uid);
        break;
    }
    isLoading.value = false;
    // isFirstLoading.value = false;


    debugPrint('QuestController length: ${questList.length}');
  }

  getQuestData(String uid) async {
    var body = {
      'uid' : uid,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'searchType': searchType.name,
      'sortType': sortType.name,
    };

    ApiRequest request = ApiRequest(url: '/quest/list', body: body);
    await request.post().then((value) {
        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseQuestListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getSearchNameQuestData(String uid) async {
    var body = {
      'uid' : uid,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'name': searchName,
      'sortType': sortType.name,
    };

    ApiRequest request = ApiRequest(url: '/quest/list/name', body: body);
    await request.post().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseQuestListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getSearchJobQuestData(String uid) async {
    var body = {
      'uid' : uid,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'questType': searchQuestType.name,
      'sortType': sortType.name,
    };

    ApiRequest request = ApiRequest(url: '/quest/list/job', body: body);
    await request.post().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseQuestListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getSearchAreaQuestData(String uid) async {
    var body = {
      'uid' : uid,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'area': searchArea,
      'sortType': sortType.name,
    };

    ApiRequest request = ApiRequest(url: '/quest/list/area', body: body);
    await request.post().then((value) {
        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseQuestListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void parseQuestListBody(body) {
    for (var e in body['questInfos'] as List) {
      var quest = Quest.fromJson(e['quest']);
      quest.writer = User.fromJson(e['user']);
      if (e['questImages'] != null) {
        for (var image in e['questImages'] as List) {
          var imgUrl =
              Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];
          PictureImage questImage = PictureImage.fromJsonQuest(image);
          questImage.pictureUrl = imgUrl;
          quest.questImages.add(questImage);
          // quest.pictures.add(imgUrl);
        }
      }

      quest.thumbnail = Environment.cdnUrl + quest.thumbnail;
      debugPrint('data: ${quest.toJson()}');
      questList.add(quest);
    }

    hasMore.value = !((body['questInfos'] as List).length < pageSize);
  }

  Quest modifyQuest(data) {
    var quest = Quest.fromJson(data['quest']);
    quest.writer = User.fromJson(data['user']);
    for (var image in data['questImages'] as List) {
      var imgUrl =
          Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];

      PictureImage questImage = PictureImage.fromJsonQuest(image);
      questImage.pictureUrl = imgUrl;
      quest.questImages.add(questImage);
      debugPrint('imgUrl : ${imgUrl}');
    }
    quest.thumbnail = Environment.cdnUrl + quest.thumbnail;
    debugPrint('data: ${quest.toJson()}');

    for(int i = 0; i < questList.length; i++) {
      if (questList[i].qid == quest.qid) {
        questList[i] = quest;
      }
    }

    return quest;
  }

  modifyYoutubeUrl(Quest quest, String uid, String text) async {
    var sendObj = {
      'qid' : quest.qid,
      'uid': uid,
      'youtubeUrl' : text
    };
    debugPrint('modifyQuest:${sendObj}');
    ApiRequest request = ApiRequest(url: '/quest/modify/youtube_url', body: sendObj);
    Quest ret = quest;
    await request.post().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          ret = modifyQuest(data['questInfo']);
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return ret;
  }

  modifyInstagramUrl(Quest quest, String uid, String text) async {
    var sendObj = {
      'qid' : quest.qid,
      'uid': uid,
      'instagram' : text
    };
    debugPrint('modifyQuest:${sendObj}');
    ApiRequest request = ApiRequest(url: '/quest/modify/instagram', body: sendObj);
    Quest ret = quest;
    await request.post().then((value) {

      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          ret = modifyQuest(data['questInfo']);
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return ret;
  }

  Future<Quest?> getQuestSingleData(int id) async {
    ApiRequest request = ApiRequest(url: '/quest/id/'+id.toString());

    var quest;
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          quest = Quest.fromJson(data['quest']);
          quest.writer = User.fromJson(data['user']);
          for (var image in data['questImages'] as List) {
            var imgUrl =
                '${Environment.cdnUrl + image['imgUrl']}/${image['imgFile']}';

            PictureImage questImage = PictureImage.fromJsonQuest(image);
            questImage.pictureUrl = imgUrl;
            quest.questImages.add(questImage);
            debugPrint('imgUrl : $imgUrl');
          }
          quest.thumbnail = Environment.cdnUrl + quest.thumbnail;
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return quest;
  }

  Future<List<Review>> getReviews(int qid, String uid) async {
    ApiRequest request = ApiRequest(url: '/quest/review/list/$uid/$qid');

    List<Review> reviews = [];
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var r in data['reviewInfos'] as List) {
            Review review = Review.fromJson(r['review']);
            review.reviewer = User.fromJson(r['user']);

            reviews.add(review);
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return reviews;
  }

  Future<List<Review>> writeReview(qid, uid, String text) async {
    var sendObj = {
      'qid' : qid,
      'uid': uid,
      'context' : text
    };
    debugPrint('modifyQuest:${sendObj}');
    ApiRequest request = ApiRequest(url: '/quest/review/add', body: sendObj);
    List<Review> reviews = [];

    await request.post().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var r in data['reviewInfos'] as List) {
            Review review = Review.fromJson(r['review']);
            review.reviewer = User.fromJson(r['user']);

            reviews.add(review);
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return reviews;
  }

  removeReview(int rid, int qid, String uid) async {

    ApiRequest request = ApiRequest(url: '/quest/review/$rid/$uid/$qid');
    List<Review> reviews = [];

    await request.del().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var r in data['reviewInfos'] as List) {
            Review review = Review.fromJson(r['review']);
            review.reviewer = User.fromJson(r['user']);

            reviews.add(review);
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return reviews;
  }

  getAgitList(uid) async {
    ApiRequest request = ApiRequest(url: '/quest/agit/$uid');

    List<Agit> agits = [];
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var r in data['agitInfos'] as List) {
            Agit agit = Agit.fromJson(r);
            agits.add(agit);
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return agits;
  }

  getOwnerWord(int qid) async {
    String word = '';
    ApiRequest request = ApiRequest(url: '/quest/owner/$qid');
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        Owner owner = Owner.fromJson(obj['owner']);
        word = owner.word;
      }
    }).catchError((onError) {
      print(onError);
    });

    return word;
  }

  changeGatePicture(int qid, int srcPid, int decPid) async {
    var sendObj = {
      'qid' : qid,
      'srcPid': srcPid,
      'decPid': decPid,
    };

    ApiRequest request = ApiRequest(url: '/quest/update/thumb', body: sendObj);
    bool isSuccess = false;

    await request.post().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        isSuccess = true;
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  getQuestImages(int qid) async {
    List<PictureImage> images = [];
    ApiRequest request = ApiRequest(url: '/quest/images/$qid');
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        for (var image in obj['questImages'] as List) {
          var imgUrl =
              Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];
          PictureImage questImage = PictureImage.fromJsonQuest(image);
          questImage.pictureUrl = imgUrl;
          // quest.questImages.add(questImage);
          images.add(questImage);
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return images;
  }

  getCafeMenuUrl(int qid) async {
    String menuPaper = '';
    ApiRequest request = ApiRequest(url: '/quest/menu_paper/$qid');

    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        var menu = obj['menuPaper'];
        menuPaper =
            Environment.cdnUrl + menu['imgUrl'] + '/' + menu['imgFile'];

      }
    }).catchError((onError) {
      print(onError);
    });

    return menuPaper;
  }
}
