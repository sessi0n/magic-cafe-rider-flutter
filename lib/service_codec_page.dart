import 'dart:io';

import 'package:bike_adventure/constants/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ServiceCodecPage extends StatefulWidget {
  const ServiceCodecPage({Key? key}) : super(key: key);

  @override
  State<ServiceCodecPage> createState() => _ServiceCodecPageState();
}

class _ServiceCodecPageState extends State<ServiceCodecPage> {
  final GlobalKey webViewKey = GlobalKey();

  String url = "";

  double progress = 0;

  final urlController = TextEditingController();

  bool isOpenDrawer = false;

  int clickIndex = 0;

  bool isCanBack = true;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '이용약관',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {
                  Get.back(result: false);
                }, child: const Text('취소하기')),
                TextButton(onPressed: () {
                  Get.back(result: true);
                }, child: const Text('동의하기')),
              ],
            ),
          ],
        ),
        );
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
