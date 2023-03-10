import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/controllers/rank_controller.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/tabs/details/ranker_detail_page.dart';
import 'package:bike_adventure/widget/gradient_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RankerPage2 extends StatefulWidget {
  const RankerPage2({Key? key}) : super(key: key);

  @override
  _RankerPage2State createState() => _RankerPage2State();
}

class _RankerPage2State extends State<RankerPage2> {
  final RankController _rankController = Get.find<RankController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rankController.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Icon(Icons.leaderboard_rounded),
            const FaIcon(FontAwesomeIcons.rankingStar, size: 25),
            Container(
              width: 20,
            ),
            const Text(
              'RANK',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              width: 50,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.cancel_rounded)),
        ],
      ),
      body: Obx(() => Column(
        children: [
          Container(
            // height: 275,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom:15, left: 8.0, right: 8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      WinnerListSimpleBox(
                          ranker: _rankController.getRankerByRanking(1)),
                      Positioned(
                        top: -10,
                        left: -9,
                        child: GradientIcon(
                          Icons.star_rounded,
                          50.0,
                          const LinearGradient(
                            colors: <Color>[
                              Colors.amber,
                              Colors.amber,
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      const Positioned(
                          top: 14,
                          left: 17,
                          child: Text('1',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                    ],
                  ),
                  Stack(
                    children: [
                      WinnerListSimpleBox(
                          ranker: _rankController.getRankerByRanking(2)),
                      Positioned(
                        top: -10,
                        left: -9,
                        child: GradientIcon(
                          Icons.star_rounded,
                          50.0,
                          const LinearGradient(
                            colors: <Color>[
                              Colors.grey,
                              Colors.grey,
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      const Positioned(
                          top: 13,
                          left: 16.8,
                          child: Text('2',
                              style: TextStyle(
                                  fontSize: 13.8,
                                  fontWeight: FontWeight.w700))),
                    ],
                  ),
                  Stack(
                    children: [
                      WinnerListSimpleBox(
                          ranker: _rankController.getRankerByRanking(3)),
                      Positioned(
                        top: -10,
                        left: -9,
                        child: GradientIcon(
                          Icons.star_rounded,
                          50.0,
                          const LinearGradient(
                            colors: <Color>[
                              Colors.orangeAccent,
                              Colors.orangeAccent,
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      const Positioned(
                          top: 13,
                          left: 16.5,
                          child: Text('3',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _rankController.rankerList.length,
              itemBuilder: (_, index) {
                if (index < 4) {
                  return Container();
                }
                return RankerListSimpleBox(
                    ranker: _rankController.rankerList[index]);
              },
            )
          )
        ],
      ),
    ));
  }
}

class WinnerListSimpleBox extends StatelessWidget {
  const WinnerListSimpleBox({Key? key, required this.ranker}) : super(key: key);

  // final int index;
  final User ranker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: InkWell(
        onTap: () async {
          if (ranker.uid == '0') {
            return;
          }
          final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
              transition: Transition.rightToLeftWithFade);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: ranker.uid == '0'
                            ? Image.asset(
                                ranker.avatar,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              )
                            : Image.network(
                                ranker.avatar,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                      ),
                      ranker.youtubeUrl.isNotEmpty || ranker.instagram.isNotEmpty ? SizedBox(
                        width: 40,
                        child: Column(
                          children: [
                            ranker.youtubeUrl.isNotEmpty ? const FaIcon(FontAwesomeIcons.youtube,
                                color: Colors.red) : Container(),
                            ranker.instagram.isNotEmpty ? const FaIcon(FontAwesomeIcons.instagram,
                                color: Colors.green) : Container(),
                          ],
                        ),
                      ) : Container(),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ranker.nick,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '@' +
                                      getBikeText(
                                          ranker.bikeBrand, ranker.bikeModel),
                                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_score_rounded,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${ranker.score}',
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RankerListSimpleBox extends StatelessWidget {
  const RankerListSimpleBox({Key? key, required this.ranker}) : super(key: key);
  final User ranker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: InkWell(
        onTap: () async {
          final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
              transition: Transition.rightToLeftWithFade);
        },
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
            padding: const EdgeInsets.only(left: 10,top: 6.0, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: ranker.avatar.isNotEmpty ? Image.network(
                          ranker.avatar,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ) : Image.asset(
                          'assets/icons/nobody_avatar3.png', scale: 3,
                        ),
                      ),
                      ranker.youtubeUrl.isNotEmpty || ranker.instagram.isNotEmpty ? SizedBox(
                        width: 40,
                        child: Column(
                          children: [
                            ranker.youtubeUrl.isNotEmpty ? const FaIcon(FontAwesomeIcons.youtube,
                                color: Colors.red) : Container(),
                            ranker.instagram.isNotEmpty ? const FaIcon(FontAwesomeIcons.instagram,
                                color: Colors.green) : Container(),
                          ],
                        ),
                      ) : Container(),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ranker.nick,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '@' +
                                      getBikeText(
                                          ranker.bikeBrand, ranker.bikeModel),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 11,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_score_rounded,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${ranker.score}',
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
