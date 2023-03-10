class MyNpc {
  int idx;
  int nid;

  MyNpc.fromJson(Map<String, dynamic> map)
      : idx = map['idx'],
        nid = map['nid'];
}
