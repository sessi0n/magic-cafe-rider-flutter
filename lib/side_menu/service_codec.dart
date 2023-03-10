import 'dart:io';

import 'package:bike_adventure/constants/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ServiceCodec extends StatefulWidget {
  const ServiceCodec({Key? key}) : super(key: key);

  @override
  State<ServiceCodec> createState() => _ServiceCodecState();
}

class _ServiceCodecState extends State<ServiceCodec> {
  final GlobalKey webViewKey = GlobalKey();
  late final WebViewController _controller;

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

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
          leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Get.back();
              }
          ),
          leadingWidth: 40,
          title: const Text(
            '앱 이용약관',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: WebViewWidget(controller: _controller),);
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
