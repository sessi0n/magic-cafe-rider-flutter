import 'package:get/get.dart';

var temp = [
  {'code': 1, 'bike': ''},
  {'code': 2, 'bike': ''},
  {'code': 3, 'bike': ''},
  {'code': 4, 'bike': ''},
  {'code': 5, 'bike': ''},
  {'code': 6, 'bike': ''},
  {'code': 7, 'bike': ''},
  {'code': 8, 'bike': ''},
  {'code': 9, 'bike': ''},
  {'code': 10, 'bike': ''},
  {'code': 11, 'bike': ''},
  {'code': 12, 'bike': ''},
  {'code': 13, 'bike': ''},
  {'code': 14, 'bike': ''},
  {'code': 15, 'bike': ''},
  {'code': 16, 'bike': ''},
  {'code': 17, 'bike': ''},
  {'code': 18, 'bike': ''},
  {'code': 19, 'bike': ''},
  {'code': 20, 'bike': ''},
];
var DAELIM = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'UCR100'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'M BOY'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'XQ250'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'VF100P'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'CB115'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': '뉴시티 100'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': '데이스타 125'}),
];
var YAMAHA = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'YZF-R1'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'YZF-R7'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'YZF-R3'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'NIKEN'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'MT-09'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'MT-07'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'MT-03'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'XT1200ZE'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'TRACER 9'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'MAXAM250'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'T-MAX'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'N-MAX'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'X-MAX'}),
];
var HONDA = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'BENLY110'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'SCR110α'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'Super Cub'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'Honda Vision'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'Monkey125'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'C125'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'PCX'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'MSX Grom'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'CB125R'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'CB300R'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'CRF300L'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'FORZA350'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'Revel 500'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'CB500X'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'CB500F'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'CBR500R'}),
  BrandMotoBrandMoto.fromJson({'code': 17, 'bike': 'CBR650R'}),
  BrandMotoBrandMoto.fromJson({'code': 18, 'bike': 'CB650R'}),
  BrandMotoBrandMoto.fromJson({'code': 19, 'bike': 'FORZA750'}),
  BrandMotoBrandMoto.fromJson({'code': 20, 'bike': 'X-ADV'}),
  BrandMotoBrandMoto.fromJson({'code': 21, 'bike': 'CB1000R'}),
  BrandMotoBrandMoto.fromJson({'code': 22, 'bike': 'CBR1000RR-R'}),
  BrandMotoBrandMoto.fromJson({'code': 23, 'bike': 'CRF1100L'}),
  BrandMotoBrandMoto.fromJson({'code': 24, 'bike': 'Gold Wing'}),
  BrandMotoBrandMoto.fromJson({'code': 25, 'bike': 'CBR650F'}),
];
var KAWASAKI = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'Ninja H2'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'Ninja ZX-10R'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'Ninja ZX-6R'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'Ninja 650'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'Z H2'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'Z900'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'Ninja H2 SX SE+'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'Ninja 1000SX'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'Versys 1000 SE'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'Z900RS'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'W800'}),
];
var SUZUKI = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'GSX-R1000/R'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'GSX-R125'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'KATANA'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'GSX-S1000GT'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'GSX-S1000'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'SV650X'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'SV650'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'GSX-S125'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'V-STROM1050XT'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'V-STROM650XT'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'V-STROM250'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'BURGMAN400 COUPE'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'BURGMAN200'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'BURGMAN125'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'SWISH125'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'ADDRESS125'}),
  BrandMotoBrandMoto.fromJson({'code': 17, 'bike': 'HAYABUSA'}),
];
var DUCATI = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'Diavel 1260'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'Diavel 1260 S'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'XDiavel Black Star'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'Hypermotard 950 SP'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'Hypermotard 950 RVE'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'Monster'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'Multistrada 950 S'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'Multistrada V4 S'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'Panigale V2'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'Panigale V4'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'Panigale V4 S'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'Panigale V4 R'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'Supersport 950 S'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'STREETFIGHTER V4'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'STREETFIGHTER V4 S'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'Icon Dark'}),
  BrandMotoBrandMoto.fromJson({'code': 17, 'bike': 'Icon'}),
  BrandMotoBrandMoto.fromJson({'code': 18, 'bike': 'Full Throttle'}),
  BrandMotoBrandMoto.fromJson({'code': 19, 'bike': 'Café Racer'}),
  BrandMotoBrandMoto.fromJson({'code': 20, 'bike': 'Desert Sled'}),
  BrandMotoBrandMoto.fromJson({'code': 21, 'bike': '1100'}),
  BrandMotoBrandMoto.fromJson({'code': 22, 'bike': '1100 Special'}),
  BrandMotoBrandMoto.fromJson({'code': 23, 'bike': '1100 Sport'}),
];
var KTM = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': '1290 SUPER DUKE'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': '890 DUKE'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': '390 DUKE'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': '1290 SUPER ADVENTURE'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': '890 ADVENTURE'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': '390 ADVENTURE'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': '690 ENDURO'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'RC 390'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': '450 SMR'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': '690 SMC'}),
];
var HARLEY_DAVIDSON = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'Sportster® S'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'Softail Standard™'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'Street Bob® 114'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'Heritage Classic 114'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'Sport Glide™'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'Fat Bob™ 114'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'Breakout™ 114'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'Fat Boy™ 114'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'Low Rider™ S'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'Low Rider™ ST'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'Pan America™ 1250'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'Street Glide™'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'Road Glide™'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'Road King™'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'CVO™ Road Glide™'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'CVO™ Street Glide™'}),
];
var TRIUMPH = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'TIGER SPORT 660'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'TIGER 900'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'TIGER 1200'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'TRIDENT 660'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'STREET TRIPLE'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'SPEED TRIPLE 1200 RS'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'SPEED TRIPLE 1200 RR'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'STREET TWIN'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'BONNEVILLE T100'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'STREET SCRAMBLER'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'BONNEVILLE T120'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'SPEED TWIN'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'SCRAMBLER 1200'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'BONNEVILLE SPEEDMASTER'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'BONNEVILLE BOBBER'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'THRUXTON RS'}),
  BrandMotoBrandMoto.fromJson({'code': 17, 'bike': 'ROCKET 3'}),
];
var ROYAL_ENFIELD = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'Classic 350'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'Meteor'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'Himalayan'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'Interceptor'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'Continental GT'}),
];
var BMW = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'R 1250 RS'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'M 1000 RR'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'S 1000 RR'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'K 1600 GTL'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'K 1600 GT'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'K 1600 GA'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'K 1600 B'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'R 1250 RT'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'R 1250 R'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'S 1000 R'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'F 900 R'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'G 310 R'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'R 18'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'R 18 Classic'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'R 18 B'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'R 18 Transcontinental'}),
  BrandMotoBrandMoto.fromJson({'code': 17, 'bike': 'R nineT'}),
  BrandMotoBrandMoto.fromJson({'code': 18, 'bike': 'R nineT Pure'}),
  BrandMotoBrandMoto.fromJson({'code': 19, 'bike': 'R nineT Scrambler'}),
  BrandMotoBrandMoto.fromJson({'code': 20, 'bike': 'R nineT Urban G/S'}),
  BrandMotoBrandMoto.fromJson({'code': 21, 'bike': 'R 1250 GS Adventure'}),
  BrandMotoBrandMoto.fromJson({'code': 22, 'bike': 'R 1250 GS'}),
  BrandMotoBrandMoto.fromJson({'code': 23, 'bike': 'S 1000 XR'}),
  BrandMotoBrandMoto.fromJson({'code': 24, 'bike': 'F 900 XR'}),
  BrandMotoBrandMoto.fromJson({'code': 25, 'bike': 'F 850 GS Adventure'}),
  BrandMotoBrandMoto.fromJson({'code': 26, 'bike': 'F 850 GS'}),
  BrandMotoBrandMoto.fromJson({'code': 27, 'bike': 'F 750 GS'}),
  BrandMotoBrandMoto.fromJson({'code': 28, 'bike': 'G 310 GS'}),
  BrandMotoBrandMoto.fromJson({'code': 29, 'bike': 'C 400 X'}),
  BrandMotoBrandMoto.fromJson({'code': 30, 'bike': 'C 400 GT'}),
];
var MV_AGUSTA = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'RUSH 1000'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'SUPERVELOCE S'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'SUPERVELOCE 800'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'BRUTALE 1000 RR'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': 'BRUTALE 1000 RS'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': 'BRUTALE RR SCS'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': 'BRUTALE RR'}),
  BrandMotoBrandMoto.fromJson({'code': 8, 'bike': 'DRAGSTER RR'}),
  BrandMotoBrandMoto.fromJson({'code': 9, 'bike': 'DRAGSTER RR SCS'}),
  BrandMotoBrandMoto.fromJson({'code': 10, 'bike': 'DRAGSTER RC SCS'}),
  BrandMotoBrandMoto.fromJson({'code': 11, 'bike': 'TURISMO VELOCE ROSSO'}),
  BrandMotoBrandMoto.fromJson({'code': 12, 'bike': 'TURISMO VELOCE LOSSO SCS'}),
  BrandMotoBrandMoto.fromJson({'code': 13, 'bike': 'TURISMO VELOCE ROSSO'}),
  BrandMotoBrandMoto.fromJson({'code': 14, 'bike': 'F3 675'}),
  BrandMotoBrandMoto.fromJson({'code': 15, 'bike': 'F3 800'}),
  BrandMotoBrandMoto.fromJson({'code': 16, 'bike': 'F3 800 RC'}),
];
var MOTO_GUZZI = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'V7 III'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'V7 II'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'V9'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'Audace'}),
];
var APRILIA = [];
var BENELLI = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'TNT125'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': '502C'}),
  BrandMotoBrandMoto.fromJson({'code': 3, 'bike': 'RKF125'}),
  BrandMotoBrandMoto.fromJson({'code': 4, 'bike': 'TRK502X'}),
  BrandMotoBrandMoto.fromJson({'code': 5, 'bike': '레온치노500'}),
  BrandMotoBrandMoto.fromJson({'code': 6, 'bike': '레온치노250'}),
  BrandMotoBrandMoto.fromJson({'code': 7, 'bike': '임페리알레400'}),
];

