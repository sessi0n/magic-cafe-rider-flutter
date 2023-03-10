import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    as KakaoUserSdk;

class GoogleServiceController extends GetxController {
  static GoogleServiceController get to => Get.find();
  ProfileController profileController = Get.find<ProfileController>();

  late GoogleSignIn _googleSignIn;

  // GoogleSignInAccount? currentUser;
  // String _contactText = '';

  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   _contactText = 'Loading contact info...';
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     _contactText = 'People API gave a ${response.statusCode} '
  //         'response. Check logs for details.';
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data =
  //   json.decode(response.body) as Map<String, dynamic>;
  //   final String? namedContact = _pickFirstNamedContact(data);
  //   if (namedContact != null) {
  //     _contactText = 'I see you know $namedContact!';
  //   } else {
  //     _contactText = 'No contacts to display.';
  //   }
  // }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'] as List<dynamic>?;
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //         (dynamic contact) => contact['names'] != null,
  //     orElse: () => null,
  //   ) as Map<String, dynamic>?;
  //   if (contact != null) {
  //     final Map<String, dynamic>? name = contact['names'].firstWhere(
  //           (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     ) as Map<String, dynamic>?;
  //     if (name != null) {
  //       return name['displayName'] as String?;
  //     }
  //   }
  //   return null;
  // }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  Future<bool> setInit() async {
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'profile',
      ],
    );

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      if (account != null) {
        final GoogleSignInAccount user = account;

        profileController.setUser(
            user.id, user.email, user.displayName, user.photoUrl);
        profileController.getMyProfile(eService.GOOGLE);
      } else {
        // debugPrint('onInit account null');
        // 로그 아웃할 때 호출됨
      }
    });

    if (await _googleSignIn.signInSilently() == null) {
      return false;
    }

    return true;
  }

  setKakaoAutoLogin() async {
    bool isOk = false;
    try {
      if (await KakaoUserSdk.AuthApi.instance.hasToken()) {
        try {
          KakaoUserSdk.AccessTokenInfo tokenInfo =
          await KakaoUserSdk.UserApi.instance.accessTokenInfo();
          debugPrint('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

          // OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          // print('로그인 성공 ${token.accessToken}');
          isOk = await kakaoLogin();
        } catch (error) {
          if (error is KakaoUserSdk.KakaoException &&
              error.isInvalidTokenError()) {
            debugPrint('토큰 만료 $error');
          } else {
            debugPrint('토큰 정보 조회 실패 $error');
          }
        }
      } else {
        debugPrint('발급된 토큰 없음');
      }

    }
    catch (err) {
      debugPrint('토튼 체크 실패 $err');
    }

    return isOk;
  }

  Future<bool> kakaoLogin() async {
    bool isOk = false;
    // 카카오톡 설치 여부 확인
    // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await KakaoUserSdk.isKakaoTalkInstalled()) {
      try {
        await KakaoUserSdk.UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공');
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await KakaoUserSdk.UserApi.instance.loginWithKakaoAccount();
          debugPrint('카카오계정으로 로그인 성공');
        } catch (error) {
          // print('카카오계정으로 로그인 실패 $error');
          pushSnackbar('카카오 로그인', '실패: ${error}');
        }
      }
    } else {
      try {
        await KakaoUserSdk.UserApi.instance.loginWithKakaoAccount();
        debugPrint('카카오계정으로 로그인 성공');
      } catch (error) {
        pushSnackbar('카카오 로그인', '실패: ${error}');
      }
    }

    KakaoUserSdk.User user = await KakaoUserSdk.UserApi.instance.me();

    if (user != null) {
      profileController.setUser(
          user.id.toString(),
          user.kakaoAccount!.email ?? '',
          user.kakaoAccount!.profile!.nickname,
          user.kakaoAccount!.profile!.profileImageUrl);
      profileController.getMyProfile(eService.KAKAO);
      isOk = true;
    } else {
      pushSnackbar('카카오 로그인', '네트워크 통신오류입니다. 다시 시도해 주세요');
    }

    return isOk;
  }
}
