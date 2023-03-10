import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/foot_print_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StampLogPage extends StatefulWidget {
  const StampLogPage({Key? key}) : super(key: key);

  @override
  State<StampLogPage> createState() => _StampLogPageState();
}

class _StampLogPageState extends State<StampLogPage> {
  ProfileController profileController = Get.find<ProfileController>();
  List<FootPrintLog> footPrintLogs = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      footPrintLogs = await profileController.getFootPrintLog(profileController.profile!.uid);
      setState(() {
        footPrintLogs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            '발자취 로그',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            buildBlackUserList(),

          ],
        ));
  }

  Widget buildBlackUserList() {
    if (footPrintLogs.isNotEmpty) {
      return ListView.builder(
          itemCount: footPrintLogs.length,
          itemBuilder: (_, index) {
            return BlockUserBox(footLog: footPrintLogs[index]);
          });
    }
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Center(
        child: Text('차단한 유저 리스트가 없습니다.'),
      ),
    );
  }
}

class BlockUserBox extends StatelessWidget {
  const BlockUserBox({Key? key, required this.footLog}) : super(key: key);
  final FootPrintLog footLog;

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
              // Expanded(
              //   child: Row(
              //     children: [
              //       ClipOval(
              //         clipBehavior: Clip.antiAlias,
              //         child: user.avatar.isNotEmpty
              //             ? Image.network(
              //           user.avatar,
              //           fit: BoxFit.cover,
              //           height: 40,
              //           width: 40,
              //         )
              //             : Image.asset(
              //           'assets/icons/nobody_avatar3.png',
              //           scale: 3,
              //         ),
              //       ),
              //       Flexible(
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 user.nick,
              //                 maxLines: 1,
              //                 style: const TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 12,
              //                     overflow: TextOverflow.ellipsis),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.only(top: 4.0),
              //                 child: Text(
              //                   '@' +
              //                       getBikeText(user.bikeBrand, user.bikeModel),
              //                   maxLines: 1,
              //                   style: const TextStyle(
              //                       color: Colors.black54,
              //                       fontSize: 11,
              //                       overflow: TextOverflow.ellipsis),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // TextButton(
              //     onPressed: () {
              //       profileController.nonBlockUser(user.uid);
              //     },
              //     child: const Text(
              //       '차단해제',
              //       style: TextStyle(fontSize: 12),
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
