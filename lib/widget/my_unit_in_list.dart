import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/tabs/details/complete_quest_in_kakao_map.dart';
import 'package:bike_adventure/tabs/details/detail_quest_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MyUnitInList extends StatelessWidget {
  const MyUnitInList({Key? key, required this.index, required this.quest, required this.can})
      : super(key: key);
  final int index;
  final Quest quest;
  final bool can;

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  eQuestBinding eType =
                      profileController.getQuestBindingType(quest.qid);
                  final result = await Get.to(
                      () => DetailQuestPage(
                            quest: quest,
                            eBinding: eType,
                          ),
                      transition: Transition.rightToLeftWithFade);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getQuestIcon(quest.type.index, size: 21.0),
                                Expanded(
                                  // flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      quest.name,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  // width: 80,
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
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Text(
                                          quest.completeCount > 9999
                                              ? '9999'
                                              : quest.completeCount.toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => InkWell(
                                    onTap: () async {
                                      // await _profileController.acceptOrCancelQuest(attr);
                                    },
                                    child: profileController
                                        .getQuestSimpleIcon(quest.qid),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        // '${getAreaCityText(attr.area, attr.city)}',
                        quest.location,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildLinkIcons(quest),
                  ],
                ),
              ),
            ),
            Container(
              width: 20,
            ),
            Container(
              height: 80,
              width: 70,
              decoration: BoxDecoration(
                  color: can ? Colors.white : Colors.grey,
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(3.0))),
              child: IconButton(
                disabledColor: Colors.black.withOpacity(0.3),
                  onPressed: can ? () async {
                    final result = Get.to(() => CompleteQuestInKakaoMap(
                          quest: quest,
                          type: eInBindType.footPrint,
                        ));
                  } : null,
                  icon: FaIcon(
                    FontAwesomeIcons.motorcycle,
                    color: can ? Colors.green : null,
                    size: 30,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _buildLinkIcons(Quest attr) {
    if (attr.instagram.isNotEmpty && attr.youtubeUrl.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          children: [
            const FaIcon(FontAwesomeIcons.instagram,
                color: Colors.blue, size: 15),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child:
                  FaIcon(FontAwesomeIcons.youtube, color: Colors.red, size: 15),
            ),
            Expanded(
              child: Text(
                attr.youtubeUrl,
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    if (attr.instagram.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: FaIcon(FontAwesomeIcons.instagram,
                  color: Colors.blue, size: 15),
            ),
            Expanded(
              child: Text(
                attr.instagram,
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    if (attr.youtubeUrl.isNotEmpty) {
      return Padding(
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
                attr.youtubeUrl,
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
