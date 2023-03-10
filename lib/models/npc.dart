import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

enum eNpcType {
  STORE,
  BRAND,
  ENGINE,
  WEBSTORE,
  FOOD,
  CAMPING,
  ACADEMY,
  ASSIST,
}

getEnumNpcTypeByString(str) {
  return eNpcType.values.firstWhereOrNull((e) => e.toString() == 'eNpcType.' + str) ?? eNpcType.STORE;
  // return eQuestType.cafe;
}

getEnumNpcType(int i) {
  switch (i) {
    case 1:
      return eNpcType.BRAND;
    case 2:
      return eNpcType.ENGINE;
    case 3:
      return eNpcType.WEBSTORE;
    case 4:
      return eNpcType.FOOD;
    case 5:
      return eNpcType.CAMPING;
    case 6:
      return eNpcType.ACADEMY;
    case 7:
      return eNpcType.ASSIST;
    default:
      return eNpcType.STORE;
  }
}

getNpcTypeText(int index) {
  switch (index) {
    case 1:
      return '브랜드샵';
    case 2:
      return '튜닝샵';
    case 3:
      return '웹 스토어';
    case 4:
      return '맛집';
    case 5:
      return '캠핑';
    case 6:
      return '아카데미';
    case 7:
      return '어시스트';
    default:
      return '장비 상점';
  }
}

getNpcIcon(int index, {size, color}) {
  switch (index) {
    case 0:
      return Icon(
        Icons.local_grocery_store_rounded,
        size: size ?? 17,
        color: color ?? UNSELECTED_ICONS_COLOR,
      );
    case 1:
      return Icon(
        Icons.local_offer_rounded,
        size: size ?? 17,
        color: color ?? UNSELECTED_ICONS_COLOR,
      );
    case 2:
      return Icon(
        //
        Icons.engineering_rounded,
        size: size ?? 17,
        color: color ?? UNSELECTED_ICONS_COLOR,
      );
    case 3:
      return Icon(
        Icons.language_rounded,
        size: size ?? 17,
        color: color ?? UNSELECTED_ICONS_COLOR,
      );
    case 4:
      return Icon(
        Icons.local_dining_rounded,
        size: size ?? 17,
        color: color ?? UNSELECTED_ICONS_COLOR,
      );
    case 5:
      return ImageIcon(
        AssetImage('assets/icons/camping2.png'),
        size: size != null ? size : 17,
        color: color != null ? color : UNSELECTED_ICONS_COLOR,
      );
    case 6:
      return const FaIcon(FontAwesomeIcons.graduationCap,
          color: Colors.grey, size: 15);
    case 7:
      return const FaIcon(FontAwesomeIcons.truck,
          color: Colors.grey, size: 15);
    default:
      return Icons.question_answer_rounded;
  }
  switch (index) {
    case 1:
      return Icons.local_grocery_store_rounded;
    case 2:
      return Icons.engineering_rounded;
    case 3:
      return Icons.language_rounded;
    default:
      return Icons.question_answer_rounded;
  }
}

class Npc {
  int nid;
  String name;
  String location;
  User? writer;
  int area;
  int city;
  double lat;
  double lng;
  eNpcType type;
  DateTime createdTime;
  String youtubeUrl;
  String instagram;
  String webUrl;
  String thumbnail;
  String pictureHelp;
  // List<String> pictures = [];
  List<PictureImage> pictures = [];

  Npc.fromJson(Map<String, dynamic> map)
      : nid = map['nid'],
        name = map['name'],
        location = map['location'],
        area = map['area'],
        city = map['city'],
        lat = map['lat'],
        lng = map['lng'],
        type = getEnumNpcTypeByString(map['type']),
        createdTime = DateTime.parse(map['createdTime']),
        youtubeUrl = map['youtubeUrl'] ?? '',
        instagram = map['instagram'] ?? '',
        webUrl = map['webUrl'] ?? '',
        thumbnail = map['thumbnail'] ?? '',
        pictureHelp = map['pictureHelp'] ?? '';

  // pictures = List<String>.from(map['pictures']);

  Map<String, dynamic> toJson() {
    return {
      'nid': nid,
      'uid': writer!.uid,
      'name': name,
      'location': location,
      'area': area,
      'city': city,
      'lat': lat,
      'lng': lng,
      'type': type.name,
      'youtubeUrl': youtubeUrl,
      'instagram': instagram,
      'webUrl': webUrl,
      'thumbnail': thumbnail,
      'pictureHelp': pictureHelp,
    };
  }
}
