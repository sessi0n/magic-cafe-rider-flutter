

class Owner {
  String uid;
  int qid;
  String word;
  DateTime created;
  // bool deleted = false;

  Owner.fromJson(Map<String, dynamic> map)
      : uid = map['uid'],
        qid = map['qid'],
        word = map['word'],
        created = DateTime.parse(map['created']);

}
