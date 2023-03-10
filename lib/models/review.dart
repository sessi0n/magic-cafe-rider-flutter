import 'package:bike_adventure/models/user.dart';

class Review {
  int rid;
  int qid;
  String uid;
  String context;
  DateTime createdTime;
  // bool deleted = false;
  User? reviewer;

  Review.fromJson(Map<String, dynamic> map)
      : rid = map['rid'],
        qid = map['qid'],
        uid = map['uid'],
        context = map['context'],
        createdTime = DateTime.parse(map['createdTime']);

}
