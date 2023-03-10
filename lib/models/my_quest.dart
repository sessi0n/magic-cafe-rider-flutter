class MyQuest {
  int idx;
  int qid;

  MyQuest.fromJson(Map<String, dynamic> map)
      : idx = map['idx'],
        qid = map['qid'];
}
