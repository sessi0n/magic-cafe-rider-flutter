import 'dart:io';

import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/models/agit.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const H_PADDING_SIZE = 12.0;
const V_PADDING_SIZE = 0.0;

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final QuestController questController = Get.find<QuestController>();

  File? imageFile;
  Motorcycle? motoBrand;
  BrandMotoBrandMoto? motoBike;
  var youtubeEditingController = TextEditingController();
  var instagramEditingController = TextEditingController();
  var youtubeText = '';
  var instagramText = '';
  List<Agit> agitList = [];
  var myAgit = 0;

  @override
  void initState() {
    motoBrand = _profileController.getMyMotoBrand();
    motoBike = _profileController.getMyMotoBike();
    youtubeText = _profileController.getYoutubeText();
    instagramText = _profileController.getInstagramText();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      agitList =
          await questController.getAgitList(_profileController.profile!.uid);

      setState(() {
        myAgit = _profileController.profile!.agit;
        agitList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          floating: false,
          pinned: true,
          snap: false,
          centerTitle: false,
          title: _buildTitleBar(),
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.white,
                )),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 300,
            color: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _profileController.getMyAvatarImg(),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: Text(
                        _profileController.profile!.nick,
                        style: const TextStyle(
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 25),
                      )),
                    ],
                  ),
                  Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       '길드 점수',
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           overflow: TextOverflow.ellipsis,
                      //           fontSize: 18),
                      //     ),
                      //     Text(
                      //       '${_profileController.profile!.guildPoint} P',
                      //       style: const TextStyle(
                      //           color: Colors.white,
                      //           overflow: TextOverflow.ellipsis,
                      //           fontSize: 18),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '모험 점수',
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18),
                          ),
                          Text(
                            '${_profileController.profile!.score} P',
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: H_PADDING_SIZE, vertical: 12),
              child: Text(
                '개인 표지판',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            _buildProfileImg(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: H_PADDING_SIZE, vertical: 12),
              child: Text(
                '대표 바이크 세팅',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          // color: Colors.indigo,
                          //   gradient: LinearGradient(
                          //       colors: [Colors.white70, Colors.white]),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      child: Center(
                        child: PopupMenuButton(
                          // icon: Icon(Icons.local_parking_rounded),
                          child: Text(motoBrand!.name,
                              style: const TextStyle(fontSize: 12)),
                          onSelected: (result) {
                            setState(() {
                              setState(() {
                                motoBrand = result as Motorcycle;
                                motoBike = _profileController
                                    .allMotoBrandBikes[0].bikes[0];
                              });
                              _profileController.setMyMotoCycle(
                                  motoBrand!.code, motoBike!.code);
                            });
                          },
                          itemBuilder: (_) =>
                              _profileController.allMotoBrandBikes
                                  .map((e) => PopupMenuItem(
                                      value: e,
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(fontSize: 12),
                                      )))
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          // color: Colors.indigo,
                          //   gradient: LinearGradient(
                          //       colors: [Colors.white70, Colors.white]),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      child: Center(
                        child: PopupMenuButton(
                          // icon: Icon(Icons.local_parking_rounded),
                          child: Text(motoBike!.bike,
                              style: const TextStyle(fontSize: 12)),
                          onSelected: (result) {
                            setState(() {
                              setState(() {
                                motoBike = result as BrandMotoBrandMoto;
                              });
                              _profileController.setMyMotoCycle(
                                  motoBrand!.code, motoBike!.code);
                            });
                          },
                          itemBuilder: (_) => motoBrand!.bikes
                              .map((e) => PopupMenuItem(
                                  value: e,
                                  child: Text(
                                    e.bike,
                                    style: const TextStyle(fontSize: 12),
                                  )))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '바이크 종류가 부족할 수 있습니다. 문의사항을 통해 추가 바이크를 알려주세요.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: H_PADDING_SIZE, vertical: 12),
              child: Text(
                '아지트 설정',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Center(
                  child: PopupMenuButton(
                    child: Text(myAgit == 0 ? '아지트 선택' : getAgitName(myAgit),
                        style: const TextStyle(fontSize: 12)),
                    onSelected: (result) {
                      setState(() {
                        setState(() {
                          myAgit = (result as Agit).qid;
                        });
                        _profileController.setMyAgit(myAgit);
                      });
                    },
                    itemBuilder: (_) =>
                        agitList
                            .map((e) => PopupMenuItem(
                                value: e,
                                child: Text(
                                  e.name,
                                  style: const TextStyle(fontSize: 12),
                                )))
                            .toList(),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '바이크 카페는 아지트로 설정 할 수 있습니다. 마치 길드처럼 카페 주인장이 길드-마스터로 활동하며, 멤버로 자동 등록 됩니다. 자주 다니는 카페를 등록 하세요!',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: H_PADDING_SIZE, vertical: 12),
              child: Text(
                '유투브 채널',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: youtubeEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.ac_unit_rounded,
                    color: Colors.black,
                    size: 12,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (youtubeEditingController.text.isEmpty) {
                        return;
                      }

                      bool isSuccess = await _profileController
                          .uploadYoutubeUrl(youtubeEditingController.text);
                      if (isSuccess) {
                        pushSnackbar('프로파일 수정', '유투브 URL이 수정됐습니다');
                        setState(() {
                          youtubeText = youtubeEditingController.text;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.upload_rounded,
                      color: Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  labelText: youtubeText,
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  hintStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: H_PADDING_SIZE, vertical: 12),
              child: Text(
                '인스타그램',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: instagramEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.ac_unit_rounded,
                    color: Colors.black,
                    size: 12,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (instagramEditingController.text.isEmpty) {
                        return;
                      }

                      bool isSuccess = await _profileController
                          .uploadInstagram(instagramEditingController.text);
                      if (isSuccess) {
                        pushSnackbar('프로파일 수정', '유투브 URL이 수정됐습니다');
                        setState(() {
                          instagramText = instagramEditingController.text;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.upload_rounded,
                      color: Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  labelText: instagramText,
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  hintStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 10),
              child: Divider(
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 40,
            ),
          ]),
        ),
      ]),
    );
  }



  Widget _buildProfileImg() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        children: [
          Obx(() => Container(
                height: 220,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                    image: DecorationImage(
                      image: NetworkImage(
                        _profileController.getMyProfileImage(),
                        // _profileController.getMyProfileImg(),
                      ),
                      fit: BoxFit.cover,
                    )),
              )),
          SizedBox(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    height: 50,
                    child: IconButton(
                      icon: const Icon(Icons.brightness_low_rounded),
                      color: Colors.white,
                      onPressed: () async {
                        final pickedImage =
                            await getImagePicker(source: ImageSource.gallery);
                        // final pickedImage = await ImagePicker()
                        //     .pickImage(source: ImageSource.gallery, imageQuality: 50);
                        imageFile =
                            pickedImage != null ? File(pickedImage.path) : null;
                        if (imageFile != null) {
                          showAlertDialog(context, "표지 변경 중...");
                          await _profileController
                              .pushProfileImage(imageFile!.path);
                          await Future.delayed(const Duration(seconds: 1));
                          Get.back();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildTitleBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const ImageIcon(
            //   AssetImage('assets/icons/equip.png'),
            //   size: APP_BAR_ICONS_SIZE,
            //   color: Colors.white,
            // ),
            const FaIcon(FontAwesomeIcons.squareParking, size: 25),
            Container(
              width: 20,
            ),
            const Text(
              '개인 설정',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              width: 50,
            ),
          ],
        ),
      ],
    );
  }

  getAgitName(int id) {
    for (Agit agit in agitList) {
      if (agit.qid == id) {
        return agit.name;
      }
    }

    return '선택한 아지트가 없습니다';
  }
}