var ITALJET = [
  BrandMotoBrandMoto.fromJson({'code': 1, 'bike': 'GRIFON125'}),
  BrandMotoBrandMoto.fromJson({'code': 2, 'bike': 'GRIFON400'}),
];

var UNKNOWN = [
  BrandMotoBrandMoto.fromJson({'code': 0, 'bike': '바이크를 선택해주세요'}),
];
class BrandMotoBrandMoto {
  int code;
  String bike;
  BrandMotoBrandMoto.fromJson(Map<String, dynamic> map)
      : code = map['code'],
        bike = map['bike'];

}

class Motorcycle {
  int code;
  String name;
  List<BrandMotoBrandMoto> bikes;
  Motorcycle.fromJson(Map<String, dynamic> map)
      : code = map['code'],
        name = map['name'],
        bikes = List<BrandMotoBrandMoto>.from(map['bikes']);
}

var Motorcycles = [
  Motorcycle.fromJson({'code': 0, 'name': '브랜드를 선택해주세요', 'bikes': UNKNOWN}),
  Motorcycle.fromJson({'code': 1, 'name': 'DAELIM', 'bikes': DAELIM}),
  Motorcycle.fromJson({'code': 2, 'name': 'YAMAHA', 'bikes': YAMAHA}),
  Motorcycle.fromJson({'code': 3, 'name': 'HONDA', 'bikes': HONDA}),
  Motorcycle.fromJson({'code': 4, 'name': 'KAWASAKI', 'bikes': KAWASAKI}),
  Motorcycle.fromJson({'code': 5, 'name': 'SUZUKI', 'bikes': SUZUKI}),
  Motorcycle.fromJson({'code': 6, 'name': 'DUCATI', 'bikes': DUCATI}),
  Motorcycle.fromJson({'code': 7, 'name': 'KTM', 'bikes': KTM}),
  Motorcycle.fromJson({'code': 8, 'name': 'HARLEY-DAVIDSON', 'bikes': HARLEY_DAVIDSON}),
  Motorcycle.fromJson({'code': 9, 'name': 'TRIUMPH', 'bikes': TRIUMPH}),
  Motorcycle.fromJson({'code': 10, 'name': 'ROYAL-ENFIELD', 'bikes': ROYAL_ENFIELD}),
  Motorcycle.fromJson({'code': 11, 'name': 'BMW', 'bikes': BMW}),
  Motorcycle.fromJson({'code': 12, 'name': 'MV-AGUSTA', 'bikes': MV_AGUSTA}),
  Motorcycle.fromJson({'code': 13, 'name': 'MOTO-GUZZI', 'bikes': MOTO_GUZZI}),
  Motorcycle.fromJson({'code': 14, 'name': 'BENELLI', 'bikes': BENELLI}),
  // {'code': 15, 'name': 'APRILIA', 'bikes': APRILIA},
  Motorcycle.fromJson({'code': 16, 'name': 'ITALJET', 'bikes': ITALJET}),
];

String getBikeText(iBikeBrand, iBikeModel) {
  Motorcycle? myMoto = Motorcycles
      .firstWhereOrNull((element) => element.code == iBikeBrand);
  if (myMoto != null && myMoto.code != 0) {
    BrandMotoBrandMoto? motoBike = myMoto.bikes
        .firstWhereOrNull((element) => element.code == iBikeModel);
    if (motoBike != null && motoBike.code != 0) {
      return '${myMoto.name} ${motoBike.bike}';
    }

    return myMoto.name;
  }
  return 'NOT-SET';
}
