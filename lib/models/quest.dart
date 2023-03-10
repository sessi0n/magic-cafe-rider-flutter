import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum eParkingSize {
  nothing,
  sidewalk, //10대 이하
  parking, //20대 이하
  hard //20대 이상
}

getEnumParkingSize(int i) {
  switch (i) {
    case 0:
      return eParkingSize.nothing;
    case 1:
      return eParkingSize.sidewalk;
    case 2:
      return eParkingSize.parking;
    case 3:
      return eParkingSize.hard;
  }
}

getParkingSizeText(int size) {
  switch (size) {
    case 0:
      return '주차시설 없음';
    case 1:
      return '보도블럭 사이드 주차';
    case 2:
      return '주차시설 있음';
    case 3:
      return '알아서 주차해야함';
  }
}

enum eQuestType {
  CAFE,
  FOOD,
  CAMPING,
  POINT,
}

enum eSortType {
  COMPLETE_COUNT,
  NEW,
}

getEnumQuestTypeByString(str) {
  return eQuestType.values.firstWhereOrNull((e) => e.toString() == 'eQuestType.' + str) ?? eSortType.NEW;
  // return eQuestType.cafe;
}

getEnumQuestType(int i) {
  switch (i) {
    case 0:
      return eQuestType.CAFE;
    case 1:
      return eQuestType.FOOD;
    case 2:
      return eQuestType.CAMPING;
    case 3:
      return eQuestType.POINT;
  }
}

getQuestTypeText(int index) {
  switch (index) {
    case 0:
      return '카페';
    case 1:
      return '맛집';
    case 2:
      return '캠핑';
    case 3:
      return '로드';
  }
}

/*
                                Icon(
                                  getQuestIcon(attr.type.index),
                                  size: 17,
                                  color: UNSELECTED_ICONS_COLOR,
                                ),
 */
getQuestIcon(int index, {size, color}) {
  switch (index) {
    case 0:
      return Icon(
        Icons.local_cafe_rounded,
        size: size != null ? size : 17,
        color: color != null ? color : UNSELECTED_ICONS_COLOR,
      );
    case 1:
      return Icon(
        Icons.local_dining_rounded,
        size: size != null ? size : 17,
        color: color != null ? color : UNSELECTED_ICONS_COLOR,
      );
    case 2:
      return ImageIcon(
        //
        AssetImage('assets/icons/camping2.png'),
        size: size != null ? size : 17,
        color: color != null ? color : UNSELECTED_ICONS_COLOR,
      );
    case 3:
      return Icon(
        Icons.location_on_rounded,
        size: size != null ? size : 17,
        color: color != null ? color : UNSELECTED_ICONS_COLOR,
      );
    default:
      return Icons.question_answer_rounded;
  }
}

class Quest {
  int qid;
  String uid;
  String name;
  String location;
  User? writer;
  int area;
  int city;
  eQuestType type;
  double lat;
  double lng;
  // bool isInGuild;
  int acceptCount;
  int completeCount;
  int level;
  DateTime createdTime;
  String youtubeUrl;
  String instagram;
  String thumbnail;
  String pictureHelp;
  List<PictureImage> questImages = [];
  String ownerWord = '';

  Quest.fromJson(Map<String, dynamic> map)
      : qid = map['qid'],
        uid = map['uid'],
        name = map['name'],
        location = map['location'],
        area = map['area'],
        city = map['city'],
        type = getEnumQuestTypeByString(map['type']),
        lat = map['lat'],
        lng = map['lng'],
        acceptCount = map['acceptCount'],
        completeCount = map['completeCount'],
        level = map['level'],
        youtubeUrl = map['youtubeUrl'] ?? '',
        instagram = map['instagram'] ?? '',
        thumbnail = map['thumbnail'] ?? '',
        pictureHelp = map['pictureHelp'] ?? '',
        ownerWord = map['ownerWord'] ?? '',
        createdTime = DateTime.parse(map['createdTime']);

  Map<String, dynamic> toJson() {
    return {
      'qid': qid,
      'uid' : uid,
      'name': name,
      'location': location,
      // 'writer': writer,
      'area': area,
      'city': city,
      'type': type.name,
      'lat': lat,
      'lng': lng,
      'youtubeUrl': youtubeUrl,
      'instagram': instagram,
      'thumbnail': thumbnail,
      'pictureHelp': pictureHelp,
    };
  }

  getThumbnail() {
    if (thumbnail.isEmpty) {
      return 'https://images.pexels.com/photos/2317408/pexels-photo-2317408.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940';
    }

    return thumbnail;
  }
}
