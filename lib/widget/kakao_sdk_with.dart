import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';

class KakaoSdkWith {
  static Future forwordKakaoNavi(String address, double lat, double lng) async {
    // 카카오내비 앱으로 길 안내
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      // 카카오내비 앱으로 목적지 공유하기, WGS84 좌표계 사용
      await NaviApi.instance.shareDestination(
        destination:
            Location(name: address, x: lng.toString(), y: lat.toString()),
        // 좌표계 지정
        option: NaviOption(coordType: CoordType.wgs84, rpOption: RpOption.noAuto),
      );
    } else {
      // 카카오내비 설치 페이지로 이동
      launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
    }
  }
}
