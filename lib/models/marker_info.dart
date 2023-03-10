import 'package:get/get.dart';

enum eMarkerType {
  QUEST,
  NPC,

}
getEnumTypeByString(str) {
  return eMarkerType.values.firstWhereOrNull((e) => e.toString() == 'eMarkerType.' + str) ?? eMarkerType.NPC;
}

class MarkerInfo {
  eMarkerType type; //0: quest 1: npc
  int id;
  double lat;
  double lng;
  String title;

  MarkerInfo.fromMap(Map<String, dynamic> map)
      : type = getEnumTypeByString(map['type']),
        id = map['id'],
        lat = map['lat'],
        lng = map['lng'],
        title = map['title'];

  MarkerInfo.fromQuest(Map<String, dynamic> map)
      : type = eMarkerType.QUEST,
        id = map['qid'],
        lat = map['lat'],
        lng = map['lng'],
        title = map['name'];

  MarkerInfo.fromNpc(Map<String, dynamic> map)
      : type = eMarkerType.QUEST,
        id = map['nid'],
        lat = map['lat'],
        lng = map['lng'],
        title = map['name'];


  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'id': id,
      'lat': lat,
      'lng': lng,
      'title': title,
    };
  }
}
