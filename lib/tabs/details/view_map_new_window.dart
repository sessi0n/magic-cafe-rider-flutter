import 'package:bike_adventure/controllers/npc_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/marker_info.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ViewMapNewWindow extends StatefulWidget {
  const ViewMapNewWindow({Key? key}) : super(key: key);

  @override
  State<ViewMapNewWindow> createState() => _ViewMapNewWindowState();
}

class _ViewMapNewWindowState extends State<ViewMapNewWindow> {
  bool myPositionLoaded = false;
  double lat = 0.0, lng = 0.0;
  final ProfileController profileController = Get.find<ProfileController>();
  final QuestController questController = Get.find<QuestController>();
  final NpcController npcController = Get.find<NpcController>();

  List<MarkerInfo> markers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getMyPosition().then((pos) async {
        if (pos == null) {
          throw 'pos is null';
        }
        lat = pos.latitude;
        lng = pos.longitude;

        markers.addAll(await profileController.getMarkerInfo(lat, lng));

        setState(() {
          myPositionLoaded = true;
        });
      }).catchError((e) {
        pushSnackbar('위치 정보', '내 위치 정보를 불러올 수 없습니다.');
      });
    });
  }

  late WebViewController _mapController;

  @override
  Widget build(BuildContext context) {
    return myPositionLoaded
        ? SafeArea(
            child: Stack(
              children: [
          //       KakaoMapCopy(
          //         width: Get.width,
          //         height: Get.height,
          //         kakaoMapKey: KAKAO_MAP_KEY,
          //         lat: lat,
          //         lng: lng,
          //         zoomLevel: 8,
          //         // showMapTypeControl: true,
          //         // showZoomControl: true,
          //         // draggableMarker: true,
          //         mapType: MapType.TERRAIN,
          //         mapController: (controller) {
          //           _mapController = controller;
          //         },
          //         polyline: KakaoFigure(
          //           path: [],
          //           strokeColor: Colors.blue,
          //           strokeWeight: 2.5,
          //           strokeColorOpacity: 0.9,
          //         ),
          //         polygon: KakaoFigure(
          //           path: [],
          //           polygonColor: Colors.red,
          //           polygonColorOpacity: 0.3,
          //           strokeColor: Colors.deepOrange,
          //           strokeWeight: 2.5,
          //           strokeColorOpacity: 0.9,
          //           strokeStyle: StrokeStyle.shortdashdot,
          //         ),
          //         // overlayText: '카카오!',
          //         customOverlayStyle: '''<style>
          //               .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
          // .customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
          // .customoverlay aq {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #F5AF31FF;background: #F5AF31FF url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
          // .customoverlay an {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #435EE3FF;background: #435EE3FF url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
          // .customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
          // .customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
          //               </style>''',
          //         customOverlay: '''
          //         function moveToPage(index) {
          //           onTapMarker.postMessage(index);
          //         }
          //
          // (function(ms) {
          //   var contentStr;
          //   var customOverlay;
          //   for (var i = 0; i < ms.length; i++) {
          //     var position = new kakao.maps.LatLng(ms[i].lat, ms[i].lng);
          //     var marker = new kakao.maps.Marker({position: position});
          //     marker.setMap(map);
          //     marker.setZIndex(i);
          //
          //     if (ms[i].type == 'QUEST') {
          //     contentStr = '<div class="customoverlay">' +
          //      '  <aq type="button" onclick="moveToPage('+marker.getZIndex()+');">' +
          //     '    <span class="title">'+ms[i].title+'</span>' +
          //     '  </aq>' +
          //     '</div>';
          //     }
          //     else {
          //             contentStr = '<div class="customoverlay">' +
          //      '  <an type="button" onclick="moveToPage('+marker.getZIndex()+');">' +
          //     '    <span class="title">'+ms[i].title+'</span>' +
          //     '  </an>' +
          //     '</div>';
          //     }
          //
          //      customOverlay = new kakao.maps.CustomOverlay({
          //       map: map,
          //       position: position,
          //       content: contentStr
          //       });
          //
          //
          //     (function(marker) {
			    //     // 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다
			    //     kakao.maps.event.addListener(marker, 'click', function() {
			    //         onTapMarker.postMessage(marker.getZIndex());
			    //     });
					// })(marker);
          //   }
          //
          // })(${json.encode(markers)});
          //
          // var zoomControl = new kakao.maps.ZoomControl();
          // map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
          // var mapTypeControl = new kakao.maps.MapTypeControl();
          // map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
          //     ''',
          //         // customScript:  '''
          //         //
          //         //
          //         // ''',
          //         markerImageURL:
          //             'https://i1.daumcdn.net/dmaps/apis/n_local_blit_04.png',
          //         markerSizeWidth: 30,
          //         markerSizeHeight: 32,
          //
          //         onTapMarker: (message) async {
          //           try {
          //             MarkerInfo mark = markers[int.parse(message.message)];
          //             if (mark.type == eMarkerType.QUEST) {
          //               Quest? quest =
          //                   await questController.getQuestSingleData(mark.id);
          //               if (quest != null) {
          //                 Get.to(() => DetailQuestPage(
          //                     quest: quest, eBinding: eQuestBinding.none));
          //               }
          //             } else if (mark.type == eMarkerType.NPC) {
          //               Npc? npc =
          //                   await npcController.getNpcSingleData(mark.id);
          //               if (npc != null) {
          //                 Get.to(() => DetailNpcPage(
          //                       npc: npc,
          //                     ));
          //               }
          //             }
          //           } catch (e) {
          //             print(e);
          //           }
          //         },
          //         zoomChanged: (message) {
          //           debugPrint('[zoom] ${message.message}');
          //         },
          //         cameraIdle: (message) {
          //           KakaoLatLng latLng =
          //               KakaoLatLng.fromJson(jsonDecode(message.message));
          //           debugPrint('[idle] ${latLng.lat}, ${latLng.lng}');
          //         },
          //         boundaryUpdate: (message) {
          //           KakaoBoundary boundary =
          //               KakaoBoundary.fromJson(jsonDecode(message.message));
          //           debugPrint(
          //               '[boundary] ne : ${boundary.neLat}, ${boundary.neLng}, sw : ${boundary.swLat}, ${boundary.swLng}');
          //         },
          //       ),

                Positioned(
                  right: 20,
                  bottom: 20,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.blue, elevation: 10),
                      child: const Text(
                        '메인화면으로 이동',
                        style: TextStyle(
                            color: Colors.white,
                            // fontSize: 18,
                            fontWeight: FontWeight.w700),
                      )),
                )
              ],
            ),
          )
        : const CustomIndicatorBike(size: 200);
  }
}
