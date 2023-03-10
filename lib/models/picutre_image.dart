class PictureImage {
  int idx;
  int id;
  String imgUrl;
  String imgFile;
  String pictureUrl = '';

  PictureImage.fromJsonQuest(Map<String, dynamic> map)
      : idx = map['idx'],
        id = map['qid'],
        imgUrl = map['imgUrl'],
        imgFile = map['imgFile'];

  PictureImage.fromJsonNpc(Map<String, dynamic> map)
      : idx = map['idx'],
        id = map['nid'],
        imgUrl = map['imgUrl'],
        imgFile = map['imgFile'];
}
