
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/npc_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/side_menu/side_menu_page.dart';
import 'package:bike_adventure/tabs/details/detail_npc_page.dart';
import 'package:bike_adventure/tabs/details/search_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class NpcPage extends StatefulWidget {
  const NpcPage({Key? key}) : super(key: key);

  @override
  _NpcPageState createState() => _NpcPageState();
}

class _NpcPageState extends State<NpcPage> {
  final NpcController npcController = Get.find<NpcController>();
  final ProfileController profileController = Get.find<ProfileController>();
  bool pageLoading = true;
  eTabType tabType = eTabType.WITH_BIKE;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await npcController.getNpcList(
          isInit: true, eType: eTabType.WITH_BIKE);

      setState(() {
        pageLoading = false;
      });
      setState(() {
        tabType = npcController.tabType;
      });
    });


  }

  @override
  void dispose() {
    npcController.searchType = NpcSearchType.NONE;
    npcController.pageNum = 0;
    tabType = eTabType.WITH_BIKE;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const SideMenuPage(),
      drawerEnableOpenDragGesture: false,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: npcController.scrollController.value,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            floating: true,
            pinned: false,
            snap: false,
            centerTitle: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.truckFast, size: 25),
                Container(
                  width: 10,
                ),
                const Text(
                  'Shop & NPC',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () async {
                  await Get.to(() => SearchPage(
                        pageType: SearchPageType.npc,
                      ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
            bottom: buildSort(),
          ),
          Obx(() {
            return SliverToBoxAdapter(
              child: npcController.npcList.isEmpty
                  ? const SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'NPC가 없습니다.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  : Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: ListTile(
                    leading: FaIcon(FontAwesomeIcons.bullhorn,
                        color: Colors.teal, size: 20),
                    title: Text(
                      '상점 등록은 무료입니다. 리스트에 없다면 문의 주세요.',
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
            );
          }),
          Obx(() {
            return SliverList(
                delegate: SliverChildBuilderDelegate((_, index) {
              return _buildList(index, npcController.npcList[index]);
            }, childCount: (npcController.npcList.length)));
          }),
          Obx(() {
            return SliverToBoxAdapter(
              child:
              Column(
                children: [
                  npcController.hasMore.value ? const LinearProgressIndicator() : const SizedBox(height: 20),
                  npcController.hasMore.value ? const SizedBox(height: 90) : const SizedBox(height: 50)
                ],
              )
            );
          }),
        ],
      ),
    );
  }

  PreferredSize buildSort() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    if (npcController.tabType == eTabType.WITH_BIKE) {
                      return;
                    }
                    await npcController.getNpcList(
                        isInit: true, eType: eTabType.WITH_BIKE);

                    setState(() {
                      tabType = eTabType.WITH_BIKE;
                    });
                  },
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                      color: tabType == eTabType.WITH_BIKE ? Colors.green : Colors.grey,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(3.0)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '바이크 관련',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async {
                    if (npcController.tabType == eTabType.NON_BIKE) {
                      return;
                    }

                    await npcController.getNpcList(
                        isInit: true, eType: eTabType.NON_BIKE);

                    setState(() {
                      tabType = eTabType.NON_BIKE;
                    });
                  },
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                      color: tabType == eTabType.NON_BIKE ? Colors.green : Colors.grey,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(3.0)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'ETC',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 5,
            )
          ],
        ));
  }

  Widget _buildList(int index, Npc npc) {
    // var isFavorite = Random().nextBool();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: () async {
          // eQuestBinding eType = _profileController.getQuestBindingType(attr.qid);
          final result = await Get.to(() => DetailNpcPage(npc: npc),
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
                    image: getImageUrl(npc.thumbnail),
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
                                  getNpcIcon(npc.type.index),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        npc.name,
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
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        getLocation(npc),
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    buildUrlLine(npc),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLocation(Npc npc) {
    if (npc.type == eNpcType.WEBSTORE && npc.location.isEmpty) {
      return npc.webUrl;
    }
    return npc.location;
  }

  Widget buildUrlLine(Npc npc) {
    return Column(
      children: [
        npc.webUrl.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: FaIcon(FontAwesomeIcons.internetExplorer,
                    color: Colors.blue, size: 12,)
              ),
              Expanded(
                child: Text(
                  npc.webUrl,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ) : Container(),
        npc.instagram.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.green, size: 12,)
              ),
              Expanded(
                child: Text(
                  npc.instagram,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ) : Container(),
        npc.youtubeUrl.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(FontAwesomeIcons.youtube,
                  color: Colors.red, size: 12,)
              ),
              Expanded(
                child: Text(
                  npc.youtubeUrl,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ) : Container(),
      ],
    );

  }

}
