class CityMap {
  int code;
  String name;

  CityMap.fromJson(Map<String, dynamic> map)
      : code = map['code'],
        name = map['name'];
}

class AreaMap {
  int code;
  String name;
  List<CityMap> city;

  AreaMap.fromJson(Map<String, dynamic> map)
      : code = map['code'],
        name = map['name'],
        city = List<CityMap>.from(map['city']);


}

var CITY_SEOUL = [
  CityMap.fromJson({'code': 1, 'name': '강남구'}),
  CityMap.fromJson({'code': 2, 'name': '강동구'}),
  CityMap.fromJson({'code': 3, 'name': '강북구'}),
  CityMap.fromJson({'code': 4, 'name': '강서구'}),
  CityMap.fromJson({'code': 5, 'name': '관악구'}),
  CityMap.fromJson({'code': 6, 'name': '광진구'}),
  CityMap.fromJson({'code': 7, 'name': '구로구'}),
  CityMap.fromJson({'code': 8, 'name': '금천구'}),
  CityMap.fromJson({'code': 9, 'name': '노원구'}),
  CityMap.fromJson({'code': 10, 'name': '도봉구'}),
  CityMap.fromJson({'code': 11, 'name': '동대문구'}),
  CityMap.fromJson({'code': 12, 'name': '동작구'}),
  CityMap.fromJson({'code': 13, 'name': '마포구'}),
  CityMap.fromJson({'code': 14, 'name': '서대문구'}),
  CityMap.fromJson({'code': 15, 'name': '서초구'}),
  CityMap.fromJson({'code': 16, 'name': '성동구'}),
  CityMap.fromJson({'code': 17, 'name': '성북구'}),
  CityMap.fromJson({'code': 18, 'name': '송파구'}),
  CityMap.fromJson({'code': 19, 'name': '양천구'}),
  CityMap.fromJson({'code': 20, 'name': '영등포구'}),
  CityMap.fromJson({'code': 21, 'name': '용산구'}),
  CityMap.fromJson({'code': 22, 'name': '은평구'}),
  CityMap.fromJson({'code': 23, 'name': '종로구'}),
  CityMap.fromJson({'code': 24, 'name': '중구'}),
  CityMap.fromJson({'code': 25, 'name': '중랑구'}),

];

var CITY_INCHEON = [
  CityMap.fromJson({'code': 1, 'name': '강화군'}),
  CityMap.fromJson({'code': 2, 'name': '계양구'}),
  CityMap.fromJson({'code': 3, 'name': '미추홀구'}),
  CityMap.fromJson({'code': 4, 'name': '남동구'}),
  CityMap.fromJson({'code': 5, 'name': '동구'}),
  CityMap.fromJson({'code': 6, 'name': '부평구'}),
  CityMap.fromJson({'code': 7, 'name': '서구'}),
  CityMap.fromJson({'code': 8, 'name': '연수구'}),
  CityMap.fromJson({'code': 9, 'name': '옹진군'}),
  CityMap.fromJson({'code': 10, 'name': '중구'}),
];
var CITY_DAEJEON = [
  CityMap.fromJson({'code': 1, 'name': '대덕구'}),
  CityMap.fromJson({'code': 2, 'name': '동구'}),
  CityMap.fromJson({'code': 3, 'name': '서구'}),
  CityMap.fromJson({'code': 4, 'name': '유성구'}),
  CityMap.fromJson({'code': 5, 'name': '중구'}),
];
var CITY_DAEGU = [
  CityMap.fromJson({'code': 1, 'name': '남구'}),
  CityMap.fromJson({'code': 2, 'name': '달서구'}),
  CityMap.fromJson({'code': 3, 'name': '달성군'}),
  CityMap.fromJson({'code': 4, 'name': '동구'}),
  CityMap.fromJson({'code': 5, 'name': '북구'}),
  CityMap.fromJson({'code': 6, 'name': '서구'}),
  CityMap.fromJson({'code': 7, 'name': '수성구'}),
  CityMap.fromJson({'code': 8, 'name': '중구'}),
];
var CITY_GWANGJU = [
  CityMap.fromJson({'code': 1, 'name': '광산구'}),
  CityMap.fromJson({'code': 2, 'name': '남구'}),
  CityMap.fromJson({'code': 3, 'name': '동구'}),
  CityMap.fromJson({'code': 4, 'name': '북구'}),
  CityMap.fromJson({'code': 5, 'name': '서구'}),
];
var CITY_BUSAN = [
  CityMap.fromJson({'code': 1, 'name': '강서구'}),
  CityMap.fromJson({'code': 2, 'name': '금정구'}),
  CityMap.fromJson({'code': 3, 'name': '기장군'}),
  CityMap.fromJson({'code': 4, 'name': '남구'}),
  CityMap.fromJson({'code': 5, 'name': '동구'}),
  CityMap.fromJson({'code': 6, 'name': '동래구'}),
  CityMap.fromJson({'code': 7, 'name': '부산진구'}),
  CityMap.fromJson({'code': 8, 'name': '북구'}),
  CityMap.fromJson({'code': 9, 'name': '사상구'}),
  CityMap.fromJson({'code': 10, 'name': '사하구'}),
];
var CITY_ULSAN = [
  CityMap.fromJson({'code': 1, 'name': '중구'}),
  CityMap.fromJson({'code': 2, 'name': '남구'}),
  CityMap.fromJson({'code': 3, 'name': '동구'}),
  CityMap.fromJson({'code': 4, 'name': '북구'}),
  CityMap.fromJson({'code': 5, 'name': '울주군'}),
];
var CITY_SEJONG = [];
var CITY_GYEONGGI = [
  CityMap.fromJson({'code': 1, 'name': '가평군'}),
  CityMap.fromJson({'code': 2, 'name': '고양시'}),
  CityMap.fromJson({'code': 3, 'name': '과천시'}),
  CityMap.fromJson({'code': 4, 'name': '광명시'}),
  CityMap.fromJson({'code': 5, 'name': '광주시'}),
  CityMap.fromJson({'code': 6, 'name': '구리시'}),
  CityMap.fromJson({'code': 7, 'name': '군포시'}),
  CityMap.fromJson({'code': 8, 'name': '김포시'}),
  CityMap.fromJson({'code': 9, 'name': '남양주시'}),
  CityMap.fromJson({'code': 10, 'name': '수원시'}),
];

