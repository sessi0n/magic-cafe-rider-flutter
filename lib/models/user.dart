import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum eService {
  NONE,
  GOOGLE,
  APPLE,
  KAKAO,
}

class User {
  String uid;
  int role = 0;
  eService service = eService.NONE;
  bool serviceCodec = false;
  String nick;
  String email;
  int score = 0;
  int guildPoint = 0;
  int agit = 0;
  int bikeBrand = 0;
  int bikeModel = 0;

  int ranking = 0; //특이 변수

  String avatar = '';
  String roadSignUrl = '';
  String roadSignFile = '';

  String youtubeUrl = '';
  String instagram = '';

  DateTime createdTime = DateTime.now();
  DateTime lastLoginTime = DateTime.now();

  User({required this.uid, required this.nick, required this.email, required this.avatar});

  // setData(Map<String, dynamic> map) {
  //   score = map['score'];
  //   // regQuestList = List<String>.from(map['regQuestList']);
  //   // acceptQuestList = List<String>.from(map['acceptQuestList']);
  //   // completedQuestList = List<String>.from(map['completedQuestList']);
  //   // favoriteBikers = List<String>.from(map['favoriteBikers']);
  //   profileImg = map['profileImg'];
  // }

  User.fromJson(Map<String, dynamic> map)
      : uid = map['uid'],
        role = map['role'] ?? 0,
        service = map['service'] != null ? getEnumServiceTypeByString(map['service']) : eService.NONE,
        serviceCodec = map['serviceCodec'] ?? false,
        nick = map['nick'] ?? 'nobody',
        email = map['email'],
        score = map['score'],
        guildPoint = map['guildPoint'] ?? 0,
        agit = map['agit'] ?? 0,
        bikeBrand = map['bikeBrand'] ?? 0,
        bikeModel = map['bikeModel'] ?? 0,
        avatar = map['avatar'] ?? '',
        roadSignUrl = map['roadSignUrl'] ?? '',
        roadSignFile = map['roadSignFile'] ?? '',
        youtubeUrl = map['youtube'] ?? '',
        instagram = map['instagram'] ?? '',
        createdTime = map['createdTime'] != null ? DateTime.parse(map['createdTime']) : DateTime.now(),
        lastLoginTime = map['lastLoginTime'] != null ? DateTime.parse(map['lastLoginTime']) : DateTime.now();

  getAvatarImg() {
    if (avatar.isEmpty) {
      return const AssetImage(
        'assets/icons/nobody_avatar3.png',
        // fit: BoxFit.cover,
        // width: 90,
        // height: 90,
      );
    }

    return NetworkImage(
      avatar,
      // fit: BoxFit.cover,
      // width: 90,
      // height: 90,
    );
  }
}

getEnumServiceTypeByString(str) {
  return eService.values.firstWhereOrNull((e) => e.toString() == 'eService.' + str) ?? eService.NONE;
  // return eQuestType.cafe;
}

enum EQUIP_TYPE {
  bike,
  bikeYear,
  helmet,
  jacket,
  pants,
  glove,
  shoes,
  backpack,
}

getEquipTypeText(index) {
  switch (index) {
    case EQUIP_TYPE.bike:
      return '바이크 종류';
    case EQUIP_TYPE.bikeYear:
      return '바이크 년식';
    case EQUIP_TYPE.helmet:
      return '헬멧';
    case EQUIP_TYPE.jacket:
      return '자켓';
    case EQUIP_TYPE.pants:
      return '바지';
    case EQUIP_TYPE.glove:
      return '장갑';
    case EQUIP_TYPE.shoes:
      return '신발';
    case EQUIP_TYPE.backpack:
      return '가방';
  }
}

