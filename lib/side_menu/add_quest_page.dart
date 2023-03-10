import 'dart:io';

import 'package:bike_adventure/constants/error_type.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/side_menu/widgets/view_information.dart';
import 'package:bike_adventure/side_menu/widgets/view_kakao_web.dart';
import 'package:bike_adventure/side_menu/widgets/view_add_picture.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/quest_gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/gallery_item_thumbnail.dart';

class AddQuestPage extends StatefulWidget {
  const AddQuestPage({Key? key}) : super(key: key);

  @override
  _AddQuestPageState createState() => _AddQuestPageState();
}

class _AddQuestPageState extends State<AddQuestPage> {
  bool isUpload = true;
  final WriterQuestController _writerController =
      Get.find<WriterQuestController>();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
    controller: _scrollController,
    slivers: [
      _buildAppBar(),
      Obx(() => SliverList(
            delegate: SliverChildListDelegate([
              GradientCard(
                isCompleted: _writerController.isCompletedOpenMap.value,
                child: _cardQuestMenuMap(
                    _writerController.isCompletedOpenMap.value),
              ),
              GradientCard(
                  isCompleted:
                      _writerController.isCompletedOpenPicture.value,
                  child: _cardQuestMenuPicture(
                      _writerController.isCompletedOpenPicture.value)),
              GradientCard(
                  isCompleted: _writerController.isCompletedOpenInfo.value,
                  child: _cardQuestMenuInfo(
                      _writerController.isCompletedOpenInfo.value)),
              addQuestButton(context),
              const SizedBox(
                height: 20,
              ),
            ]),
          )),
    ],
      ),
    );
  }

  Padding addQuestButton(BuildContext context) {
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
                "????????? ????????????",
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            var result = _writerController.isValidAddQuest();
            if (result == ERR_NOT_SET_LOCATION) {
              pushSnackbar('????????? ?????? ??????', '????????? ??????????????????');
              _scrollController.animateTo(150,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              return;
            } else if (result == ERR_NOT_SET_PICTURE) {
              pushSnackbar('????????? ?????? ??????', '????????? ??????????????????');
              _scrollController.animateTo(150,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              return;
            } else if (result == ERR_NOT_SET_NAME) {
              pushSnackbar('????????? ?????? ??????', '????????? ??????????????????');

              return;
            } else if (result == ERR_NOT_VALID_YOUTUBE) {
              pushSnackbar('????????? ?????? ??????', 'YOUTUBE URL??? ??????????????? ????????????');

              return;
            }

            showAlertDialog(context, "????????? ?????? ???...");
            bool ret = await _writerController.insertQuest();

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
              if (ret) {
                _writerController.clear();
              }

              Get.back(result: {'result': ret});
            });
          },
        ),
      ),
    );
  }

  _cardQuestMenuInfo(bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ListTile(
          leading: Icon(
            Icons.history_edu_rounded,
            color: Colors.deepPurpleAccent,
            size: 30,
          ),
          title: Text(
            '?????? ?????????',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ViewInformation(),
        ),
      ],
    );
  }

  _cardQuestMenuMap(bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          leading: Icon(
            Icons.add_location_rounded,
            color: Colors.deepPurpleAccent,
            size: 30,
          ),
          title: Text(
            '?????? ????????????',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isCompleted
                  ? const Text('???????????? ???????????? ?????? ????????? ??????????????????.',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black))
                  : Text.rich(TextSpan(
                      text: '????????? ????????? ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12),
                      children: [
                          TextSpan(
                              text: _writerController.addressName.value,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          const TextSpan(
                            text: ' ?????????.',
                          ),
                        ])),
              const Text('?????? ??????????????? ?????? ?????? ?????? 100m ???????????? ????????? ????????? ??? ??? ????????????.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        ButtonBar(
          buttonPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          buttonHeight: 50,
          children: [
            !isCompleted
                ? ElevatedButton.icon(
                    icon: const Icon(
                      Icons.public_rounded,
                      size: 20,
                    ),
                    label: const Text("?????? ??????"),
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () async {
                      final result = await Get.to(() => const ViewKakaoWeb(),
                          transition: Transition.rightToLeftWithFade);
                      if (result != null && result['result']) {
                        _writerController.completedOpenMapState(result["lat"],
                            result["lng"], result["address_name"]);
                      }
                    },
                  )
                : ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 20,
                    ),
                    label: const Text(
                      "????????????",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurpleAccent),
                    onPressed: () async {
                      final result = await Get.to(() => const ViewKakaoWeb(),
                          transition: Transition.rightToLeftWithFade);
                      if (result != null && result['result']) {
                        _writerController.completedOpenMapState(result["lat"],
                            result["lng"], result["address_name"]);
                      }
                    },
                  ),
          ],
        ),
      ],
    );
  }

  _cardQuestMenuPicture(bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          leading: Icon(
            Icons.add_a_photo_rounded,
            color: Colors.deepPurpleAccent,
            size: 30,
          ),
          title: Text(
            '?????? ????????????',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: isCompleted
              ? Row(
                  children: [
                    Card(
                      child: Container(
                        // height: 80,
                        height: 90,
                        padding: const EdgeInsets.all(10.0),
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(
                                _writerController.mainPicture.value)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                            '${_writerController.uploadPictures.length} ?????? ?????? ????????? ????????????.',
                            style: const TextStyle(fontWeight: FontWeight.w400)),
                        const Text('?????? ????????? ?????? ???????????????.',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('?????? ?????? ????????? ?????? ??? ????????????.',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('?????? ??? ??? ????????? ????????? ???????????????.',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
        ),
        ButtonBar(
          buttonPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          buttonHeight: 50,
          children: [
            !isCompleted
                ? ElevatedButton.icon(
                    icon: const Icon(
                      Icons.insert_photo_rounded,
                      size: 20,
                    ),
                    label: const Text("????????? ??????"),
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () async {
                      final result = await Get.to<GalleryItem>(
                          () => ViewAddPicture(
                              images: _writerController.uploadPictures),
                          transition: Transition.rightToLeftWithFade);

                      if (result != null) {
                        _writerController.completedOpenPicture(result);
                      }
                    },
                  )
                : ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 20,
                    ),
                    label: const Text("????????????"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurpleAccent),
                    onPressed: () async {
                      final result = await Get.to<GalleryItem>(
                          () => ViewAddPicture(
                              images: _writerController.uploadPictures),
                          transition: Transition.rightToLeftWithFade);
                      if (result != null) {
                        _writerController.completedOpenPicture(result);
                      }
                    },
                  ),
          ],
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar() {
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
                width: 10,
              ),
              const Text(
                '????????? ??????',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),

        ],
      ),
      actions: [        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.cancel_rounded)),],
    );
  }
}
