import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/rank_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/foot_print_log.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/side_menu/widgets/foot_log_card.dart';
import 'package:bike_adventure/tabs/my_quest_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RankerDetailPage extends StatefulWidget {
  const RankerDetailPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<RankerDetailPage> createState() => _RankerDetailPageState();
}

class _RankerDetailPageState extends State<RankerDetailPage> {
  final RankController _rankController = Get.find<RankController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final ScrollController _sliverScrollController = ScrollController();
  var isPinned = false;
  bool isLoading = true;
  bool isFavorite = false;
  List<FootPrintLog> footPrintLogs = [];

  @override
  void initState() {
    // _rankController.getData();
    _rankController.getRankerDetail(widget.uid);
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
      footPrintLogs = await _profileController.getFootPrintLog(widget.uid);
      setState(() {
        footPrintLogs;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final style = TextStyle(
    //   color: Colors.red,
    //   fontSize: 16,
    //   fontWeight: FontWeight.w500,
    //   height: 1.375,
    // );
    // Map<String, PreviewData> datas = {};

    return Obx(() {
      if (_rankController.isRankerLoading.value) {
        return const CustomIndicatorBike(size: 200);
      }
      isFavorite = isFavoriteTarget(_rankController.ranker!.uid);

      return Scaffold(
        body: CustomScrollView(
          controller: _sliverScrollController,
          slivers: [
            _buildSliverAppBar(),
            _rankController.ranker!.youtubeUrl.isNotEmpty ? SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120,
                    child: buildAnyLinkPreviewHorizontal(
                        _rankController.ranker!.youtubeUrl),
                  ),
                ),
              ),
            ) : SliverToBoxAdapter(
              child: Container(),
            ),
            _rankController.ranker!.instagram.isNotEmpty ? SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120,
                    child: buildAnyLinkPreviewHorizontal(
                        _rankController.ranker!.instagram),
                  ),
                ),
              ),
            ) : SliverToBoxAdapter(
              child: Container(),
            ),
            SliverList(
                delegate: SliverChildListDelegate(const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('발자취 목록'),
              )
            ])),
            SliverList(
                delegate: SliverChildBuilderDelegate((_, index) {
              // Quest quest = footPrintLogs[index];
              // eQuestBinding eType =
              //     _profileController.getQuestBindingType(quest.qid);

              // return QuestListStick(quest: quest, eType: eType);
              // return QuestUnitInList(index: index, quest: quest);
                  return FootLogCard(footLog: footPrintLogs[index],);
            }, childCount: (footPrintLogs.length))),
            buildEmptySpace(),
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
          // InkWell(
          //     onTap: () async {
          //       final result = await _profileController
          //           .setFavorite(_rankController.ranker!.uid);
          //
          //       if (result > 0) {
          //         pushSnackbar(
          //             '즐겨찾기', '정상적으로 ${result == 1 ? '추가' : '삭제'} 됐습니다.');
          //
          //         setState(() {
          //           isFavorite = isFavoriteTarget(_rankController.ranker!.uid);
          //         });
          //       }
          //     },
          //     child: isFavorite
          //         ? const Center(
          //             child: Padding(
          //             padding: EdgeInsets.only(right: 8.0),
          //             child: FaIcon(FontAwesomeIcons.solidHeart,
          //                 color: Colors.red, size: 18),
          //           ))
          //         : const Center(
          //             child: Padding(
          //             padding: EdgeInsets.only(right: 8.0),
          //             child: FaIcon(FontAwesomeIcons.heart, size: 18),
          //           ))),
          !isItMine() ? btnBlock(context) : Container(),
          !isItMine()
              ? const SizedBox(
            width: 7,
          )
              : Container(),
          // !isItMine() ? btnReport(context, quest) : Container(),
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


  isItMine() {
    return _rankController.ranker!.uid == _profileController.profile!.uid;
  }

  btnBlock(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          showBlockAlertDialog(context);
        },
        child: Row(
          children: const [
            Icon(Icons.remove_circle, size: 13),
            Text('차단', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  showBlockAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 180,
        child: alertDialogWidgetYesOrNo(
            '정말 이 사용자를 차단하시겠습니까?\n이제부터 이 사용자의 리플을 볼 수 없습니다.'),
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        showDeleteAlertDialog4(context, _rankController.ranker);
      }
    });
  }


  showDeleteAlertDialog4(BuildContext context, User? user) async {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetCircularProgressIndicator("사용자 차단 중..."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) async {});

    bool result = await _profileController.blockUser(user);
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      pushSnackbar('차단', '${user!.nick}을 차단하였습니다');
      Get.offAll(() => const MainPage());
      // Get.offUntil(MaterialPageRoute(builder: (context) => const MainPage()), (route) => false);
    });
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

  buildEmptySpace() {
    if (footPrintLogs.isEmpty) {
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
      child: Container(),
    );
  }
}
