import 'package:bike_adventure/tabs/group_drive/add_friends.dart';

import 'package:bike_adventure/tabs/group_drive/kakao_map_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDrivePage extends StatefulWidget {
  const GroupDrivePage({Key? key}) : super(key: key);

  @override
  State<GroupDrivePage> createState() => _GroupDrivePageState();
}

class _GroupDrivePageState extends State<GroupDrivePage> {
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            KakaoMapViewer(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          heroTag: "addFriend",
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.add,
            size: 32,
          ),
          onPressed: () async {
            final result = await Get.to(() => AddFriends(),
                transition: Transition.rightToLeftWithFade);
          },
        ));
  }
}
