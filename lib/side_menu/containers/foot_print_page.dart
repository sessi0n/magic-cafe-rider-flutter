import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/foot_print_log.dart';
import 'package:bike_adventure/side_menu/widgets/foot_log_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FootPrintPage extends StatefulWidget {
  const FootPrintPage({Key? key}) : super(key: key);

  @override
  State<FootPrintPage> createState() => _FootPrintPageState();
}

class _FootPrintPageState extends State<FootPrintPage> {
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
            '발자취 로그',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          getFootIcon(eFootType.NORMAL),
                          const SizedBox(width: 10),
                          Text('+${getFootScore(eFootType.NORMAL)}', style: const TextStyle(fontSize: 14, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          getFootIcon(eFootType.EVENT),
                          const SizedBox(width: 10),
                          Text('+${getFootScore(eFootType.EVENT)}', style: const TextStyle(fontSize: 14, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          getFootIcon(eFootType.COMPLETED),
                          const SizedBox(width: 10),
                          Text('+${getFootScore(eFootType.COMPLETED)}', style: const TextStyle(fontSize: 14, color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              buildBlackUserList(),
            ],
          ),
        ),
        );
  }

  Widget buildBlackUserList() {
    if (footPrintLogs.isNotEmpty) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: footPrintLogs.length,
          itemBuilder: (_, index) {
            return FootLogCard(footLog: footPrintLogs[index]);
          });
    }
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Center(
        child: Text('발자취가 없습니다.'),
      ),
    );
  }
}

