import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/controllers/my_accept_quest_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/tabs/details/detail_quest_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/quest_unit_in_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAcceptQuest extends StatefulWidget {
  const MyAcceptQuest({Key? key}) : super(key: key);

  @override
  _MyAcceptQuestState createState() => _MyAcceptQuestState();
}

class _MyAcceptQuestState extends State<MyAcceptQuest> {
  final MyAcceptQuestController _questController = Get.find<MyAcceptQuestController>();
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _questController.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // key: PageStorageKey<String>(widget.name),
      // controller: _questController.scrollController.value,
      slivers: [
        Obx(() {
          if (!_questController.isLoading.value) {
            if (_questController.questList.isEmpty) {
              return const SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: Center(
                    child: Text(
                      '수락한 퀘스트가 없습니다.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              );
            }
          }
          return SliverToBoxAdapter(
            child: Container(),
          );
        }),
        Obx(() {
          return SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
                // return _buildList(index, _questController.questList[index]);
                return QuestUnitInList(index: index, quest: _questController.questList[index]);
              }, childCount: (_questController.questList.length)));
        }),
        Obx(() {
          return SliverToBoxAdapter(
            child: _questController.isLoading.value
                ? const Padding(
                  padding: EdgeInsets.only(top: MY_QUEST_PADDING_TOP),
                  child: Center(child: CustomIndicatorBike(size: 120)),
                )
                : Container(height: 70),
          );
        })
      ],
    );
  }

  Widget _buildList(int index, Quest attr) {
    // var isCompletedQuest = Random().nextBool();
    // var isInGuild = Random().nextBool();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: () async {
          final result = await Get.to(() => DetailQuestPage(quest: attr, eBinding: eQuestBinding.accepted,),
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
                    image: getImageUrl(attr.getThumbnail()),
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
                              flex: 6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  getQuestIcon(attr.type.index),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        attr.name,
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
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0),
                                              child: Text(
                                                attr.completeCount > 9999 ? '9999' :
                                                attr.completeCount.toString(),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    overflow:
                                                    TextOverflow.ellipsis),
                                              ),
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
                                    child: _profileController.getQuestSimpleIcon(attr.qid),
                                  ),),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        attr.location,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    attr.youtubeUrl.isNotEmpty
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
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            attr.writer!.nick,
                            style: const TextStyle(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.two_wheeler_rounded, size: 14,),
                          const SizedBox(width: 6,),
                          Text(
                            getBikeText(attr.writer!.bikeBrand, attr.writer!.bikeModel),
                            style: const TextStyle(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                          ,
                        ],
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

  Expanded _widgetSearch() {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 32,
        color: Colors.white,
        // decoration: BoxDecoration(
        //   color: HINT_BOX_DECO_COLOR,
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        // ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
                filled: true,
                fillColor: HINT_BOX_DECO_COLOR,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search for something',
                hintStyle: TextStyle(fontSize: 12),
                // prefixIcon: Icon(Icons.search),
                suffixIcon: const Icon(Icons.search)),
          ),
        ),
      ),
    );
  }
}
