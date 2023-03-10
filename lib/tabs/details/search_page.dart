import 'package:bike_adventure/constants/area_num.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/npc_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/models/npc.dart';

enum SearchPageType {
  quest,
  npc,
}

class SearchPage extends StatelessWidget {
  SearchPage({Key? key, required this.pageType}) : super(key: key);
  final SearchPageType pageType;

  final ProfileController _profileController = Get.find<ProfileController>();
  final QuestController _questController = Get.find<QuestController>();
  final NpcController _npcController = Get.find<NpcController>();

  var scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Get.back(result: {'result': false});
            }),
        leadingWidth: 40,
        title: const Text(
          '검색',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _widgetSearch(),
              TextField(
                textInputAction: TextInputAction.go,
                controller: textEditingController,
                onSubmitted: (text) async {
                  textEditingController.text = text;
                  showAlertDialog(context, "검색 중...");
                  if (pageType == SearchPageType.quest) {
                    await _questController.getSearchQuestData(
                        type: SearchType.NAME, isInit: true, name: text);
                  } else if (pageType == SearchPageType.npc) {
                    await _npcController.getSearchNpcData(
                        type: NpcSearchType.NAME, isInit: true, name: text);
                  }
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                    textEditingController.clear();
                    Get.back();
                  });
                },
                maxLines: 1,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HINT_BOX_DECO_COLOR,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Search for something',
                    hintStyle: const TextStyle(fontSize: 12),
                    // prefixIcon: Icon(Icons.search),
                    suffixIcon: const Icon(Icons.search)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12),
                child: Text(
                  '타입별 검색어',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              pageType == SearchPageType.quest
                  ? Wrap(
                children: eQuestType.values
                    .map((e) => buildQuestTypeButton(context, e))
                    .toList(),
              )
                  : Container(),
              pageType == SearchPageType.npc
                  ? Wrap(
                children: eNpcType.values
                    .map((e) => buildNpcTypeButton(context, e))
                    .toList(),
              )
                  : Container(),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12),
                child: Text(
                  '지역 검색어',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              Wrap(
                children: _profileController.areaMaps
                    .map((e) => buildAreaButton(context, e.name, e.code))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAreaButton(context, String areaName, int areaCode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          showAlertDialog(context, "검색 중...");
          if (pageType == SearchPageType.quest) {
            await _questController.getSearchQuestData(
                type: SearchType.AREA, isInit: true, area: areaCode);
          } else if (pageType == SearchPageType.npc) {
            await _npcController.getSearchNpcData(
                type: NpcSearchType.AREA, isInit: true, area: areaCode);
          }
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
            textEditingController.clear();
            Get.back();
          });

        },
        child: Text(
          '#$areaName',
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }

  Widget buildQuestTypeButton(context, eQuestType e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          showAlertDialog(context, "검색 중...");
          await _questController.getSearchQuestData(
              type: SearchType.JOB, isInit: true, qType: e);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
            textEditingController.clear();
            Get.back();
          });

        },
        child: Text(
          '#${getQuestTypeText(e.index)}',
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }

  Widget buildNpcTypeButton(context, eNpcType e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          showAlertDialog(context, "검색 중...");

          await _npcController.getSearchNpcData(
              type: NpcSearchType.JOB, isInit: true, nType: e);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
            textEditingController.clear();
            Get.back();
          });

        },
        child: Text(
          '#${getNpcTypeText(e.index)}',
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }

  // showAlertDialog(BuildContext context) {
  //   AlertDialog alert = AlertDialog(
  //     content: Row(
  //       children: [
  //         const CircularProgressIndicator(),
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         Container(
  //             margin: const EdgeInsets.only(left: 5), child: const Text("검색 중...")),
  //       ],
  //     ),
  //   );
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
