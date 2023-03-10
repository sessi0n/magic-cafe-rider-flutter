import 'dart:io';

import 'package:bike_adventure/constants/error_type.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/writer_npc_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:bike_adventure/side_menu/widgets/view_add_picture.dart';
import 'package:bike_adventure/side_menu/widgets/view_kakao_web.dart';
import 'package:bike_adventure/widget/quest_gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNPCPage extends StatefulWidget {
  const AddNPCPage({Key? key}) : super(key: key);

  @override
  _AddNPCPageState createState() => _AddNPCPageState();
}

class _AddNPCPageState extends State<AddNPCPage> {
  bool isUpload = true;
  final WriterNpcController _writerController = Get.find<WriterNpcController>();

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
              _writerController.npcType == eNpcType.WEBSTORE ? Container() : GradientCard(
                isCompleted: _writerController.isCompletedOpenMap.value,
                child: _cardQuestMenuMap(
                    _writerController.isCompletedOpenMap.value),
              ),
              GradientCard(
                  isCompleted:
                      _writerController.isCompletedOpenPicture.value,
                  child: _cardMenuPicture(
                      _writerController.isCompletedOpenPicture.value)),
              GradientCard(
                  isCompleted: _writerController.isCompletedOpenInfo.value,
                  child: _cardMenuInfo(
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
                  ? Column(
                      children: const [
                        Text('???????????? NPC ????????? ??????????????????.',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                        Text('??? ???????????? ????????? ?????? ????????????.',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ],
                    )
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
              // const Text('?????? ??????????????? ?????? ?????? ?????? 100m ???????????? ????????? ????????? ??? ??? ????????????.',
              //     style: TextStyle(fontWeight: FontWeight.w500)),
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
                "NPC ????????????",
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            var result = _writerController.isValidAddNpc();
            if (result == ERR_NOT_SET_LOCATION) {
              pushSnackbar('NPC ?????? ??????', '????????? ??????????????????');
              _scrollController.animateTo(150,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              return;
            } else if (result == ERR_NOT_SET_PICTURE) {
              pushSnackbar('NPC ?????? ??????', '????????? ??????????????????');
              _scrollController.animateTo(150,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              return;
            } else if (result == ERR_NOT_SET_NAME) {
              pushSnackbar('NPC ?????? ??????', '????????? ??????????????????');
              return;
            } else if (result == ERR_NOT_SET_WEB_STORE) {
              pushSnackbar('NPC ?????? ??????', 'WEB-STORE URL??? ??????????????????');
              return;
            } else if (result == ERR_NOT_VALID_WEB_STORE) {
              pushSnackbar('NPC ?????? ??????', 'WEB-STORE URL??? ??????????????? ????????????');
              return;
            } else if (result == ERR_NOT_VALID_YOUTUBE) {
              pushSnackbar('NPC ?????? ??????', 'YOUTUBE URL??? ??????????????? ????????????');
              return;
            }


            showAlertDialog(context, "NPC ?????? ???...");
            bool ret = await _writerController.insertNpc();

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

  _cardMenuInfo(bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _npcTypeMenuButton(),
            const SizedBox(
              height: 20,
            ),
            // _buildQuestType(),
            _buildNpcName(),
            const SizedBox(
              height: 20,
            ),
                _buildWebUrl(),
                const SizedBox(
                  height: 20,
                ),
            _buildYoutubeUrl(),
            const SizedBox(
              height: 20,
            ),
            // _parkingSizeMenuButton(),
            // const SizedBox(
            //   height: 20,
            // ),
          ]),
        ),
      ],
    );
  }

  TextField _buildWebUrl() {
    return TextField(
      controller: _writerController.storeUrlEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _writerController.storeUrlEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        labelText: 'WEB URL',
        labelStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  TextField _buildYoutubeUrl() {
    return TextField(
      controller: _writerController.youtubeEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _writerController.youtubeEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        labelText: '????????? URL',
        labelStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        // focusedBorder: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //   borderSide: BorderSide(width: 1, color: Colors.green),
        // ),
        // enabledBorder: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //   borderSide: BorderSide(width: 1, color: Colors.green),
        // ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildNpcName() {
    return TextField(
      controller: _writerController.nameEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.ac_unit_rounded,
          color: Colors.black,
          size: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _writerController.nameEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        labelText: '${getNpcTypeText(_writerController.npcType.index)} ??????',
        labelStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildNpcAddress() {
    return TextField(
      controller: _writerController.nameEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.ac_unit_rounded,
          color: Colors.black,
          size: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _writerController.nameEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        labelText: '${getNpcTypeText(_writerController.npcType.index)} ??????',
        labelStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _npcTypeMenuButton() {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
          // color: Colors.indigo,
          gradient: LinearGradient(colors: [Colors.white70, Colors.white]),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
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
    );
  }

  _cardMenuPicture(bool isCompleted) {
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
                        padding: EdgeInsets.all(10.0),
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(
                                _writerController.mainPicutre.value as String)),
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
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        Text('?????? ????????? ?????? ???????????????.',
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
                AssetImage('assets/icons/box4.png'),
                size: APP_BAR_ICONS_SIZE,
                color: Colors.white,
              ),
              Container(
                width: 10,
              ),
              const Text(
                'NPC ??????',
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
            icon: Icon(Icons.cancel_rounded)),
      ],
    );
  }
}
