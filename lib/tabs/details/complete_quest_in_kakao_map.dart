import 'dart:io';

import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../constants/environment.dart';

enum eInBindType {
  complete,
  footPrint,
}

class CompleteQuestInKakaoMap extends StatefulWidget {
  const CompleteQuestInKakaoMap({Key? key, required this.quest, required this.type})
      : super(key: key);

  final Quest quest;
  final eInBindType type;

  @override
  State<CompleteQuestInKakaoMap> createState() =>
      _CompleteQuestInKakaoMapState();
}

enum completeState {
  init,
  not,
  wait,
  ok,
  success,
  failed,
}

class _CompleteQuestInKakaoMapState extends State<CompleteQuestInKakaoMap> {
  final ProfileController _profileController = Get.find<ProfileController>();

  late double lat, lng;
  completeState state = completeState.init;

  late final WebViewController _controller;

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  final GlobalKey webViewKey = GlobalKey();

  bool mapLoaded = false;
  bool positionStreamStarted = false;

  @override
  void initState() {
    super.initState();

    determinePosition();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);
    debugPrint("WebViewController.fromPlatformCreationParams");
    //
    webGo();
  }

  @override
  void dispose() {
    urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var appBar;

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar = AppBar(
    leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () {
          Get.back(result: {'result': false});
        }),
    leadingWidth: 40,
    title: Text(
      widget.type == eInBindType.complete ? '퀘스트 완료하기' : '발자취 남기기',
      style: const TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
    ),
    backgroundColor: Colors.white,
      ),
      body: !positionStreamStarted
      ? const CustomIndicatorBike(size: 200)
      : Stack(
          children: [
            WebViewWidget(controller: _controller),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: Get.width,
                    height: 95,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: buildQuestResult(),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }

  Padding buildQuestResult() {
    if (state == completeState.not) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.type == eInBindType.complete ? '거리가 너무 멀어 퀘스트를 완료할 수 없습니다.\n' : '거리가 너무 멀어 발자취를 남길 수 없습니다.\n' +
            '현재 지점과 퀘스트 지점의 거리가 100m 이내여야 합니다.',
          ),
        ),
      );
    }
    else if (state == completeState.wait) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomIndicatorBike(size: 200),
      );
    }
    else if (state == completeState.ok) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text( widget.type == eInBindType.complete ?
            '축하합니다!\n이제 퀘스트를 완료할 수 있습니다.' : '축하합니다!\n이제 발자취를 남길 수 있습니다.',
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  setState(() {
                    state = completeState.wait;
                  });
                  bool isSuccess =
                  widget.type == eInBindType.complete ? await _profileController.completeQuest(widget.quest)
                  : await _profileController.footQuest(widget.quest);

                  if (isSuccess) {
                    setState(() {
                      state = completeState.success;
                    });
                  } else {
                    setState(() {
                      state = completeState.failed;
                    });
                  }
                },
                child: Container(
                    // width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                        child: Text(
                          '완료하기',
                      style: const TextStyle(color: Colors.white),
                    ))),
              ),
            ),
          ],
        ),
      );
    }
    else if (state == completeState.success) {
      Future.delayed(const Duration(milliseconds: 1300), () {
        Get.offAll(()=>const MainPage(initialPage: 2,), transition: Transition.rightToLeftWithFade);
      });
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.type == eInBindType.complete ? '축하합니다!\n퀘스트가 완료됐습니다.' : '축하합니다!\n발자취를 남겼습니다.',
          ),
        ),
      );
    }
    else if (state == completeState.failed) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
              '알 수 없는 이유로 실패했습니다.'
          ),
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CustomIndicatorBike(size: 200),
    );
  }

  setDistance(dist) {
    if (dist > 100) {
      setState(() {
        state = completeState.not;
      });
    } else {
      setState(() {
        state = completeState.ok;
      });
    }
  }

  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lng = position.longitude;

    setState(() {
      positionStreamStarted = true;
    });
  }

  webGo() {
    String url = '${Environment.metaUrl}/privacy';

    debugPrint("url: $url");

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            // setState(() {
            //   mapLoaded = false;
            // });
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
        ),
      )
    // ..addJavaScriptChannel('CompletedPage',
    //     onMessageReceived: (JavaScriptMessage message) {
    //
    //     })
    // ..addJavaScriptChannel('MarkerClick',
    //     onMessageReceived: (JavaScriptMessage message) {
    //       // debugPrint('MarkerClick Click.. ${message.message}');
    //       // showSelectDeliver(int.parse(message.message));
    //     })
    // ..addJavaScriptChannel('DblClickMap',
    //     onMessageReceived: (JavaScriptMessage message) {
    //       debugPrint('DblClickMap Click.. ${message.message}');
    //       // showSelectDeliver(int.parse(message.message));
    //     })
      ..loadRequest(Uri.parse(url));

    // #docregion platform_features
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    // _controller = controller;
  }
}
