import 'package:bike_adventure/controllers/npc_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/tabs/details/kakaoMapViewer2.dart';
import 'package:bike_adventure/tabs/details/modify_my_npc.dart';
import 'package:bike_adventure/widget/kakao_navi_open_btn.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:bike_adventure/tabs/details/gallery_photo_view_wrapper.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DetailNpcPage extends StatefulWidget {
  const DetailNpcPage({Key? key, required this.npc}) : super(key: key);
  final Npc npc;

  @override
  _DetailNpcPageState createState() => _DetailNpcPageState();
}

class _DetailNpcPageState extends State<DetailNpcPage> {
  late Npc npc;
  final ProfileController _profileController = Get.find<ProfileController>();
  final NpcController npcController = Get.find<NpcController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GalleryItem> galleryItems = List.empty(growable: true);
  var pageController = PageController(initialPage: 0);
  var youtubeEditingController = TextEditingController();
  var instagramEditingController = TextEditingController();
  var webEditingController = TextEditingController();

  @override
  void initState() {
    npc = widget.npc;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      if (npc.pictures.isEmpty) {
        List<PictureImage> images = await npcController.getNpcImages(npc.nid);
        for (var element in images) {
          galleryItems.add(GalleryItem(
              resource: element.pictureUrl, id: element.idx, isLocal: false));
        }
      }
      else {
        for (var element in npc.pictures) {
          galleryItems.add(GalleryItem(
              resource: element.pictureUrl, id: element.idx, isLocal: false));
        }
      }

      setState(() {
        galleryItems;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    youtubeEditingController.dispose();
    webEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMine = _profileController.profile!.uid == npc.writer!.uid;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                npc.name,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 50,
            ),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _buildMap(),
                Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0, left: 12.0, top: 20.0),
                    child: _buildListTitle()),
                _buildListAddress(npc),
                const SizedBox(height: 2,),
                npc.webUrl.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 120,
                    child:
                        buildWebUrl(npc.webUrl),
                  ),
                )
                    : addWebButton(isMine),
                const SizedBox(height: 2,),
                npc.instagram.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 120,
                    child:
                    buildAnyLinkPreviewHorizontal(npc.instagram),
                  ),
                )
                    : addInstagramButton(isMine),
                npc.youtubeUrl.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 120,
                    child:
                    buildAnyLinkPreviewHorizontal(npc.youtubeUrl),
                  ),
                )
                    : addYoutubeButton(isMine),
                const SizedBox(height: 2,),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0, left: 12.0, top: 20, bottom: 20.0),
                  child: _buildSubPictures(context),
                ),
                buildPictureHelp(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 12.0, vertical: 30),
                //   child: _buildNpcButton(context, npc),
                // ),
                _buildAdminButton(npc),
                const SizedBox(height: 30,),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  buildPictureHelp() {
    if (npc.pictureHelp.isEmpty) {
      return Container();
    }

    if (getUrlValid(npc.pictureHelp)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '사진 도움 주신 분 링크 : ',
              style: TextStyle(fontSize: 12),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  launchURL(npc.pictureHelp);
                },
                child: Text(npc.pictureHelp,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Container _buildSubPictures(context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: npc.pictures.length,
        itemBuilder: (_, index) {
          return GalleryItemThumbnail(
            item: galleryItems[index],
            onTap: () {
              openPicture(context, index, galleryItems);
            },
          );
        },
      ),
    );
  }

  Widget _buildListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getNpcIcon(npc.type.index, size: 25.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                npc.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListAddress(npc) {
    if (npc.location.isEmpty) {
      return Container();
    }

    return Card(
      // elevation: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  npc.location,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: npc.location))
                      .then((value) =>
                          pushSnackbar('주소 복사', npc.location));
                },
                icon: const Icon(
                  Icons.content_copy_rounded,
                  size: 15,
                )),
          ],
        ),
      ),
    );
  }

  _buildAdminButton(npc) {
    if (_profileController.profile!.role != 1) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const Text(
                  '삭제',
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
                onPressed: () async {
                  showDeleteAlertDialog(context, npc);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: SizedBox(
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child: const Text(
                  '수정',
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
                onPressed: () async {
                  Npc? back = await Get.to(() =>
                      ModifyMyNpc(npc: npc));
                  setState(() {
                    if (back != null) {
                      setState(() {
                        galleryItems.clear();
                        back.pictures.forEach((element) {
                          galleryItems.add(GalleryItem(
                              resource: element.pictureUrl,
                              id: element.idx,
                              isLocal: false));
                        });
                        npc = back;
                      });
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildNpcButton(context, Npc npc) {
    if (!_profileController.isMyNpc(npc)) {
      return Container();
    }

    return Container(
      width: Get.width,
      height: 40,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.grey, Colors.grey.shade700]),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          borderRadius: const BorderRadius.all(Radius.circular(3.0))),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        child: const Text(
          '나의 NPC 삭제',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () async {
          showDeleteAlertDialog(context, npc);
        },
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context, npc) {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetYesOrNo('정말 이 NPC를 삭제하시겠습니까?'),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        showDeleteAlertDialog2(context, npc);
      }
    });
  }

  showDeleteAlertDialog2(BuildContext context, npc) async {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetCircularProgressIndicator("NPC 삭제 중..."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) async {});

    bool result = await _profileController.removeNpc(npc);

    Future.delayed(const Duration(seconds: 2), () {
      Get.to(
          () => const MainPage(
                initialPage: 1,
              ),
          transition: Transition.rightToLeftWithFade);
    });
  }

  buildWebPreview(npc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(height: 300, child: buildAnyLinkPreview(npc.webUrl)),
    );
  }

  addYoutubeButton(bool isMine) {
    if (!isMine) {
      return Container();
    }
    return InkWell(
      onTap: () {
        showYoutubeInputDialog(context, npc);
      },
      child: Row(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //모서리를 둥글게 하기 위해 사용
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0, //그림자 깊이
            child:
            const FaIcon(FontAwesomeIcons.youtube, color: Colors.red, size: 50),
          ),
          const Text('유투브 URL 추가')
        ],
      ),
    );
  }

  addWebButton(bool isMine) {
    if (!isMine) {
      return Container();
    }

    return InkWell(
      onTap: () {
        showWebInputDialog(context, npc);
      },
      child: Row(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //모서리를 둥글게 하기 위해 사용
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0, //그림자 깊이
            child:
            const Icon(Icons.link_rounded, color: Colors.red, size: 50),
          ),
          const Text('웹 URL 추가')
        ],
      ),
    );
  }

  showYoutubeInputDialog(BuildContext context, n) {
    AlertDialog alert = AlertDialog(
        title: const Text(
          '유투브 URL 입력',
          style: TextStyle(fontSize: 16),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: youtubeEditingController,
          // decoration: InputDecoration(hintText: "오른쪽에 붙여넣기 버튼이 있습니다"),
        ),
        actions: [TextButton(onPressed: () async {
          if (!getUrlValid(youtubeEditingController.text)) {
            pushSnackbar('유투브 URL 수정', '정상적인 URL이 아닙니다');
            return;
          }
          Npc ret = await npcController.modifyUrl(n, _profileController.profile!.uid, youtubeEditingController.text, 'youtube_url');

          Navigator.pop(context);
          setState(() {
            npc = ret;
          });

        }, child: const Text('수정'))]);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {});
  }

  showWebInputDialog(BuildContext context, n) {
    AlertDialog alert = AlertDialog(
        title: const Text(
          '웹 URL 입력',
          style: TextStyle(fontSize: 16),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: webEditingController,
        ),
        actions: [TextButton(onPressed: () async {
          if (!getUrlValid(webEditingController.text)) {
            pushSnackbar('유투브 URL 수정', '정상적인 URL이 아닙니다');
            return;
          }
          Npc ret = await npcController.modifyUrl(n, _profileController.profile!.uid, webEditingController.text, 'web_url');

          Navigator.pop(context);
          setState(() {
            npc = ret;
          });

        }, child: const Text('수정'))]);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {});
  }

  addInstagramButton(bool isMine) {
    if (!isMine) {
      return Container();
    }
    return InkWell(
      onTap: () {
        showInstagramInputDialog(context, npc);
      },
      child: Row(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //모서리를 둥글게 하기 위해 사용
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0, //그림자 깊이
            child:
            const FaIcon(FontAwesomeIcons.instagram, color: Colors.red, size: 50),
          ),
          const Text('Instagram URL 추가')
        ],
      ),
    );
  }

  void showInstagramInputDialog(BuildContext context, Npc npc) {
    AlertDialog alert = AlertDialog(
        title: const Text(
          'Instagram URL 입력',
          style: TextStyle(fontSize: 16),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: instagramEditingController,
          // decoration: InputDecoration(hintText: "오른쪽에 붙여넣기 버튼이 있습니다"),
        ),
        actions: [TextButton(onPressed: () async {
          if (!getUrlValid(instagramEditingController.text)) {
            pushSnackbar('Instagram URL 수정', '정상적인 URL이 아닙니다');
            return;
          }
          Npc ret = await npcController.modifyUrl(npc, _profileController.profile!.uid, instagramEditingController.text, 'instagram');

          Navigator.pop(context);
          setState(() {
            npc = ret;
          });

        }, child: const Text('수정'))]);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {});
  }

  buildWebUrl(url) {
    List<String> splitUrl = url.split(':');

    if (splitUrl[0] == 'tel') {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(splitUrl[1], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 25)),
      );
    }

    return buildAnyLinkPreviewHorizontal(url);
  }

  _buildMap() {
    if (npc.type == eNpcType.WEBSTORE) {
      return Container();
    }

    if (npc.type == eNpcType.ASSIST) {
      // return Container(
      //   width: double.infinity,
      //   height: 300,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     image: DecorationImage(
      //       image: NetworkImage(npc.pictures[0].pictureUrl),
      //       fit: BoxFit.fitWidth,
      //     ),
      //   ),
      // );
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: Image.network(npc.pictures[0].pictureUrl),
      );
    }

    return Column(
      children: [
        KakaoMapViewer2(lat: npc.lat, lng: npc.lng, mapHeight: 350.0),
        KakaoNaviOpenBtn(name: npc.name, location: npc.location, lat: npc.lat, lng: npc.lng),
      ],
    );
  }
}
