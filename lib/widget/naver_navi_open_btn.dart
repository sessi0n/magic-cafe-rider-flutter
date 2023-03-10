

import 'package:bike_adventure/widget/kakao_sdk_with.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NaverNaviOpenBtn extends StatelessWidget {
  const NaverNaviOpenBtn({Key? key, required this.lat, required this.lng, required this.location}) : super(key: key);
  final String location;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              // KakaoSdkWith.forwordKakaoNavi(location, lat, lng);
              // launch();
              // firebase_dynamic_link 를 이용해야함.
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.green,
              onPrimary: Colors.white,
              textStyle: const TextStyle(fontSize: 15),
            ),
            child: Text('네이버 네비 연동 : 자동차전용제외'),
          ),
        ),
      );
  }
}
