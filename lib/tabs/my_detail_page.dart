import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/rank_controller.dart';
import 'package:bike_adventure/models/foot_print_log.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/tabs/my_quest_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/my_unit_in_list.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MyDetailPage extends StatefulWidget {
  const MyDetailPage({Key? key}) : super(key: key);

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  final RankController _rankController = Get.find<RankController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final ScrollController _sliverScrollController = ScrollController();
  var isPinned = false;
  bool isLoading = true;
  bool isFavorite = false;
  List<FootPrintLog> footPrintLogs = [];

  @override
  void initState() {
    _sliverScrollController.addListener(() {
      if (!isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset > kToolbarHeight) {
        setState(() {
          isPinned = true;
        });
      } else if (isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset < kToolbarHeight) {
        setState(() {
          isPinned = false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _rankController.getRankerDetail(_profileController.profile!.uid);
      footPrintLogs = await _profileController.getLastFootLog();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_rankController.isRankerLoading.value) {
        return const CustomIndicatorBike(size: 200);
      }
      isFavorite = isFavoriteTarget(_rankController.ranker!.uid);

      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          controller: _sliverScrollController,
          slivers: [
            _buildSliverAppBar(),
            SliverList(
                delegate: SliverChildListDelegate(const [
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.motorcycle,
                            color: Colors.teal, size: 20),
                        title: Text(
                          '매일 아침 10시. 발자취 시간이 리셋 되어 새로운 이벤트 로그를 남길 수 있습니다',
                          style: TextStyle(fontSize: 14),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('완료 퀘스트 목록'),
                  ),

                ])),
            SliverList(
                delegate: SliverChildBuilderDelegate((_, index) {
                  Quest quest = _rankController.questList[index];
                  eQuestBinding eType =
                  _profileController.getQuestBindingType(quest.qid);

                  FootPrintLog? f = footPrintLogs.firstWhereOrNull((element) => element.qid == quest.qid);
                  return MyUnitInList(index: index, quest: quest, can: f?.can ?? false);
                }, childCount: (_rankController.questList.length))),
            Obx(() {
              if (_rankController.questList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        '바이커가 완료한 퀘스트가 없습니다.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Container(height: 5),
                    const Divider(),
                    Container(height: 60),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        expandedHeight: 220.0,
        floating: false,
        pinned: false,
        actions: [
          InkWell(
              onTap: () async {
                final result = await _profileController
                    .setFavorite(_rankController.ranker!.uid);

                if (result > 0) {
                  pushSnackbar(
                      '즐겨찾기', '정상적으로 ${result == 1 ? '추가' : '삭제'} 됐습니다.');

                  setState(() {
                    isFavorite = isFavoriteTarget(_rankController.ranker!.uid);
                  });
                }
              },
              child: isFavorite
                  ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: FaIcon(FontAwesomeIcons.solidHeart,
                        color: Colors.red, size: 18),
                  ))
                  : const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: FaIcon(FontAwesomeIcons.heart, size: 18),
                  ))),
          const SizedBox(
            width: 10,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(_rankController.ranker!.nick,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    _rankController.ranker!.instagram.isNotEmpty
                        ? InkWell(
                        onTap: () async {
                          launchURL(_rankController.ranker!.instagram);
                        },
                        child: const FaIcon(FontAwesomeIcons.instagram,
                            color: Colors.white, size: 20))
                        : Container(),
                    _rankController.ranker!.instagram.isNotEmpty &&
                        _rankController.ranker!.youtubeUrl.isNotEmpty
                        ? const SizedBox(
                      width: 10,
                    )
                        : Container(),
                    _rankController.ranker!.youtubeUrl.isNotEmpty
                        ? InkWell(
                        onTap: () async {
                          launchURL(_rankController.ranker!.youtubeUrl);
                        },
                        child: const FaIcon(FontAwesomeIcons.youtube,
                            color: Colors.white, size: 20))
                        : Container(),
                  ],
                ),
                const SizedBox(height: 5,),
                Text(getBikeText(_rankController.ranker!.bikeBrand, _rankController.ranker!.bikeModel),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              getProfileImageUrl(_rankController.ranker!),
              fit: BoxFit.cover,
            )));
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _rankController.ranker!.nick,
            style: const TextStyle(
                fontSize: TITLE_COUNT_SIZE + 8,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildYoutubeURL() {
    return _rankController.ranker!.youtubeUrl.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(
          right: 12.0, left: 12.0, bottom: 20.0, top: 14),
      child: InkWell(
        onTap: () {
          launchURL(_rankController.ranker!.youtubeUrl);
        },
        child: Card(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/youtube.png',
                  width: 17,
                  height: 17,
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _rankController.ranker!.youtubeUrl,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        : Container();
  }

  Widget _buildInstagram() {
    return _rankController.ranker!.instagram.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(
          right: 12.0, left: 12.0, bottom: 20.0, top: 20),
      child: InkWell(
        onTap: () {
          launchURL(_rankController.ranker!.instagram);
        },
        child: Card(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/youtube.png',
                  width: 1,
                  height: 17,
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _rankController.ranker!.instagram,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        : Container();
  }

  isFavoriteTarget(targetUid) {
    if (targetUid == _profileController.profile!.uid) {
      return true;
    }

    User? biker = _profileController.favoriteBikers
        .firstWhereOrNull((element) => element.uid == targetUid);

    return biker != null;
  }
}
