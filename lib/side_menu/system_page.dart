import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/logo_page.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/side_menu/block_user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({Key? key}) : super(key: key);

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getBlockUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Get.back();
              }),
          centerTitle: true,
          title: const Text(
            '시스템',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Obx(buildBlackUserList),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        showDeleteAlertDialog(context);
                      },
                      child: const Text(
                        '회원 탈퇴 & 계정 삭제',
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                    const Text(
                      '회원 탈퇴되며, 동시에 회원이 작성한 리뷰, 퀘스트 완료 및 발자취 로그는 디비에서 영구히 삭제되며, 다시 복구 불가능합니다.',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        showLogoutAlertDialog(context);
                      },
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                    const Text(
                      '일반적인 로그아웃이며, 다른 계정으로 로그인하거나 최초 화면으로 돌아가기 위해 사용합니다. 자동로그인은 일시적으로 취소됩니다.',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildBlackUserList() {
    if (profileController.blockUserList.isNotEmpty) {
      return Container(
        height: 200,
        child: ListView.builder(
            itemCount: profileController.blockUserList.length,
            itemBuilder: (_, index) {
              return BlockUserBox(user: profileController.blockUserList[index]);
            }),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Center(
        child: Text('차단한 유저 리스트가 없습니다.'),
      ),
    );
  }

  showLogoutAlertDialog(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetCircularProgressIndicator("로그아웃 중입니다."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) async {});

    await profileController.userLogOut();
    Get.offAll(() => const LogoPage());
  }

  showDeleteAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetYesOrNo('정말 회원 탈퇴 및 삭제 하시겠습니까? 영구적으로 삭제되며 더이상 복구 불가능합니다.', height: 180.0),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        showDeleteAlertDialog2(context);
      }
    });
  }

  showDeleteAlertDialog2(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetCircularProgressIndicator("회원 탈퇴 및 삭제 중..."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) async {});

    profileController.leaveApp();
    await profileController.userLogOut();

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const LogoPage());
    });
  }
}

class BlockUserBox extends StatelessWidget {
  const BlockUserBox({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white.withOpacity(0.9),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 6.0, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: user.avatar.isNotEmpty
                          ? Image.network(
                              user.avatar,
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            )
                          : Image.asset(
                              'assets/icons/nobody_avatar3.png',
                              scale: 3,
                            ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.nick,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                '@' +
                                    getBikeText(user.bikeBrand, user.bikeModel),
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 11,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    profileController.nonBlockUser(user.uid);
                  },
                  child: const Text(
                    '차단해제',
                    style: TextStyle(fontSize: 12),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
