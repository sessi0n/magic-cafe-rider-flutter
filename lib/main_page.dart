import 'dart:io';

import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/service_codec_page.dart';
import 'package:bike_adventure/side_menu/add_npc_page.dart';
import 'package:bike_adventure/side_menu/add_quest_page.dart';
import 'package:bike_adventure/side_menu/widgets/success_add.dart';
import 'package:bike_adventure/tabs/details/view_map_new_window.dart';
import 'package:bike_adventure/tabs/group_drive_page.dart';
import 'package:bike_adventure/tabs/my_detail_page.dart';
import 'package:bike_adventure/tabs/quest_page.dart';
import 'package:bike_adventure/tabs/npc_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/tab_bar_material_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.initialPage = 0}) : super(key: key);
  final int initialPage;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  // TabController? mainTabController;
  final ProfileController profileController = Get.find<ProfileController>();
  final WriterQuestController writerController =
  Get.find<WriterQuestController>();

  bool isFirst = true;

  int index = 0;
  String myUid = '';
  final pages = const [
    QuestPage(),
    NpcPage(),
    MyDetailPage(),
    // MyQuestPage(),
    // RankPage(),
    // SalePage(),
    GroupDrivePage()
  ];

  @override
  void initState() {
    super.initState();


    setState(() {
      index = widget.initialPage;
    });

    setFirst();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState((){
        myUid = profileController.profile!.uid;
      });

      if (profileController.profile!.serviceCodec == false) {
        final result = await Get.to(() => const ServiceCodecPage(), transition: Transition.downToUp);
        if (result == null || result == false) {
          exit(0);
        }
        else {
          profileController.setServiceCodec();
        }
      }

    });
  }

  setFirst() async {
    // await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isFirst = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // showAddAlertDialog(context);
            // await Get.to(() => const AddMyQuest(),
            //     transition: Transition.downToUp);
            await Get.to(() => const ViewMapNewWindow(),
                transition: Transition.leftToRight);
            writerController.clear();
          },
          backgroundColor: Colors.black,
          elevation: 10,
          child: const FaIcon(FontAwesomeIcons.locationCrosshairs,
            size: 26,
            color: Colors.white),
          // const Icon(
          //   Icons.add_rounded,
          //   color: Colors.white,
          //   size: 42,
          // ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        body: pages[index],
        bottomNavigationBar: TabBarMaterialWidget(
          index: index,
          onChangedTab: onChangedTab,
        ),
      ),
    );
  }

  onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }
}

showAddAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black.withOpacity(0.3),
    content: alertDialogWidgetWrite(),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ).then((result) async {
    if (result != null) {
      if (result) {
        final result = await Get.to(() => const AddQuestPage(),
            transition: Transition.downToUp);
        if (result == null) {
          //아무것도 안함
          return;
        }

        if (result['result']) {
          final result = await Get.to(
                  () => const SuccessAdd(
                text: '퀘스트',
                assetPath: 'assets/icons/quest3.png',
              ),
              transition: Transition.upToDown);
        } else {
          pushSnackbar('퀘스트', '등록에 실패하였습니다.');
        }
      }
      else {
        final result = await Get.to(() => const AddNPCPage(),
            transition: Transition.downToUp);
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
              transition: Transition.upToDown);
        } else {
          pushSnackbar('NPC', '등록에 실패하였습니다.');
        }
      }
    }
  });
}
