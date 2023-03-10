class KakaoMap {
  String address_name;
  String category_group_code;
  String category_group_name;
  String category_name;
  String? distance;
  String id;
  String phone;
  String place_name;
  String? place_url;
  String road_address_name;
  double x; //lng
  double y; //lat

  KakaoMap.fromJson(Map<String, dynamic> map)
      : address_name = map['address_name'],
        category_group_code = map['category_group_code'],
        category_group_name = map['category_group_name'],
        category_name = map['category_name'],
        distance = map['distance'],
        id = map['id'],
        phone = map['phone'],
        place_name = map['place_name'],
        place_url = map['place_url'],
        road_address_name = map['road_address_name'],
        x = double.parse(map['x']),
        y = double.parse(map['y']);

  Map<String, dynamic> toJson() {
    return {
      'address_name': address_name,
      'category_group_code': category_group_code,
      'category_group_name': category_group_name,
      'category_name': category_name,
      'distance': distance,
      'id': id,
      'phone': phone,
      'place_name': place_name,
      'place_url': place_url,
      'road_address_name': road_address_name,
      'x': x,
      'y': y,
    };
  }
}
