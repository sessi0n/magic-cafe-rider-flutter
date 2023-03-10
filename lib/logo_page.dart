import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/google_service_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    as KakaoUserSdk;
// import 'package:launch_review/launch_review.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({Key? key}) : super(key: key);

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  ProfileController profileController = Get.find<ProfileController>();
  GoogleServiceController googleServiceController =
      Get.find<GoogleServiceController>();
  bool needUpdate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      KakaoUserSdk.KakaoSdk.init(
          nativeAppKey: 'e4fce95ee57703a494f6e5fed871dde5');

      await profileController.initVersion();
      if (profileController.isNeedUpdate()) {
        profileController.isLogin.value = LoginStat.needUpdate;
        needUpdate = true;
      } else {
        await autoLogin();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    const MAIN_TEXT_GAP = 45.0;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                color: Colors.amber.withOpacity(0.7),
                child: Column(
                  children: [
                    Flexible(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: MAIN_TEXT_GAP),
                            child: Text(
                              '매직',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: MAIN_TEXT_GAP),
                            child: Text(
                              '카페',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: MAIN_TEXT_GAP),
                            child: Text(
                              '라이더',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          // Text('그 앱', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: Lottie.asset(
                                    'assets/lottie/97383-yellow-delivery-guy.zip'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 3,
                        child: Obx(() {
                          if (profileController.isLogin.value == LoginStat.needUpdate && needUpdate) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('업데이트를 위해 스토어로 이동하시겠습니까?'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.deepPurpleAccent),
                                        onPressed: () async {
                                          setState(() {
                                            profileController.isLogin.value = LoginStat.loading;
                                            needUpdate = false;
                                          });

                                          await autoLogin();
                                        },
                                        child: const Text('NO')),
                                    SizedBox(
                                      width: 150,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.deepPurpleAccent),
                                          onPressed: () {
                                            // LaunchReview.launch(
                                            //     androidAppId:
                                            //     'com.takeoff.rider_adventure',
                                            //     iOSAppId: '1617232532',
                                            //     writeReview: false);
                                          },
                                          child: const Text('UPDATE')),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else if (profileController.isLogin.value != LoginStat.loading) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Platform.isIOS
                                    ? buildAppleLoginButton()
                                    : Container(),
                                Center(child: buildGoogleLoginButton()),
                                buildKakaoLoginButton()
                              ],
                            );
                          }
                          else {
                            return Container();
                          }
                        }),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.lightBlue.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            ' take-off.kr',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() => Text(
                            'version ${profileController.packageVersion}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> autoLogin() async {
    if (await googleServiceController.setInit() || await googleServiceController.setKakaoAutoLogin()) {
    //구글은 Listener 가 있어서 Profile 세팅할 때 LoginStat 을 바꾸게 함
    }
    else {
      profileController.isLogin.value = LoginStat.none;
    }
  }

  showUpdateAlertDialog(BuildContext context) {
    if (profileController.isLogin.value != LoginStat.needUpdate) {
      return;
    }

    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetYesOrNo('업데이트를 위해 스토어로 이동하시겠습니까?'),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        pushSnackbar('Login', '버전 업데이트가 필요합니다');
      }
    });
  }

  buildGoogleLoginButton() {
    if (profileController.isLogin.value == LoginStat.none) {
      return InkWell(
        onTap: () {
          googleServiceController.handleSignIn();
        },
        child: Container(
          height: 40,
          width: 240,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 12),
              Image(
                image: AssetImage('assets/icons/google-logo.png'),
                width: 19,
                height: 19,
              ),
              Flexible(
                  child: Center(
                      child: Text(
                'Sign in with Google',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ))),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      );
    } else if (profileController.isLogin.value == LoginStat.success) {
      profileController.startMainPage(1);
      return Text(
        'Hello my friend, ${profileController.profile!.nick}',
        style: const TextStyle(color: Colors.white),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  buildAppleLoginButton() {
    if (profileController.isLogin.value == LoginStat.none) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: SizedBox(
          width: 240,
          height: 40,
          child: SignInWithAppleButton(
            height: 34,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            iconAlignment: IconAlignment.left,
            style: SignInWithAppleButtonStyle.white,
            onPressed: () async {
              bool isGood = await SignInWithApple.isAvailable();
              if (isGood) {
                final credential = await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                  // webAuthenticationOptions: WebAuthenticationOptions(
                  //   clientId: 'com.takeoff.riderAdventure.signin',
                  //   redirectUri:
                  //   Uri.parse('https://somber-hot-diagnostic.glitch.me/callbacks/sign_in_with_apple'),
                  // ),
                );

                final oauthCredential = OAuthProvider("apple.com").credential(
                  idToken: credential.identityToken,
                  accessToken: credential.authorizationCode,
                );

                await Firebase.initializeApp();

                final authResult = await FirebaseAuth.instance
                    .signInWithCredential(oauthCredential);
                final firebaseUser = authResult.user;

                if (firebaseUser == null) {
                  pushSnackbar('Login', '로그인에 실패했습니다.');
                  return;
                }

                if (kDebugMode) {
                  print('--------------');
                  print(credential);
                  print('--------------');
                  print(oauthCredential);
                  print('--------------');
                  print(firebaseUser);
                  print('--------------');
                }

                var displayName = 'nobody';
                if (credential.givenName != null ||
                    credential.familyName != null) {
                  displayName =
                      '${credential.givenName ?? ''} ${credential.familyName ?? ''}';
                }

                if (firebaseUser.email!.isNotEmpty &&
                    firebaseUser.uid.isNotEmpty) {
                  // await profileController.getVersionInfo();
                  // await profileController.checkVersion();
                  //apple 은 photoURL 이 없음.
                  profileController.setUser(
                      firebaseUser.uid,
                      firebaseUser.email ?? '',
                      displayName,
                      firebaseUser.photoURL);
                  profileController.getMyProfile(eService.APPLE);
                }
              } else {
                // final signInWithAppleEndpoint = Uri(
                //   scheme: 'https',
                //   host: 'somber-hot-diagnostic.glitch.me',
                //   path: '/callbacks/sign_in_with_apple',
                //   queryParameters: <String, String>{
                //     'code': credential.authorizationCode,
                //     if (credential.givenName != null)
                //       'firstName': credential.givenName!,
                //     if (credential.familyName != null)
                //       'lastName': credential.familyName!,
                //     'useBundleId':
                //     !kIsWeb && (Platform.isIOS || Platform.isMacOS)
                //         ? 'true'
                //         : 'false',
                //     if (credential.state != null) 'state': credential.state!,
                //   },
                // );
                //
                // final session = await http.Client().post(
                //   signInWithAppleEndpoint,
                // );
                print('Apple response not login');
              }
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  buildKakaoLoginButton() {
    if (profileController.isLogin.value == LoginStat.none) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () async {
            googleServiceController.kakaoLogin();
          },
          child: Center(
            child: Container(
              width: 240,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                      'assets/kakao_login/kakao_login_medium_wide.png'),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
