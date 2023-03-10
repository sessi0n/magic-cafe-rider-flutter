class Sale {
  int sid;
  String uid;
  String title;
  String url;
  String imgUrl;
  DateTime start;
  DateTime end;
  DateTime created;
  bool deleted;

  Sale.fromJson(Map<String, dynamic> map)
      : sid = map['sid'],
        uid = map['uid'],
        title = map['title'],
        url = map['url'],
        imgUrl = map['imgUrl'],
        start = DateTime.parse(map['start']),
        end = DateTime.parse(map['end']),
        created = DateTime.parse(map['created']),
        deleted = map['deleted'];
}
