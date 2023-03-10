import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/constants/area_num.dart';
import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/constants/urls.dart';
import 'package:bike_adventure/controllers/google_service_controller.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/foot_print_log.dart';
import 'package:bike_adventure/models/friend.dart';
import 'package:bike_adventure/models/marker_info.dart';
import 'package:bike_adventure/models/my_npc.dart';
import 'package:bike_adventure/models/my_quest.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/models/owner.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/utils/map_position.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as KakaoUserSdk;
import 'package:package_info_plus/package_info_plus.dart';

enum LoginStat {
  loading,
  none,
  // process,
  needUpdate,
  // googleDone,
  // myServerDone,
  success,
}




class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  String version = '';
  RxString packageVersion = ''.obs;
  String packageName = '';
  User? profile;
  List<User> favoriteBikers = <User>[].obs;
  List<MyQuest> completedQuestList = <MyQuest>[].obs;
  List<MyQuest> regQuestList = <MyQuest>[].obs;
  List<MyQuest> acceptQuestList = <MyQuest>[].obs;
  List<MyNpc> regNpcList = <MyNpc>[].obs;
  List<User> blockUserList = <User>[].obs;

  List<AreaMap> areaMaps = AREA_MAP;
  List<Motorcycle> allMotoBrandBikes = Motorcycles;

  RxString roadSignImage = ''.obs;
  RxInt bikeBrand = 0.obs;
  RxInt bikeModel = 0.obs;

  var isLogin = LoginStat.loading.obs;
  var myPositionTimer;
  int myPositionTimerCount = 0;
  double myLat = 0.0;
  double myLng = 0.0;
  double myOldLat = 0.0;
  double myOldLng = 0.0;

  getMyMotoBrand() {
    Motorcycle? myMoto = allMotoBrandBikes
        .firstWhereOrNull((element) => element.code == bikeBrand.value);
    if (myMoto != null) {
      return myMoto;
    }
    return allMotoBrandBikes[0];
  }

  getMyMotoBike() {
    Motorcycle? myMoto = allMotoBrandBikes
        .firstWhereOrNull((element) => element.code == bikeBrand.value);
    if (myMoto != null) {
      BrandMotoBrandMoto? motoBike = myMoto.bikes
          .firstWhereOrNull((element) => element.code == bikeModel.value);
      if (motoBike != null) {
        return motoBike;
      }

      return myMoto.bikes[0];
    }
    return allMotoBrandBikes[0].bikes[0];
  }

  setMyMotoCycle(brandCode, modelCode) async {
    var body = {
      'uid': profile!.uid,
      'bikeBrand': brandCode,
      'bikeModel': modelCode,
    };

    int retCode = -1;
    ApiRequest request = ApiRequest(url: '/user/my_bike', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        profile!.bikeBrand = bikeBrand.value = brandCode;
        profile!.bikeModel = bikeModel.value = modelCode;
      }
    }).catchError((onError) {
      print(onError);
    });

    return retCode;
  }

  startMainPage(int delay) async {
    await Future.delayed(Duration(seconds: delay));
    Get.offAll(() => const MainPage(), transition: Transition.downToUp);
  }

  initVersion() async {
    await getVersionInfo();

    PackageInfo packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown',
    );
    packageInfo = await PackageInfo.fromPlatform();
    // print('appName: ${packageInfo.appName}');
    // print('packageName: ${packageInfo.packageName}');
    // print('version: ${packageInfo.version}');
    // print('buildNumber: ${packageInfo.buildNumber}');
    // print('buildSignature: ${packageInfo.buildSignature}');

    packageName = packageInfo.packageName;
    packageVersion.value = packageInfo.version;
    print('packageName: ${packageName}, packageVersion: ${packageVersion}');
  }

  init() {
    profile = User.fromJson({
      'uid': '',
      'nick': '',
      'email': '',
      'score': 0,
    });
    version = '';
    packageName = '';
    favoriteBikers.clear();
    completedQuestList.clear();
    regQuestList.clear();
    acceptQuestList.clear();
    regNpcList.clear();
    roadSignImage.value = '';
    bikeBrand.value = 0;
    bikeModel.value = 0;
  }

  userLogOut() async {
    debugPrint('logout ${profile!.service}');


    if (profile!.service == eService.KAKAO) {
      debugPrint('kakao logout');
      await KakaoUserSdk.UserApi.instance.logout();
    }
    else {
      debugPrint('google logout');
      GoogleServiceController.to.handleSignOut();
    }

    isLogin.value = LoginStat.none;
    init();
  }

  setUser(uid, String email, String? nick, String? avatarImg) {
    profile =
        User(uid: uid, email: email, nick: nick ?? 'nobody', avatar: avatarImg ?? '');
    // isLogin.value = LoginStat.googleDone;
  }

  setMyPositionTimer(int sec) {
    if (myPositionTimer != null) {
      myPositionTimer.cancel();
    }

    myPositionTimer = Timer.periodic(Duration(seconds: sec), (timer) {
      myPositionTimerCount++;

      determinePosition().then((location) {
        num d = getLocationDistance(myLat, myLng, location[0], location[1]);
        debugPrint('setMyPositionTimer dist: $d');
        // if (d < 0 || d > 10) {
        //   setMyPositionTimer(10);
        // }
        // else {
        //   setMyPositionTimer(30);
        // }
        myLat = location[0];
        myLng = location[1];

      }).catchError((onError) {
        print(onError);
      });

      debugPrint(timer.tick.toString());
    });
  }

  Future<User> getMyProfile(eService service) async {
    var body = {
      'uid': profile!.uid,
      'email': profile!.email,
      'nick': profile!.nick,
      'avatar': profile!.avatar,
      'service': service.name,
    };

    ApiRequest request = ApiRequest(url: '/user/my_profile', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        profile = User.fromJson(obj['user']);

        bikeBrand.value = profile!.bikeBrand;
        bikeModel.value = profile!.bikeModel;
        if (profile!.roadSignUrl.isNotEmpty && profile!.roadSignFile.isNotEmpty) {
          roadSignImage.value = Environment.cdnUrl + profile!.roadSignUrl + '/' + profile!.roadSignFile;
        }

        regQuestList.clear();
        if (obj['registerQuests'] != null) {
          for (var e in obj['registerQuests'] as List) {
            regQuestList.add(MyQuest.fromJson(e));
          }
        }
        regNpcList.clear();
        if (obj['registerNpcs'] != null) {
          for (var e in obj['registerNpcs'] as List) {
            regNpcList.add(MyNpc.fromJson(e));
          }
        }
        acceptQuestList.clear();
        completedQuestList.clear();
        if (obj['myQuests'] != null) {
          for (var e in obj['myQuests'] as List) {
            if (e['completed']) {
              completedQuestList.add(MyQuest.fromJson(e));
            } else {
              acceptQuestList.add(MyQuest.fromJson(e));
            }
          }
        }
        favoriteBikers.clear();
        if (obj['favoriteBikers'] != null) {
          for (var e in obj['favoriteBikers'] as List) {
            // favoriteBikers.add(Biker(
            //     uid: e['uid'],
            //     nick: e['nick'],
            //     email: e['email'],
            //     bikeBrand: e['bikeBrand'],
            //     bikeModel: e['bikeModel'],
            //     avatar: e['avatar']));
            User biker = User.fromJson(e);
            print('avatar: ${biker.avatar} nick: ${biker.nick}');
            // biker.bikeBrand = profile!.bikeBrand;
            // biker.bikeModel = profile!.bikeModel;
            // if (biker.roadSignUrl.isNotEmpty && biker.roadSignFile.isNotEmpty) {
            //   biker.roadSignImage.value = Environment.cdnUrl + biker.roadSignUrl + '/' + biker.roadSignFile;
            // }
            favoriteBikers.add(biker);
            // favoriteBikers.add(User.fromJson(e));
          }
        }
        // print(profile!.toJson());
        // if (isLogin.value != LoginStat.needUpdate) {
        //   print('1111111111111: ${isLogin.value}');
        //   isLogin.value = LoginStat.success;
        // }
        isLogin.value = LoginStat.success;
      }
    }).catchError((onError) {
      print(onError);
    });

    return profile!;
  }

  String getMyProfileImage() {
    if (roadSignImage.isEmpty) {
      return defaultProfileImg;
    }

    return roadSignImage.value;
  }

  setProfileEquips(type, String value) {
    if (profile == null || value.isEmpty) {
      return;
    }

    switch (type) {
      // case EQUIP_TYPE.bike: profile!.bike = value; break;
      // case EQUIP_TYPE.bikeYear: profile!.bikeYear = value; break;
      // case EQUIP_TYPE.helmet: profile!.helmet = value; break;
      // case EQUIP_TYPE.jacket: profile!.jacket = value; break;
      // case EQUIP_TYPE.pants: profile!.pants = value; break;
      // case EQUIP_TYPE.glove: profile!.glove = value; break;
      // case EQUIP_TYPE.shoes: profile!.shoes = value; break;
      // case EQUIP_TYPE.backpack: profile!.backpack = value; break;
    }

    update();
  }

  // String getMyProfileImg() {
  //   return roadSignImage.isEmpty
  //       ? 'https://images.pexels.com/photos/2317408/pexels-photo-2317408.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  //       : roadSignImage.value;
  // }

  Widget getMyAvatarImg() {
    if (profile == null || profile!.avatar.isEmpty) {
      return Image.asset(
        'assets/icons/nobody_avatar3.png',
        fit: BoxFit.cover,
        width: 90,
        height: 90,
      );
    }

    return Image.network(
      profile!.avatar,
      fit: BoxFit.cover,
      width: 90,
      height: 90,
    );
  }

  String getProfileEquipsText(EQUIP_TYPE type) {
    return '';
    // if (profile == null) {
    //   return '';
    // }
    //
    // switch(type) {
    //   case EQUIP_TYPE.bike: return profile!.bike;
    //   case EQUIP_TYPE.bikeYear: return profile!.bikeYear;
    //   case EQUIP_TYPE.helmet: return profile!.helmet;
    //   case EQUIP_TYPE.jacket: return profile!.jacket;
    //   case EQUIP_TYPE.pants: return profile!.pants;
    //   case EQUIP_TYPE.glove: return profile!.glove;
    //   case EQUIP_TYPE.shoes: return profile!.shoes;
    //   case EQUIP_TYPE.backpack: return profile!.backpack;
    // }
  }

  getQuestBindingType(int qid) {
    var quest = regQuestList.firstWhereOrNull((element) => element.qid == qid);
    if (quest != null) {
      return eQuestBinding.registered;
    }

    quest =
        completedQuestList.firstWhereOrNull((element) => element.qid == qid);
    if (quest != null) {
      return eQuestBinding.completed;
    }

    quest = acceptQuestList.firstWhereOrNull((element) => element.qid == qid);
    if (quest != null) {
      return eQuestBinding.accepted;
    }

    return eQuestBinding.none;
  }

  acceptOrCancelQuest(Quest quest) async {
    var body = {
      'uid': profile!.uid,
      'qid': quest.qid,
    };

    ApiRequest request = ApiRequest(url: '/quest/aoc', body: body);
    int retCode = -1;
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        retCode = obj['retCode'];
        acceptQuestList.clear();
        if (obj['acceptQuests'] != null) {
          for (var e in obj['acceptQuests'] as List) {
            acceptQuestList.add(MyQuest.fromJson(e));
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return retCode;
  }

  setFavorite(String uid) async {
    if (uid == profile!.uid) {
      return 0;
    }

    var body = {
      'uid': profile!.uid,
      'target': uid,
    };

    int retCode = -1;
    ApiRequest request = ApiRequest(url: '/user/favorite', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        retCode = obj['retCode'];
        favoriteBikers.clear();
        for (var e in obj['favoriteBikers'] as List) {
          User biker = User.fromJson(e);

          favoriteBikers.add(biker);
        }
        update();
      }
    }).catchError((onError) {
      print(onError);
    });

    return retCode;
  }

  getQuestData(type, questList) async {
    var body = {
      'uid': profile!.uid,
      'type': type,
    };

    var retCode = [];
    ApiRequest request = ApiRequest(url: '/quest/my_quest_info', body: body);
    await request.post().then((value) {

        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        // retCode.addAll(obj['questInfos']);
        for (var e in obj['questInfos'] as List) {
          var quest = Quest.fromJson(e['quest']);
          quest.writer = User.fromJson(e['user']);
          // quest.mainIndex = e['questImage']['mainIndex'];
          for (var image in e['questImages'] as List) {
            var imgUrl =
                Environment.cdnUrl + image['imgUrl'] + '/' + image['imgFile'];

            PictureImage questImage = PictureImage.fromJsonQuest(image);
            questImage.pictureUrl = imgUrl;
            quest.questImages.add(questImage);

            // quest.pictures.add(imgUrl);
          }
          quest.thumbnail = Environment.cdnUrl + quest.thumbnail;
          if (kDebugMode) {
            print('data: ${quest.toJson()}');
          }
          questList.add(quest);
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return retCode;
  }

  setRegisterQuests(registerQuests) {
    regQuestList.clear();
    for (var e in registerQuests as List) {
      regQuestList.add(e);
    }
  }

  getQuestSimpleIcon(qid) {
    eQuestBinding eType = getQuestBindingType(qid);

    switch (eType) {
      case eQuestBinding.registered:
        return const Icon(Icons.beenhere_rounded,
            size: 17, color: Colors.deepPurpleAccent);
      case eQuestBinding.completed:
        return const Icon(Icons.check_circle_outline_rounded,
            size: 17, color: Colors.amber);
      case eQuestBinding.accepted:
        return const Icon(Icons.play_circle_rounded,
            size: 17, color: Colors.green);
      case eQuestBinding.none:
        // return const Icon(Icons.play_circle_rounded,
        //     size: 17, color: Colors.green);
        return const FaIcon(FontAwesomeIcons.delicious,
            color: Colors.green, size: 15);
    }
  }

  completeQuest(Quest quest) async {
    var body = {
      'uid': profile!.uid,
      'qid': quest.qid,
    };

    bool isSuccess = false;
    ApiRequest request = ApiRequest(url: '/quest/complete', body: body);
    await request.post().then((value) {
        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        isSuccess = obj['isSuccess'];
        if (isSuccess) {
          acceptQuestList.clear();
          completedQuestList.clear();
          if (obj['myQuests'] != null) {
            for (var e in obj['myQuests'] as List) {
              if (e['completed']) {
                completedQuestList.add(MyQuest.fromJson(e));
              } else {
                acceptQuestList.add(MyQuest.fromJson(e));
              }
            }

            debugPrint('completed : ${completedQuestList.length}');
            debugPrint('acceptQuestList : ${acceptQuestList.length}');

          }

          profile!.score = obj['score'];
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  footQuest(Quest quest) async {
    var body = {
      'uid': profile!.uid,
      'qid': quest.qid,
    };

    bool isSuccess = false;
    ApiRequest request = ApiRequest(url: '/quest/foot', body: body);
    await request.post().then((value) {
        debugPrint('Response status: ${value.statusCode}');
        debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        isSuccess = obj['isSuccess'];
        if (isSuccess) {
          profile!.score = obj['score'];
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  removeQuest(quest) async {
    MyQuest? myQuest =
        regQuestList.firstWhereOrNull((element) => element.qid == quest.qid);
    if (myQuest == null) {
      return false;
    }

    bool isSuccess = false;
    var body = {
      'uid': profile!.uid,
      'questIdx': myQuest.idx,
    };

    ApiRequest request = ApiRequest(url: '/quest/remove', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        regQuestList.clear();
        if (obj['myQuests'] != null) {
          for (var e in obj['myQuests'] as List) {
            regQuestList.add(MyQuest.fromJson(e));
          }
          if (kDebugMode) {
            print('regQuestList : ${regQuestList.length}');
          }
          isSuccess = true;
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  removeNpc(npc) async {
    MyNpc? myNpc =
        regNpcList.firstWhereOrNull((element) => element.nid == npc.nid);
    if (myNpc == null) {
      return false;
    }

    bool isSuccess = false;
    var body = {
      'uid': profile!.uid,
      'npcIdx': myNpc.idx,
    };

    ApiRequest request = ApiRequest(url: '/npc/remove', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        regNpcList.clear();
        if (obj['myNpcs'] != null) {
          for (var e in obj['myNpcs'] as List) {
            regNpcList.add(MyNpc.fromJson(e));
          }
          if (kDebugMode) {
            print('myNpcs : ${regNpcList.length}');
          }
          isSuccess = true;
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  bool isMyNpc(Npc npc) {
    if (npc.writer!.uid != profile!.uid) {
      return false;
    }

    MyNpc? myNpc =
        regNpcList.firstWhereOrNull((element) => element.nid == npc.nid);
    if (myNpc == null) {
      return false;
    }

    return true;
  }

  getAreaCode(String s) {
    int area = 0;
    try {
      AreaMap? areaMap =
      areaMaps.firstWhere((element) => s.contains(element.name));

      if (areaMap != null) {
        area = areaMap.code;
      }
    }
    catch (e) {
      print(e);
    }

    return area;
  }

  // String getMyBikeText(iBikeBrand, iBikeModel) {
  //   Motorcycle? myMoto = allMotoBrandBikes
  //       .firstWhereOrNull((element) => element.code == iBikeBrand);
  //   if (myMoto != null && myMoto.code != 0) {
  //     BrandMotoBrandMoto? motoBike = myMoto.bikes
  //         .firstWhereOrNull((element) => element.code == iBikeModel);
  //     if (motoBike != null && motoBike.code != 0) {
  //       return '${myMoto.name} ${motoBike.bike}';
  //     }
  //
  //     return myMoto.name;
  //   }
  //   return 'NOT-SET';
  // }

  getVersionInfo() async {
    var body = {
      'service': Platform.isAndroid ? 'android' : 'ios',
    };

    ApiRequest request = ApiRequest(url: '/user/version', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);
        version = obj['version'];
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  bool isNeedUpdate() {
    if (version.isEmpty) {
      return true;
    }
    if (isLogin.value == LoginStat.success) {
      return true;
    }

    List<String> pv = packageVersion.value.split('.');
    List<String> sv = version.split('.');
    bool needUpdate = false;
    for (var i = 0; i < sv.length; i++) {
      if (int.parse(pv[i]) < int.parse(sv[i])) {
        needUpdate = true;
        break;
      }
    }

    if (kDebugMode) {
      print('server version: $version');
      print('package version: ${packageVersion.value}');
    }

    return needUpdate; //버전 안맞아도 그냥 패스
  }

  // bool checkVersion() {
  //   bool isRight = packageVersion.value == version;
  //   if (!isRight) {
  //     isLogin.value = LoginStat.needUpdate;
  //     // print('222222222222222: ${isLogin.value}');
  //     // pushSnackbar('Login', '버전 업데이트가 필요합니다');
  //     // showUpdateAlertDialog(context);
  //   }
  //
  //   if (kDebugMode) {
  //     print('server version: $version');
  //     print('package version: ${packageVersion.value}');
  //   }
  //
  //   return true; //버전 안맞아도 그냥 패스
  // }

  pushProfileImage(String attachImg) async {
    var sendObj = {
      'road_sign': json.encode({
        'uid': profile!.uid,
      })
    };

    ApiRequest request = ApiRequest(url: '/user/update/road_sign', body: sendObj);

    var data = await request.uploadFormData([attachImg]);
    if (data != null) {
      if (kDebugMode) {
        print('Response body: ${data['user']}');
      }

      var obj = data['user'];
      profile!.roadSignUrl = obj['roadSignUrl'];
      profile!.roadSignFile = obj['roadSignFile'];
      roadSignImage.value = Environment.cdnUrl + obj['roadSignUrl'] + '/' + obj['roadSignFile'];
    }
  }

  pushCs(String text, String attachImg) async {
    var sendObj = {
      'cs': json.encode({
        'csid': 0,
        'email': profile!.email,
        'nick': profile!.nick,
        'uid': profile!.uid,
        'plain': text,
      })
    };

    var ret = false;
    ApiRequest request = ApiRequest(url: '/cs/add', body: sendObj);

    var data = await request.uploadFormData(attachImg.isEmpty ? [] : [attachImg]);

    return ret;
  }

  Future<bool> uploadYoutubeUrl(String url) async {
    var body = {
      'uid': profile!.uid,
      'url': url,
    };

    bool isSuccess = false;
    ApiRequest request = ApiRequest(url: '/user/youtube', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        isSuccess = true;
        profile!.youtubeUrl = url;
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  uploadInstagram(String url) async {
    var body = {
      'uid': profile!.uid,
      'url': url,
    };

    bool isSuccess = false;
    ApiRequest request = ApiRequest(url: '/user/instagram', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        isSuccess = true;
        profile!.instagram = url;
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  getInstagramText() {
    return profile!.instagram.isEmpty ?  'Instagram' : profile!.instagram;
  }

  getYoutubeText() {
    return profile!.youtubeUrl.isEmpty ? 'Youtube channel' : profile!.youtubeUrl;
  }

  void setServiceCodec() async {
    var body = {
      'uid': profile!.uid,
    };

    ApiRequest request = ApiRequest(url: '/user/service_codec', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        profile!.serviceCodec = true;
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  reportQuest(quest) async {
    bool isSuccess = false;
    var body = {
      'uid': profile!.uid,
      'questIdx': quest.qid,
    };

    ApiRequest request = ApiRequest(url: '/quest/report', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        isSuccess = true;
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  blockUser(user) async {
    bool isSuccess = false;
    var body = {
      'uid': profile!.uid,
      'targetUid': user.uid,
    };

    ApiRequest request = ApiRequest(url: '/user/block', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        isSuccess = true;
      }
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

  getBlockUserList() async {

    var body = {
      'uid': profile!.uid,
    };

    ApiRequest request = ApiRequest(url: '/user/block_list', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          blockUserList.clear();
          blockUserList.addAll(parseUserList(data));
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  parseUserList(data) {
    List<User> users = List.empty(growable: true);
    for (var u in data['userBlockList'] as List) {
      User user = User.fromJson(u);
      users.add(user);
    }
    return users;
  }

  void nonBlockUser(String uid) async {
    var body = {
      'uid': profile!.uid,
      'targetUid': uid,
    };

    ApiRequest request = ApiRequest(url: '/user/nonblock', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          blockUserList.clear();
          blockUserList.addAll(parseUserList(data));
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getMarkerInfo(lat, lng) async {
    var sendObj = {
      'lat' : lat,
      'lng' : lng,
    };

    debugPrint('getMarkerInfo:${sendObj}');
    ApiRequest request = ApiRequest(url: '/user/marker', body: sendObj);
    List<MarkerInfo> markers = [];
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var e in data['markerInfos'] as List) {
            markers.add(MarkerInfo.fromMap(e));
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return markers;
  }

  void setMyAgit(int myAgit) async {
    var body = {
      'uid': profile!.uid,
      'qid': myAgit,
    };

    ApiRequest request = ApiRequest(url: '/user/agit', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          profile!.agit = myAgit;
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  leaveApp() async {
    var body = {
      'uid': profile!.uid,
    };

    ApiRequest request = ApiRequest(url: '/user/leave', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {

      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getFootPrintLog(uid) async {
    ApiRequest request = ApiRequest(url: '/user/foot/$uid');

    List<FootPrintLog> foots = [];
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var r in data['footPrintLogs'] as List) {
            FootPrintLog foot = FootPrintLog.fromJson(r);
            foots.add(foot);
          }

          foots.sort((a, b) => b.date.compareTo(a.date));
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return foots;
  }

  getLastFootLog() async {
    ApiRequest request = ApiRequest(url: '/user/foot_last/${profile!.uid}');

    List<FootPrintLog> foots = [];
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');

      if (value.statusCode == 200) {
        var data  = json.decode(value.body);
        if (data != null) { //data['questInfo']
          for (var r in data['footPrintLogs'] as List) {
            FootPrintLog foot = FootPrintLog.fromJson(r);
            foots.add(foot);
          }

          foots.sort((a, b) => b.date.compareTo(a.date));
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return foots;
  }

  reportReview(String rid) async {
    bool isSuccess = false;
    var body = {
      'uid': profile!.uid,
      'tid': rid,
    };

    ApiRequest request = ApiRequest(url: '/user/report', body: body);
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

  setCafeOwner(String uid, qid) async {
    bool isSuccess = false;
    var body = {
      'uid': profile!.uid,
      'tid': uid,
      'qid': qid
    };

    ApiRequest request = ApiRequest(url: '/user/owner', body: body);
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

  setOwnerWord(String text) async {
    var body = {
      'uid': profile!.uid,
      'word': text,
    };

    String word = '';
    ApiRequest request = ApiRequest(url: '/user/owner/word', body: body);
    await request.post().then((value) {
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

  getOwnerWord() async {
    String word = '';
    ApiRequest request = ApiRequest(url: '/user/owner/${profile!.uid}');
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

  pushMenuPaper(String path) {}

  getFriends() async {
    List<Friend> friends = [];
    ApiRequest request = ApiRequest(url: '/user/friends/${profile!.uid}');
    await request.get().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        friends.clear();
        if (obj['friendList'] != null) {
          for (var f in obj['friendList'] as List) {
            debugPrint(json.encode(f));
            friends.add(Friend.fromJson(f));
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return friends;
  }

  addFriend(String email, String fid) async {
    List<Friend> friends = [];
    var body = {
      'uid': profile!.uid,
      'email': email,
      'fid' : fid
    };

    ApiRequest request = ApiRequest(url: '/user/friends', body: body);
    await request.put().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        friends.clear();
        if (obj['friendList'] != null) {
          for (var f in obj['friendList'] as List) {
            debugPrint(json.encode(f));
            friends.add(Friend.fromJson(f));
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return friends;
  }

  updateFriend(String fid, bool isUnpair, bool isPairing, bool isAccept) async {
    List<Friend> friends = [];
    var body = {
      'uid': profile!.uid,
      'fid' : fid,
      'unpair' : isUnpair,
      'pairing' : isPairing,
      'accept' : isAccept
    };

    ApiRequest request = ApiRequest(url: '/user/friends', body: body);
    await request.post().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        friends.clear();
        if (obj['friendList'] != null) {
          for (var f in obj['friendList'] as List) {
            debugPrint(json.encode(f));
            friends.add(Friend.fromJson(f));
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return friends;
  }

  delFriends(String fid) async {
    List<Friend> friends = [];
    ApiRequest request = ApiRequest(url: '/user/friends/${profile!.uid}/$fid');
    await request.del().then((value) {
      debugPrint('Response status: ${value.statusCode}');
      debugPrint('Response body: ${value.body}');
      if (value.statusCode == 200) {
        var obj = json.decode(value.body);

        friends.clear();
        if (obj['friendList'] != null) {
          for (var f in obj['friendList'] as List) {
            debugPrint(json.encode(f));
            friends.add(Friend.fromJson(f));
          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });

    return friends;
  }
}
