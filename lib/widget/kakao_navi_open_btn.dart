

import 'package:bike_adventure/widget/kakao_sdk_with.dart';
import 'package:flutter/material.dart';

class KakaoNaviOpenBtn extends StatelessWidget {
  const KakaoNaviOpenBtn({Key? key, required this.lat, required this.lng, required this.location, required this.name}) : super(key: key);
  final String name;
  final String location;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              KakaoSdkWith.forwordKakaoNavi(name, lat, lng);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.yellow,
              onPrimary: Colors.black,
              textStyle: const TextStyle(fontSize: 15),
            ),
            child: Text('카카오 네비 연동 : 자동차전용제외'),
          ),
        ),
      );
  }
}