var CITY_CHUNGBUK = [];
var CITY_CHUNGNAM = [];
var CITY_JEONBUK = [];
var CITY_JEONNAM = [];
var CITY_GYEONGBUK = [];
var CITY_GYEONGNAM = [];
var CITY_JEJU = [];

var CITY_GANGWON = [
  CityMap.fromJson({'code': 1, 'name': '강릉시'}),
  CityMap.fromJson({'code': 2, 'name': '고성군'}),
  CityMap.fromJson({'code': 3, 'name': '동해시'}),
  CityMap.fromJson({'code': 4, 'name': '삼척시'}),
  CityMap.fromJson({'code': 5, 'name': '속초시'}),
  CityMap.fromJson({'code': 6, 'name': '양구군'}),
  CityMap.fromJson({'code': 7, 'name': '양양군'}),
  CityMap.fromJson({'code': 8, 'name': '영월군'}),
  CityMap.fromJson({'code': 9, 'name': '원주시'}),
  CityMap.fromJson({'code': 10, 'name': '인제군'}),
];


List<AreaMap> AREA_MAP = [
  AreaMap.fromJson({'code': 1, 'name': '서울', 'city': CITY_SEOUL}),
  AreaMap.fromJson({'code': 2, 'name': '인천', 'city': CITY_INCHEON}),
  AreaMap.fromJson({'code': 3, 'name': '대전', 'city': CITY_DAEJEON}),
  AreaMap.fromJson({'code': 4, 'name': '대구', 'city': CITY_DAEGU}),
  AreaMap.fromJson({'code': 5, 'name': '광주', 'city': CITY_GWANGJU}),
  AreaMap.fromJson({'code': 6, 'name': '부산', 'city': CITY_BUSAN}),
  AreaMap.fromJson({'code': 7, 'name': '울산', 'city': CITY_ULSAN}),
  AreaMap.fromJson({'code': 8, 'name': '세종', 'city': CITY_SEJONG}),
  AreaMap.fromJson({'code': 31, 'name': '경기', 'city': CITY_GYEONGGI}),
  AreaMap.fromJson({'code': 32, 'name': '강원', 'city': CITY_GANGWON}),
  AreaMap.fromJson({'code': 33, 'name': '충북', 'city': CITY_CHUNGBUK}),
  AreaMap.fromJson({'code': 34, 'name': '충남', 'city': CITY_CHUNGNAM}),
  AreaMap.fromJson({'code': 35, 'name': '전북', 'city': CITY_JEONBUK}),
  AreaMap.fromJson({'code': 36, 'name': '전남', 'city': CITY_JEONNAM}),
  AreaMap.fromJson({'code': 37, 'name': '경북', 'city': CITY_GYEONGBUK}),
  AreaMap.fromJson({'code': 38, 'name': '경남', 'city': CITY_GYEONGNAM}),
  AreaMap.fromJson({'code': 39, 'name': '제주', 'city': CITY_JEJU}),
];



// getAreaCityText(int area, int city) {
//   var add1 = AREA_MAP.where((element) => element.code == area);
//
//   if (add1.isEmpty) {
//     return '지역 없음';
//   } else {
//     var add2 = (add1.first.city as List<dynamic>)
//         .where((element) => element.code == city);
//
//     if (add2.isEmpty) {
//       return add1.first.name;
//     } else {
//       return '${add1.first.name} / ${add2.first.name}';
//     }
//   }
// }
