import 'dart:convert';
import 'dart:io';

import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/models/kakao_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../constants/environment.dart';

class KakaoMapViewer extends StatefulWidget {
  const KakaoMapViewer({Key? key}) : super(key: key);

  @override
  _KakaoMapViewerState createState() => _KakaoMapViewerState();
}

final bucketGlobal = PageStorageBucket();

class _KakaoMapViewerState extends State<KakaoMapViewer> {
  final GlobalKey webViewKey = GlobalKey();
  double? lat;
  double? lng;
  var addressName = '';

  // String? html;
  bool positionStreamStarted = false;
  bool mapLoaded = false;
  var data = <KakaoMap>[].obs;

  late final WebViewController _controller;

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  final searchAddressController = TextEditingController();
  bool isOpenDrawer = false;
  int clickIndex = 0;
  ScrollController? _scrollController;
  bool isCanBack = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

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

    if (WriterQuestController.to.isCompletedOpenMap.value) {
      lat = WriterQuestController.to.lat.value;
      lng = WriterQuestController.to.lng.value;

      setState(() {
        positionStreamStarted = true;
      });
    }
    else {
      _determinePosition();
    }

  }

  @override
  void dispose() {
    urlController.dispose();
    searchAddressController.dispose();
    data.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: PageStorage(
    bucket: bucketGlobal,
    child: Column(
      children: [
        positionStreamStarted
            ? Expanded(
                child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  !mapLoaded ? const LinearProgressIndicator() : Container(),
                ],
              ))
            : const LinearProgressIndicator(),
      ],
    ),
      ),
    );
  }

  _determinePosition() async {
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

  void setGpsInfo(double lat, double lng, String addressName) {
    this.lat = lat;
    this.lng = lng;
    this.addressName = addressName;
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
    ..addJavaScriptChannel('onSetAddress',
        onMessageReceived: (JavaScriptMessage msg) {
          data.clear();
          debugPrint("message 1: ${msg.message}");
          var obj = json.decode(msg.message);
          debugPrint("message 2: $obj");
          // distMeToTarget = obj['d1'] ?? 'unknown';
          // distTargetToShop = obj['d2'] ?? 'unknown';
          //
          // if(args[2] != '') {
          //   setGpsInfo(args[0], args[1], args[2]);
          // }
          // else {
          //   setGpsInfo(args[0], args[1], args[3]);
          // }
        })
    ..addJavaScriptChannel('onAddressList',
        onMessageReceived: (JavaScriptMessage msg) {
          debugPrint("message 1: ${msg.message}");
          var obj = json.decode(msg.message);
          debugPrint("message 2: $obj");

          // List<KakaoMap> list = (args[0] as List<dynamic>)
          //     .map((e) => KakaoMap.fromJson(e))
          //     .toList();
          // data.addAll(list);
        })
    ..addJavaScriptChannel('onFirstSetAddress',
        onMessageReceived: (JavaScriptMessage msg) {
          debugPrint("message 1: ${msg.message}");
          var obj = json.decode(msg.message);
          debugPrint("message 2: $obj");

          // if(args[2] != '') {
          //   setGpsInfo(args[0], args[1], args[2]);
          // }
          // else {
          //   setGpsInfo(args[0], args[1], args[3]);
          // }
          //
          // setState(() {
          //   mapLoaded = true;
          // });
        })
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
