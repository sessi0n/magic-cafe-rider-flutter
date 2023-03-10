import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/constants/error_type.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/writer_npc_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/side_menu/widgets/view_kakao_web.dart';
import 'package:bike_adventure/tabs/details/gallery_photo_view_wrapper.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ModifyMyNpc extends StatefulWidget {
  const ModifyMyNpc({Key? key, required this.npc})
      : super(key: key);
  final Npc npc;

  @override
  State<ModifyMyNpc> createState() => _ModifyMyNpcState();
}

class _ModifyMyNpcState extends State<ModifyMyNpc> {
  final WriterNpcController _writerController =
      Get.find<WriterNpcController>();

  final ScrollController scrollController = ScrollController();

  List<GalleryItem> allImages = [];
  List<GalleryItem> delImages = [];

  @override
  void initState() {
    for (var element in widget.npc.pictures) {
      allImages.add(GalleryItem(resource: element.pictureUrl, id: element.idx, isLocal: false));
    }
    _writerController.nameEditingController.text = widget.npc.name;
    _writerController.npcType = widget.npc.type;
    _writerController.lat.value = widget.npc.lat;
    _writerController.lng.value = widget.npc.lng;
    _writerController.addressName.value = widget.npc.location;

    _writerController.isCompletedOpenMap.value = true;
    _writerController.isCompletedOpenPicture.value = true;
    _writerController.isCompletedOpenInfo.value = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: NotificationListener<ScrollNotification>(
            child: CustomScrollView(
          controller: scrollController,
          slivers: [
            buildAppBar(),
            SliverList(
                delegate: SliverChildListDelegate([
              queryName(),
              queryType(),
              queryMap(),
              querySubPictures(context),
              const SizedBox(
                height: 30,
              ),
              modifyButton(context),
            ])),
          ],
        )),
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black.withOpacity(0.7),
      foregroundColor: Colors.white,
      floating: true,
      pinned: false,
      snap: false,
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const ImageIcon(
                AssetImage('assets/icons/quest-write.png'),
                size: APP_BAR_ICONS_SIZE,
                color: Colors.white,
              ),
              Container(
                width: 20,
              ),
              const Text(
                'NPC 수정',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.cancel_rounded)),
      ],
    );
  }

  queryName() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
              width: 40,
              child: widget.npc.name.isNotEmpty
                  ? const Icon(Icons.check_box, size: 40, color: Colors.green)
                  : const Icon(
                      Icons.add_box,
                      size: 40,
                    )),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: TextField(
                textInputAction: TextInputAction.go,
                controller: _writerController.nameEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  // fillColor: HINT_BOX_DECO_COLOR,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // hintText: '카페 또는 상점 명',
                  // hintStyle: const TextStyle(fontSize: 12),
                  labelText: _writerController.nameEditingController.text,
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),

                  prefixIcon: const Icon(
                    Icons.ac_unit_rounded,
                    color: Colors.black,
                    size: 12,
                  ),
                  // prefixIcon: Icon(Icons.search),
                  // suffixIcon: const Icon(Icons.search)),
                )),
          ),
        ],
      ),
    );
  }

  queryType() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const SizedBox(
              width: 40,
              child: Icon(Icons.check_box, size: 40, color: Colors.green)),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Container(
              height: 40,
              // width: Get.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  // gradient: LinearGradient(
                  //     colors: [Colors.white70, Colors.white]),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 1.0)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Center(
                child: PopupMenuButton(
                  // icon: Icon(Icons.local_parking_rounded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getNpcIcon(_writerController.npcType.index,
                          size: 18.0, color: Colors.black),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(getNpcTypeText(_writerController.npcType.index)),
                    ],
                  ),
                  onSelected: (result) {
                    setState(() {
                      _writerController.npcType = result as eNpcType;
                    });
                  },
                  itemBuilder: (_) => eNpcType.values
                      .map((e) => PopupMenuItem(
                          value: e,
                          child: Text(
                            getNpcTypeText(e.index),
                            style: const TextStyle(fontSize: 12),
                          )))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  queryMap() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
              width: 40,
              child: _writerController.isCompletedOpenMap.value
                  ? const Icon(Icons.check_box, size: 40, color: Colors.green)
                  : const Icon(Icons.add_box, size: 40)),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Container(
              width: Get.width,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.public_rounded,
                  size: 20,
                  color: Colors.black,
                ),
                label: Obx(() => Text(
                  _writerController.addressName.value,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
                )),
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () async {
                  final result = await Get.to(() => const ViewKakaoWeb(),
                      transition: Transition.rightToLeftWithFade);
                  if (result != null && result['result']) {
                    _writerController.completedOpenMapState(
                        result["lat"], result["lng"], result["address_name"]);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  querySubPictures(context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final List<XFile>? images = await getMultiImagePicker();
              if (images != null && images.isNotEmpty) {
                setState(() {
                  List<GalleryItem> items = [];
                  for (var element in images) {
                    GalleryItem item = GalleryItem(
                        id: 0, resource: element.path, isLocal: true);
                    items.add(item);
                  }
                  allImages.addAll(items);
                  _writerController.uploadPictures.addAll(items);
                  // _writerController.completedOpenMultiPicture();
                });
              }
            },
            child: Container(
              height: 100,
              width: 70,
              decoration: BoxDecoration(
                color: allImages.isEmpty ? Colors.black : Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: const Icon(
                Icons.add_box,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allImages.length,
                itemBuilder: (_, index) {
                  return GalleryItemThumbnail(
                    item: allImages[index],
                    onTap: () {
                      openPicture(context, index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openPicture(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: allImages,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
          onTabDelete: onDeletePicture,
          needDeleteButton: true,
        ),
      ),
    );
  }

  onDeletePicture(GalleryItem item) {
    if (!item.isLocal) {
      delImages.add(item);
    }
    else {
      _writerController.uploadPictures.remove(item);
    }

    setState(() {
      allImages.remove(item);
    });
  }

  modifyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.indigo,
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blueAccent.shade700]),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(3.0))),
        child: RawMaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.app_registration_rounded,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "NPC 수정하기",
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            var result = _writerController.isValidAddNpc();
            if (result == ERR_NOT_SET_LOCATION) {
              pushSnackbar('NPC 등록 설정', '위치를 등록해주세요');
              return;
            } else if (result == ERR_NOT_SET_PICTURE) {
              pushSnackbar('NPC 등록 설정', '사진을 등록해주세요');
              return;
            } else if (result == ERR_NOT_SET_NAME) {
              pushSnackbar('NPC 등록 설정', '이름을 등록해주세요');

              return;
            } else if (result == ERR_NOT_VALID_YOUTUBE) {
              pushSnackbar('NPC 등록 설정', 'YOUTUBE URL이 정상적이지 않습니다');

              return;
            }

            showAlertDialog(context, "NPC 수정 중...");

            Npc modifyNpc = await _writerController.modifyNpc(widget.npc, delImages);

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
              _writerController.clear();
              Get.back(result: modifyNpc);
            });
          },
        ),
      ),
    );
  }
}
