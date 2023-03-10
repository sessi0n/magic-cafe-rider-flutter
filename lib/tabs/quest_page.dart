import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/side_menu/side_menu_page.dart';
import 'package:bike_adventure/tabs/details/search_page.dart';
import 'package:bike_adventure/widget/quest_unit_in_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  final QuestController _questController = Get.find<QuestController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  bool pageLoading = true;
  eSortType sort = eSortType.COMPLETE_COUNT;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _questController.getSearchQuestData();
      setState(() {
        pageLoading = false;
      });
      setState(() {
        sort = _questController.sortType;
      });
    });
  }

  @override
  void dispose() {
    _questController.searchType = SearchType.NONE;
    _questController.pageNum = 0;
    _questController.sortType = eSortType.COMPLETE_COUNT;
    // _questController.isFirstLoading.value = true;
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
          controller: _questController.scrollController.value,
          slivers: [
            _buildAppBar(scaffoldKey),
            Obx(() {
              if (!_questController.isLoading.value) {
                if (_questController.questList.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          '퀘스트가 없습니다.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                }
              }
              return SliverToBoxAdapter(
                child:                   Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.bullhorn,
                          color: Colors.teal, size: 20),
                      title: Text(
                        '카페 등록은 무료입니다. 리스트에 없다면 문의 주세요.',
                        style: TextStyle(fontSize: 12),
                      ),
                    )),
              );
            }),
            Obx(() {
              return SliverList(
                  delegate: SliverChildBuilderDelegate((_, index) {
                    return QuestUnitInList(index: index, quest: _questController.questList[index]);
              }, childCount: (_questController.questList.length)));
            }),
            Obx(() {
              return SliverToBoxAdapter(
                child:
                Column(
                  children: [
                    _questController.hasMore.value ? const LinearProgressIndicator() : const SizedBox(height: 20),
                    _questController.hasMore.value ? const SizedBox(height: 90) : const SizedBox(height: 50)
                  ],
                )
              );
            })
          ],
        ));
  }

  SliverAppBar _buildAppBar(scaffoldKey) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      floating: true,
      pinned: false,
      snap: false,
      centerTitle: false,
      title: Row(
        children: [
          const FaIcon(FontAwesomeIcons.mugSaucer, size: 25),
          Container(
            width: 10,
          ),
          const Text(
            'Cafe & Quest',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () async {
            await Get.to(() => SearchPage(
                  pageType: SearchPageType.quest,
                ));
          },
        ),
        IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => scaffoldKey.currentState.openEndDrawer(),
        ),
      ],
      bottom: buildSort(),
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
                    if (_questController.sortType == eSortType.COMPLETE_COUNT) {
                      return;
                    }

                    await _questController.getSearchQuestData(
                        isInit: true, eSort: eSortType.COMPLETE_COUNT);

                    setState(() {
                      sort = eSortType.COMPLETE_COUNT;
                    });
                  },
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                      color: sort == eSortType.COMPLETE_COUNT ? Colors.green : Colors.grey,
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
                        '인기 정렬',
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
                    if (_questController.sortType == eSortType.NEW) {
                      return;
                    }

                    await _questController.getSearchQuestData(
                        isInit: true, eSort: eSortType.NEW);

                    setState(() {
                      sort = eSortType.NEW;
                    });
                  },
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                      color: sort == eSortType.NEW ? Colors.green : Colors.grey,
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
                        '최신 정렬',
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

  Widget favoriteCard(User? biker, onTab) {
    if (biker == null) {
      return InkWell(
        onTap: onTab,
        child: SizedBox(
          width: 100.0,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: _profileController.getMyAvatarImg(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _profileController.profile!.nick,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTab,
      child: SizedBox(
        width: 100.0,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: biker.avatar.isNotEmpty
                      ? Image.network(
                          biker.avatar,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        )
                      : Image.asset(
                          'assets/icons/nobody_avatar3.png',
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                biker.nick,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

}
