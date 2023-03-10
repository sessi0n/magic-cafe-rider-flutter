import 'dart:io';

import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/side_menu/add_cafe_owner.dart';
import 'package:bike_adventure/side_menu/add_npc_page.dart';
import 'package:bike_adventure/side_menu/add_sale_page.dart';
import 'package:bike_adventure/side_menu/advisor.dart';
import 'package:bike_adventure/side_menu/agit_member_page.dart';
import 'package:bike_adventure/side_menu/cafe_owner_word.dart';
import 'package:bike_adventure/side_menu/containers/foot_print_page.dart';
import 'package:bike_adventure/side_menu/help_page.dart';
import 'package:bike_adventure/side_menu/containers/profile_page.dart';
import 'package:bike_adventure/side_menu/containers/ranker_page2.dart';
import 'package:bike_adventure/side_menu/stamp_page.dart';
import 'package:bike_adventure/side_menu/containers/stamp_qr_page.dart';
import 'package:bike_adventure/side_menu/system_page.dart';
import 'package:bike_adventure/tabs/details/add_my_quest.dart';
import 'package:bike_adventure/side_menu/widgets/success_add.dart';
import 'package:bike_adventure/side_menu/containers/sale_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SideMenuPage extends StatefulWidget {
  const SideMenuPage({Key? key}) : super(key: key);

  @override
  _SideMenuPageState createState() => _SideMenuPageState();
}

