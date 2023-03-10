import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/rank_controller.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/side_menu/side_menu_page.dart';
import 'package:bike_adventure/tabs/details/ranker_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankerPage extends StatefulWidget {
  const RankerPage({Key? key}) : super(key: key);

  @override
  _RankerPageState createState() => _RankerPageState();
}

class _RankerPageState extends State<RankerPage> {
  final RankController _rankController = Get.find<RankController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rankController.getData();
    });
  }

  @override
  void dispose() {
    // _questController.searchType = SearchType.NONE;
    // _questController.pageNum = 0;
    // _questController.isFirstLoading.value = true;
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          Obx(() => SliverToBoxAdapter(
                child: Container(
                  height: 265,
                  color: Colors.black.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 0, left: 8.0, right: 8.0),
                    child: Column(
                      // scrollDirection: Axis.vertical,
                      // shrinkWrap: true,
                      children: [
                        Stack(
                          children: [
                            WinnerListSimpleBox(
                                ranker: _rankController.getRankerByRanking(1)),
                            const Icon(
                              Icons.star_rounded,
                              size: 42,
                              color: Colors.orangeAccent,
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
                            const Icon(
                              Icons.star_rounded,
                              size: 41,
                              color: Colors.deepPurpleAccent,
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
                            const Icon(
                              Icons.star_rounded,
                              size: 40,
                              color: Colors.brown,
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
              )),
          Obx(() => SliverToBoxAdapter(
                  child: Container(
                    height: 1500,
                    width: 100,
                    child: ListView.builder(
                      itemCount: _rankController.rankerList.length,
                      itemBuilder: (_, index) {
                        if (index < 4) {
                      return Container();
                        }
                        return RankerListSimpleBox(
                            ranker: _rankController.rankerList[index]);
                        // print('22222: ${index}');
                        // return Container(height:100, width:100, color: Colors.red,);
                      },
                    ),
                  )))
        ],
      ),
    );
  }
}

SliverAppBar _buildAppBar() {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.black.withOpacity(0.7),
    foregroundColor: Colors.white,
    floating: true,
    pinned: false,
    snap: false,
    centerTitle: false,
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.leaderboard_rounded),
            Container(
              width: 10,
            ),
            const Text(
              '랭크',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
          ],
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
  );
}

class WinnerListSimpleBox extends StatelessWidget {
  const WinnerListSimpleBox({Key? key, required this.ranker}) : super(key: key);

  // final int index;
  final User ranker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            // color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0),
            // gradient: const LinearGradient(
            //   colors: [Colors.amber, Colors.amber],
            //   [Colors.grey, Colors.grey.shade700],
            //   : [Colors.grey, Colors.grey.shade700]
            // ),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 18),
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
                              Text(
                                '@' +
                                    getBikeText(
                                        ranker.bikeBrand, ranker.bikeModel),
                                style: const TextStyle(color: Colors.black54),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () async {
          final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
              transition: Transition.rightToLeftWithFade);
        },
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0),
            // gradient: const LinearGradient(
            //   colors: [Colors.white, Colors.white10],
            // [Colors.grey, Colors.grey.shade700],
            // : [Colors.grey, Colors.grey.shade700]
            // ),
            color: Colors.white.withOpacity(0.9),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          ranker.avatar,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      Flexible(
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
                            Text(
                              '@' +
                                  getBikeText(
                                      ranker.bikeBrand, ranker.bikeModel),
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
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

class RankerList extends StatelessWidget {
  const RankerList({Key? key, required this.ranker}) : super(key: key);
  final User ranker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () async {
          final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
              transition: Transition.rightToLeftWithFade);
        },
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white10],
              // [Colors.grey, Colors.grey.shade700],
              // : [Colors.grey, Colors.grey.shade700]
            ),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            // boxShadow: const [
            //   BoxShadow(
            //     color: Colors.black,
            //     offset: Offset(1.0, 1.0), //(x,y)
            //     blurRadius: 6.0,
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      ranker.avatar,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                    // child: Image.asset(
                    //   'assets/banner/sample_avatar.jpg',
                    //   height: 50,
                    //   width: 50,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ranker.nick,
                          style: TextStyle(color: Colors.black),
                        ),
                        const Text(
                          '@name',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.sports_score_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
