class Agit {
  int qid;
  String name;

  Agit.fromJson(Map<String, dynamic> map)
      : qid = map['qid'],
        name = map['name'];
}
