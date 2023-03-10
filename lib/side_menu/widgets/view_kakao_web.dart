import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/models/kakao_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../constants/environment.dart';

class ViewKakaoWeb extends StatefulWidget {
  const ViewKakaoWeb({Key? key}) : super(key: key);

  @override
  _ViewKakaoWebState createState() => _ViewKakaoWebState();
}

final bucketGlobal = PageStorageBucket();

class _ViewKakaoWebState extends State<ViewKakaoWeb> {
  final GlobalKey webViewKey = GlobalKey();
  double? lat;
  double? lng;
  var addressName = '';

  // String? html;
  bool positionStreamStarted = false;
  bool mapLoaded = false;
  var data = <KakaoMap>[].obs;

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  final searchAddressController = TextEditingController();
  bool isOpenDrawer = false;
  int clickIndex = 0;
  ScrollController? _scrollController;
  bool isCanBack = true;

  late final WebViewController _controller;

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

    if (WriterQuestController.to.isCompletedOpenMap.value) {
      lat = WriterQuestController.to.lat.value;
      lng = WriterQuestController.to.lng.value;

      setState(() {
        positionStreamStarted = true;
      });

      webGo(lat, lng);
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
        Get.back(result: { 'result': false });
      }
    ),
    leadingWidth: 40,
    title: const Text(
      '위치 지정하기',
      style: TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
    ),
    backgroundColor: Colors.white,
      ),
      body: PageStorage(
    bucket: bucketGlobal,
    child: Column(
      children: [
        positionStreamStarted
            ? Expanded(
                child: Stack(
                children: [
                  // _buildKakaoMapView(appBar, scaffoldKey),
                  WebViewWidget(controller: _controller),
                  !mapLoaded ? Container() : Column(
                    children: [
                      _buildSearchBar(context),
                      Obx(() {
                        return _buildAddressCard();
                      }),
                    ],
                  ),
                  !mapLoaded ? const LinearProgressIndicator() : Container(),
                ],
              ))
            : const LinearProgressIndicator(),
      ],
    ),
      ),
      floatingActionButton: mapLoaded ? FloatingActionButton(
    // shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    elevation: 4.0,
    backgroundColor: Colors.amberAccent,
    child: const Icon(
      Icons.add,
      size: 32,
    ),
    onPressed: () {
      Get.back(result: { 'result': true, 'lat':lat, 'lng':lng, 'address_name': addressName});
    },
      ) : Container(),
    );
  }

  SizedBox _buildAddressCard() {

    return SizedBox(
      height: 60,
      child: GridView.builder(
        key: const PageStorageKey<String>('KakaoMapPage'),
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        shrinkWrap: true,
        // physics: BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 1 / 2,
          crossAxisSpacing: 10,
          // mainAxisSpacing: 10
        ),
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              setGpsInfo(data[index].y, data[index].x, data[index].address_name);
              setState(() {
                clickIndex = index;
              });
              _controller.runJavaScript("dataOneClick({detail: {lat:'${data[index].y}', lng:'${data[index].x}'});");
            },
            child: Center(
              child: Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: clickIndex == index ? Colors.grey : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: clickIndex == index ? Colors.amber : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                        child: Center(
                          child: Text(
                            data[index].place_name,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white,
        height: 45,
        child: TextField(
          textInputAction: TextInputAction.go,
          onSubmitted: (text) {
            searchAddressToKakao(context);
          },
          controller: searchAddressController,
          decoration: InputDecoration(
            // border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.only(top: 5, left: 12),
            suffixIcon: IconButton(
                onPressed: () async {
                  searchAddressToKakao(context);
                },
                icon: const Icon(Icons.search_rounded, color: Colors.orangeAccent,)),
            labelText: '주소',
            // hintText: '주소 검색',
            labelStyle: const TextStyle(color: Colors.orangeAccent),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: Colors.orangeAccent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: Colors.orangeAccent),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
      ),
    );
  }

  void searchAddressToKakao(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    data.clear();
    _controller.runJavaScript("searchAddress({detail: {address:${searchAddressController.value.text}}});");
  //   webViewController!.evaluateJavascript(
  //     source: """
  // {
  //   const event = new CustomEvent("searchAddress", {
  //     detail: {address:'${searchAddressController.value.text}'}
  //       });
  //       window.dispatchEvent(event);
  //     }
  //   """,
  //   );
  }

  // InAppWebView _buildKakaoMapView(appBar, scaffoldKey) {
  //   return InAppWebView(
  //     key: webViewKey,
  //     initialOptions: options,
  //     pullToRefreshController: pullToRefreshController,
  //     initialUrlRequest: URLRequest(
  //         url: Uri.parse("http://localhost:51723/assets/html/kakao_map.html"
  //             "?height=${(Get.height - appBar.preferredSize.height).round()}"
  //             "&lng=${lng}&lat=${lat}")),
  //     onWebViewCreated: (controller) {
  //       webViewController = controller;
  //       webViewController!.addJavaScriptHandler(
  //           handlerName: 'onSetAddress',
  //           callback: (args) {
  //             data.clear();
  //
  //             if(args[2] != '') {
  //               setGpsInfo(args[0], args[1], args[2]);
  //             }
  //             else {
  //               setGpsInfo(args[0], args[1], args[3]);
  //             }
  //             // Get.snackbar('위치', message);
  //           });
  //       webViewController!.addJavaScriptHandler(
  //           handlerName: 'onAddressList',
  //           callback: (args) {
  //             List<KakaoMap> list = (args[0] as List<dynamic>)
  //                 .map((e) => KakaoMap.fromJson(e))
  //                 .toList();
  //             data.addAll(list);
  //
  //           });
  //
  //       webViewController!.addJavaScriptHandler(
  //           handlerName: 'onFirstSetAddress',
  //           callback: (args) {
  //             if(args[2] != '') {
  //               setGpsInfo(args[0], args[1], args[2]);
  //             }
  //             else {
  //               setGpsInfo(args[0], args[1], args[3]);
  //             }
  //
  //             setState(() {
  //               mapLoaded = true;
  //             });
  //           });
  //     },
  //     onLoadStart: (controller, url) {
  //       setState(() {
  //         this.url = url.toString();
  //         urlController.text = this.url;
  //       });
  //       setState(() {
  //         mapLoaded = false;
  //       });
  //     },
  //     androidOnPermissionRequest: (controller, origin, resources) async {
  //       return PermissionRequestResponse(
  //           resources: resources,
  //           action: PermissionRequestResponseAction.GRANT);
  //     },
  //     onLoadStop: (controller, url) async {
  //       pullToRefreshController.endRefreshing();
  //       setState(() {
  //         this.url = url.toString();
  //         urlController.text = this.url;
  //       });
  //
  //     },
  //     onLoadError: (controller, url, code, message) {
  //       pullToRefreshController.endRefreshing();
  //     },
  //     onProgressChanged: (controller, progress) {
  //       if (progress == 100) {
  //         pullToRefreshController.endRefreshing();
  //       }
  //       setState(() {
  //         this.progress = progress / 100;
  //         urlController.text = url;
  //       });
  //     },
  //     onUpdateVisitedHistory: (controller, url, androidIsReload) {
  //       setState(() {
  //         this.url = url.toString();
  //         urlController.text = this.url;
  //       });
  //     },
  //     onConsoleMessage: (controller, consoleMessage) {
  //       if (kDebugMode) {
  //         print(consoleMessage);
  //       }
  //     },
  //   );
  // }

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

  webGo(lat, lng) {
    String url = '${Environment.mapUrl}/search/$lat/$lng';

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
      //       setState(() {
      //         mapLoaded = true;
      //       });
      //
      //     })
      // ..addJavaScriptChannel('MarkerClick',
      //     onMessageReceived: (JavaScriptMessage message) {
      //       // debugPrint('MarkerClick Click.. ${message.message}');
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
