import 'dart:convert';

import 'package:bike_adventure/constants/systems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../constants/environment.dart';

class KakaoMapViewer2 extends StatefulWidget {
  const KakaoMapViewer2({Key? key,required this.lat,required this.lng,required this.mapHeight}) : super(key: key);
  final double lat;
  final double lng;
  final double mapHeight;

  @override
  State<KakaoMapViewer2> createState() => _KakaoMapViewer2State();
}

class _KakaoMapViewer2State extends State<KakaoMapViewer2> {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Card(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WebViewWidget(controller: _controller),
            ],
          ),
        ),
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
