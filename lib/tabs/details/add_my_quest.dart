import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/constants/error_type.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/side_menu/widgets/success_add.dart';
import 'package:bike_adventure/side_menu/widgets/view_kakao_web.dart';
import 'package:bike_adventure/tabs/details/gallery_photo_view_wrapper.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddMyQuest extends StatefulWidget {
  const AddMyQuest({Key? key}) : super(key: key);

  @override
  State<AddMyQuest> createState() => _AddMyQuestState();
}

class _AddMyQuestState extends State<AddMyQuest> {
  bool isUpload = true;
  final WriterQuestController writerController =
      Get.find<WriterQuestController>();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
              explainBox(),
              addQuestButton(context),
            ])),
          ],
        )),
      ),
    );
  }

  Padding explainBox() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
          '매직 카페 라이더는 퀘스트를 완료하기 위해 자기 자신의 위치 정보를 사용합니다. '
              '반경 100m 안에서만 퀘스트를 완료 할 수 있기 때문입니다.'),
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
                '퀘스트 추가',
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
          Obx(() => SizedBox(
              width: 40,
              child: writerController.isCompletedOpenInfo.value
                  ? const Icon(Icons.check_box, size: 40, color: Colors.green)
                  : const Icon(
                      Icons.add_box,
                      size: 40,
                    ))),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: TextField(
                textInputAction: TextInputAction.go,
                controller: writerController.nameEditingController,
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
                  labelText: '카페 또는 상점 명',
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
              child: Icon(
                Icons.check_box,
                size: 40,
                color: Colors.green,
              )),
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
                      getQuestIcon(writerController.questType.index,
                          size: 18.0, color: Colors.black),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(getQuestTypeText(writerController.questType.index)),
                    ],
                  ),
                  onSelected: (result) {
                    setState(() {
                      writerController.questType = result as eQuestType;
                    });
                  },
                  itemBuilder: (_) => eQuestType.values
                      .map((e) => PopupMenuItem(
                          value: e,
                          child: Text(
                            getQuestTypeText(e.index),
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
          Obx(() => SizedBox(
              width: 40,
              child: writerController.isCompletedOpenMap.value
                  ? const Icon(Icons.check_box, size: 40, color: Colors.green)
                  : const Icon(
                      Icons.add_box,
                      size: 40,
                    ))),
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
                label: Obx (() =>Text(
                  writerController.isCompletedOpenMap.value ? writerController.addressName.value : "위치 지정하기",
                  style: const TextStyle(color: Colors.black),
                )),
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () async {
                  final result = await Get.to(() => const ViewKakaoWeb(),
                      transition: Transition.rightToLeftWithFade);
                  if (result != null && result['result']) {
                    writerController.completedOpenMapState(
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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            addPicture(),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: writerController.uploadPictures.isNotEmpty ? SizedBox(
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: writerController.uploadPictures.length,
                  itemBuilder: (_, index) {
                    return GalleryItemThumbnail(
                      item: writerController.uploadPictures[index],
                      onTap: () {
                        openPicture(context, index);
                      },
                    );
                  },
                ),
              ) : InkWell(
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
                      writerController.uploadPictures.addAll(items);
                      writerController.completedOpenMultiPicture();
                    });
                  }
                },
                child: const SizedBox(
                  height: 100,
                  child: Center(child: Text('사진 추가하기')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addPicture() {
    return InkWell(
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
                  writerController.uploadPictures.addAll(items);
                  writerController.completedOpenMultiPicture();
                });
              }
            },
            child: Container(
              height: 100,
              width: 70,
              decoration: BoxDecoration(
                color: !writerController.isCompletedOpenPicture.value
                    ? Colors.black
                    : Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: const Icon(
                Icons.add_box,
                size: 70,
                color: Colors.white,
              ),
            ),
          );
  }

  void openPicture(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: writerController.uploadPictures,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
          needDeleteButton: false,
        ),
      ),
    );
  }

  addQuestButton(BuildContext context) {
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
                "퀘스트 추가하기",
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            var result = writerController.isValidAddQuest();
            if (result == ERR_NOT_SET_LOCATION) {
              pushSnackbar('퀘스트 등록 설정', '위치를 등록해주세요');
              return;
            } else if (result == ERR_NOT_SET_PICTURE) {
              pushSnackbar('퀘스트 등록 설정', '사진을 등록해주세요');
              return;
            } else if (result == ERR_NOT_SET_NAME) {
              pushSnackbar('퀘스트 등록 설정', '이름을 등록해주세요');

              return;
            } else if (result == ERR_NOT_VALID_YOUTUBE) {
              pushSnackbar('퀘스트 등록 설정', 'YOUTUBE URL이 정상적이지 않습니다');

              return;
            }

            showAlertDialog(context, "퀘스트 추가 중...");
            bool ret = await writerController.insertQuest();

            Future.delayed(const Duration(seconds: 2), () async {
              Navigator.pop(context);
              if (ret) {
                writerController.clear();
                await Get.to(
                        () => const SuccessAdd(
                      text: '퀘스트',
                      assetPath: 'assets/icons/quest3.png',
                    ),
                    transition: Transition.upToDown);
              }
              else {
                pushSnackbar('퀘스트', '등록에 실패하였습니다.');
              }

              Get.offAll(()=>const MainPage());
              // Get.offAll(()=>const MainPage());
              // Get.offUntil('/main', (route) => false);
              // Get.offUntil(const MainPage(), (Route<dynamic> route) => false);
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              //     MainPage()), (Route<dynamic> route) => false);
            });
          },
        ),
      ),
    );
  }
}
