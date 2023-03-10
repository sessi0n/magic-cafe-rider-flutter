import 'package:get/get.dart';

enum eFootType {
  NORMAL,
  EVENT,
  COMPLETED,
}
getEnumFootTypeByString(str) {
  return eFootType.values.firstWhereOrNull((e) => e.toString() == 'eFootType.' + str) ?? eFootType.NORMAL;
}

class FootPrintLog {
  int qid;
  eFootType type;
  String name;
  DateTime date;
  bool can;

  FootPrintLog.fromJson(Map<String, dynamic> map)
      : qid = map['qid'],
        type = getEnumFootTypeByString(map['type']),
        name = map['name'],
        can = map['can'],
        date = DateTime.parse(map['date']);

  // FootPrintLog.fromJsonUserQuest(Map<String, dynamic> map)
  //     : qid = map['qid'],
  //       type = eFootType.COMPLETE,
  //       name = map['name'],
  //       date = map['completedDate'];
}
