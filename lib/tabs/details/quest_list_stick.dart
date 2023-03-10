import 'dart:math';

import 'package:bike_adventure/constants/area_num.dart';
import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/tabs/details/detail_quest_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestListStick extends StatelessWidget {
  const QuestListStick({Key? key, required this.quest, required this.eType}) : super(key: key);
  final Quest quest;
  final eQuestBinding eType;

  @override
  Widget build(BuildContext context) {
    final ProfileController _profileController = Get.find<ProfileController>();
    // var isInGuild = Random().nextBool();
    // var isCompletedQuest = Random().nextBool();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: () async {
          // eQuestBinding eType = _profileController.getQuestBindingType(attr.qid);
          final result = await Get.to(() => DetailQuestPage(quest: quest, eBinding: eType,),
              transition: Transition.rightToLeftWithFade);
        },
        child: Container(
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: getImageUrl(quest.getThumbnail()),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                // flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // flex: 16,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  getQuestIcon(quest.type.index),
                                  Expanded(
                                    // flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        quest.name,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            child: Icon(
                                              Icons.done_all_outlined,
                                              size: 17,
                                              color: COMPLETED_COUNT_COLOR,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0),
                                            child: Text(
                                              quest.completeCount > 9999 ? '9999' :
                                              quest.completeCount.toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  overflow:
                                                  TextOverflow.ellipsis),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Obx(() =>InkWell(
                                    onTap: () async {
                                      // await _profileController.acceptOrCancelQuest(attr);
                                    },
                                    child: _profileController.getQuestSimpleIcon(quest.qid),
                                  ),),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        quest.location,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    quest.youtubeUrl.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/icons/youtube.png',
                              width: 15,
                              height: 15,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              quest.youtubeUrl,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        quest.writer!.nick,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