class _SideMenuPageState extends State<SideMenuPage> {
  final ProfileController _profileController = Get.find<ProfileController>();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: ListView(
          children: [
            _buildSideProfile(),
            const Divider(),
            _buildSideMenu(FontAwesomeIcons.squareParking, 18,
                Colors.black.withOpacity(0.9), '개인 설정', () {
              Navigator.of(context).pop();
              Get.to(() => const ProfilePage(),
                  transition: Transition.rightToLeftWithFade);
            }),
            _buildSideMenu(FontAwesomeIcons.stamp, 17,
                Colors.black.withOpacity(0.9), '스탬프 QR', () {
              Navigator.of(context).pop();
              Get.to(() => const StampQRPage(),
                  transition: Transition.rightToLeftWithFade);
            }),
            _buildSideMenu(FontAwesomeIcons.motorcycle, 16,
                Colors.black.withOpacity(0.9), '발자취 로그', () {
              Navigator.of(context).pop();
              Get.to(() => const FootPrintPage(),
                  transition: Transition.rightToLeftWithFade);
            }),
            const Divider(),
            _buildSideMenu(FontAwesomeIcons.rankingStar, 17,
                Colors.black.withOpacity(0.9), '랭크', () async {
              Navigator.of(context).pop();

              final result = await Get.to(() => const RankerPage2(),
                  transition: Transition.rightToLeftWithFade);
            }),
            _buildSideMenu(FontAwesomeIcons.tags, 17,
                Colors.black.withOpacity(0.9), '세일', () async {
                  Navigator.of(context).pop();

                  final result = await Get.to(() => const SalePage(),
                      transition: Transition.rightToLeftWithFade);
                }),
            const Divider(),
            // buildCafeOwnerCommand(),
            buildRoleCommand(),
            const Divider(),
            _buildSideMenu(FontAwesomeIcons.paperPlane, 17,
                Colors.black.withOpacity(0.9), '사용문의/제안', () async {
              await Get.to(() => const Advisor(),
                  transition: Transition.downToUp);
            }),
            _buildSideMenu(FontAwesomeIcons.personChalkboard, 17,
                Colors.black.withOpacity(0.9), '도움말', () async {
              await Get.to(() => const HelpPage(),
                  transition: Transition.downToUp);
            }),
            _buildSideMenu(FontAwesomeIcons.display, 17,
                Colors.black.withOpacity(0.9), '시스템', () async {
              await Get.to(() => SystemPage(), transition: Transition.downToUp);
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader _buildSideProfile() {
    return UserAccountsDrawerHeader(
      accountName: Text(_profileController.profile!.nick),
      accountEmail: Text(_profileController.profile!.email),
      currentAccountPicture: InkWell(
        onTap: () async {
          // final pickedImage =
          // await ImagePicker().pickImage(source: ImageSource.gallery);
          // imageFile = pickedImage != null ? File(pickedImage.path) : null;
          // if (imageFile != null) {
          //   print('imageFile!.path ${imageFile!.path}');
          // }
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(
            child: _profileController.getMyAvatarImg(),
          ),
        ),
      ),
      decoration: const BoxDecoration(
        color: Colors.blue,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/banner/side_menu.jpg',
          ),
        ),
      ),
    );
  }

  Padding _buildSideMenuImage(icons, colors, s, onTab) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTab,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ImageIcon(
                AssetImage(icons),
                size: 17,
                color: colors,
              ),
            ),
            Text(
              s,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildSideMenuIcon(icons, colors, s, onTab) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTab,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                icons,
                size: 17,
                color: colors,
              ),
            ),
            Text(
              s,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildSideMenu(icons, double s, colors, text, onTab) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTab,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: 26,
                child: FaIcon(
                  icons,
                  size: s,
                  color: colors,
                ),
              ),
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  buildRoleCommand() {
    // 0 : user, 1: admin, 2: cafe owner
    if (_profileController.profile!.role == 1) {
      //admin
      return Column(
        children: [
          _buildSideMenu(FontAwesomeIcons.folderPlus, 17,
              Colors.green.withOpacity(0.9), '퀘스트 등록', () async {
            Navigator.of(context).pop();

            await Get.to(() => const AddMyQuest(),
                transition: Transition.downToUp);
          }),
          _buildSideMenu(FontAwesomeIcons.folderPlus, 17,
              Colors.green.withOpacity(0.9), 'NPC 등록', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const AddNPCPage(),
                transition: Transition.rightToLeftWithFade);
            if (result == null) {
              //아무것도 안함
              return;
            }
            if (result['result']) {
              final result = await Get.to(
                  () => const SuccessAdd(
                        text: 'NPC',
                        assetPath: 'assets/icons/box4.png',
                      ),
                  transition: Transition.downToUp);
            } else {
              pushSnackbar('NPC', '등록에 실패하였습니다.');
            }
          }),
          _buildSideMenu(FontAwesomeIcons.folderPlus, 17,
              Colors.green.withOpacity(0.9), 'SALE 등록', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const AddSalePage(),
                transition: Transition.rightToLeftWithFade);
            if (result == null) {
              //아무것도 안함
              return;
            }
            if (result['result']) {
              // final result = await Get.to(
              //         () => const SuccessAdd(
              //       text: 'SALE',
              //       assetPath: 'assets/icons/box4.png',
              //     ),
              //     transition: Transition.downToUp);
              pushSnackbar('SALE', '등록에 성공하였습니다.');
            } else {
              pushSnackbar('SALE', '등록에 실패하였습니다.');
            }
          }),
          _buildSideMenu(FontAwesomeIcons.folderPlus, 17,
              Colors.green.withOpacity(0.9), '카페 사장님 등록', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const AddCafeOwner(),
                transition: Transition.rightToLeftWithFade);
          }),
          _buildSideMenu(
              FontAwesomeIcons.stamp, 17, Colors.red.withOpacity(0.9), '스탬프 기능',
              () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const StampPage(),
                transition: Transition.rightToLeftWithFade);
          }),
          _buildSideMenu(FontAwesomeIcons.marker, 17,
              Colors.red.withOpacity(0.9), '카페 한마디', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const CafeOwnerWord(),
                transition: Transition.rightToLeftWithFade);
          }),
          _buildSideMenu(FontAwesomeIcons.clipboardList, 17,
              Colors.red.withOpacity(0.9), '메뉴판 등록', () async {
                final pickedImage =
                await getImagePicker(source: ImageSource.gallery);
                imageFile = pickedImage != null ? File(pickedImage.path) : null;
                if (imageFile != null) {
                  showAlertDialog(context, "메뉴판 변경 중...");
                  await _profileController.pushMenuPaper(imageFile!.path);
                  await Future.delayed(const Duration(seconds: 1));
                  Get.back();
                }
              }),
          _buildSideMenu(FontAwesomeIcons.anchor, 17,
              Colors.red.withOpacity(0.9), '아지트 멤버', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const AgitMemberPage(),
                transition: Transition.rightToLeftWithFade);
          }),
        ],
      );
    }
    if (_profileController.profile!.role == 2) {
      //admin, cafe owner
      return Column(
        children: [
          _buildSideMenu(
              FontAwesomeIcons.stamp, 17, Colors.red.withOpacity(0.9), '스탬프 기능',
              () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const StampPage(),
                transition: Transition.rightToLeftWithFade);
          }),
          _buildSideMenu(FontAwesomeIcons.wordpress, 17,
              Colors.red.withOpacity(0.9), '카페 한마디', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const CafeOwnerWord(),
                transition: Transition.rightToLeftWithFade);
          }),
          _buildSideMenu(FontAwesomeIcons.clipboardList, 17,
              Colors.red.withOpacity(0.9), '메뉴판 등록', () async {
            final pickedImage =
                await getImagePicker(source: ImageSource.gallery);
            imageFile = pickedImage != null ? File(pickedImage.path) : null;
            if (imageFile != null) {
              showAlertDialog(context, "메뉴판 변경 중...");
              await _profileController.pushProfileImage(imageFile!.path);
              await Future.delayed(const Duration(seconds: 1));
              Get.back();
            }
          }),
          _buildSideMenu(FontAwesomeIcons.anchor, 17,
              Colors.red.withOpacity(0.9), '아지트 멤버', () async {
            Navigator.of(context).pop();

            final result = await Get.to(() => const AgitMemberPage(),
                transition: Transition.rightToLeftWithFade);
          }),
        ],
      );
    }

    return Container();
  }

  buildCafeOwnerCommand() {
    return Container();
  }
}
