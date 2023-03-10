import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/friend.dart';
import 'package:bike_adventure/tabs/group_drive/add_friend_qr.dart';
import 'package:bike_adventure/tabs/group_drive/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  ProfileController profileController = Get.find<ProfileController>();
  List<Friend> friends = [];
  var emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      friends = await profileController.getFriends();
      setState(() {
        friends;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Get.back();
              }
          ),
          leadingWidth: 40,
          title: const Text(
            '동행 등록 및 수정',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(child: buildFriendList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: ElevatedButton.icon(
                      onPressed: (){
                        _onAlertWithCustomContentPressed(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white //elevated btton background color
                      ),
                      icon: const FaIcon(FontAwesomeIcons.circlePlus,
                          color: Colors.teal, size: 20),
                      label: const Text(
                      '동행 추가 by Email',
                      style: TextStyle(fontSize: 12, color: Colors.black))),
                ),
                SizedBox(
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        await Get.to(() => AddFriendQr(onScanQR: onScanQR),
                            transition: Transition.rightToLeftWithFade);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white //elevated btton background color
                      ),
                      icon: const FaIcon(FontAwesomeIcons.circlePlus,
                          color: Colors.teal, size: 20),
                      label: const Text(
                          '동행 추가 by QR',
                          style: TextStyle(fontSize: 12, color: Colors.black))),
                ),
              ],
            )
          ],
        ));
  }

  Future<bool> onScanQR(String? code) async {
    if (code == null || code.isEmpty) {
      return false;
    }

    friends = await profileController.addFriend('', code);
    setState(() {
      friends;
    });

    Get.back();

    return friends.isNotEmpty ? true : false;
  }

  Future<bool> onUpdateFriend(String fid, bool isUnpair, bool isPairing, bool isAccept) async {
    friends = await profileController.updateFriend(fid, isUnpair, isPairing, isAccept);
    setState(() {
      friends;
    });

    return true;
  }

  Future<bool> onDeleteFriend(String fid) async {
    friends = await profileController.delFriends(fid);
    setState(() {
      friends;
    });

    return true;
  }

  Widget buildFriendList() {
    if (friends.isNotEmpty) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: friends.length,
          itemBuilder: (_, index) {
            return FriendCard(friend: friends[index], onUpdateFriend: onUpdateFriend, onDeleteFriend: onDeleteFriend);
          });
    }
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Center(
        child: Text('동행 친구가 없습니다.'),
      ),
    );
  }

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "Email로 동행 찾기",
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'Email',
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              friends = await profileController.addFriend(emailController.text, '');
              setState(() {
                friends;
              });
              Get.back();
            },
            child: Text(
              "동행 찾기",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }


}
