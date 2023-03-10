import 'package:bike_adventure/controllers/my_accept_quest_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/tabs/my_quest/my_accept_quest.dart';
import 'package:bike_adventure/tabs/my_quest/my_complete_quest.dart';
import 'package:bike_adventure/tabs/my_quest/my_register_quest.dart';
import 'package:bike_adventure/side_menu/side_menu_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyQuestPage extends StatefulWidget {
  const MyQuestPage({Key? key, this.initTabPage = 1}) : super(key: key);
  final int initTabPage;

  @override
  _MyQuestPageState createState() => _MyQuestPageState();
}

const MAX_MY_QUEST_TAB_COUNT = 2;
const TITLE_ICON_SIZE = 12.0;
const TITLE_ICONS_RIGHT_PADDING_SIZE = 5.0;
const TITLE_COUNT_SIZE = 10.0;
const TITLE_EACH_SIDE_PADDING_SIZE = 8.0;

class _MyQuestPageState extends State<MyQuestPage>
    with SingleTickerProviderStateMixin {

  final ProfileController _profileController = Get.find<ProfileController>();
  final MyAcceptQuestController _myAcceptQuestController =
  Get.find<MyAcceptQuestController>();

  TabController? _tabController;
  var scrollController = ScrollController();

  /*
  탭마다 스크롤 구분하기 어려워 각 탭 내용은 전부 보여준다.
   */

  @override
  void initState() {
    _tabController = TabController(
        length: MAX_MY_QUEST_TAB_COUNT,
        vsync: this,
        initialIndex: widget.initTabPage);
    super.initState();

  }

  @override
  void dispose() {
    scrollController.dispose();
    _tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideMenuPage(),
      drawerEnableOpenDragGesture: false,
      body: _buildPage(),
    );
  }

  DefaultTabController _buildPage() {
    return DefaultTabController(
        length: MAX_MY_QUEST_TAB_COUNT,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                title: Row(
                  children: const [
                    ImageIcon(
                      AssetImage('assets/icons/map.png'),
                      size: 17,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'My Quests',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
                expandedHeight: 220.0,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    title: _buildTitle(),
                    centerTitle: true,
                    background: Image.network(
                      getProfileImageUrl(_profileController.profile!),
                      // _profileController.getMyProfileImg(),
                      fit: BoxFit.cover,
                    )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(icon: Icon(Icons.beenhere_rounded, color: Colors.deepPurpleAccent), text: "등록 퀘스트"),
                      // Tab(icon: Icon(Icons.play_circle_rounded, color: Colors.green), text: "수락 퀘스트"),
                      Tab(
                          icon: Icon(Icons.check_circle_outline_rounded, color: Colors.amber),
                          text: "완료 퀘스트")
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              MyRegisterQuest(),
              // MyAcceptQuest(),
              MyCompleteQuest(),
            ],
          ),
        ));
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    right: TITLE_ICONS_RIGHT_PADDING_SIZE),
                child: Icon(
                  Icons.beenhere_rounded,
                  size: TITLE_ICON_SIZE,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Text(
                _profileController.regQuestList.length.toString(),
                style: const TextStyle(
                    fontSize: TITLE_COUNT_SIZE,color: Colors.white,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: TITLE_EACH_SIDE_PADDING_SIZE),
          //   child: Row(
          //     children: [
          //       const Padding(
          //         padding: EdgeInsets.only(
          //             right: TITLE_ICONS_RIGHT_PADDING_SIZE),
          //         child: Icon(
          //           Icons.play_circle_rounded,
          //           size: TITLE_ICON_SIZE,
          //           color: Colors.green,
          //         ),
          //       ),
          //       Text(
          //         _profileController.acceptQuestList.length.toString(),
          //         style: const TextStyle(
          //             fontSize: TITLE_COUNT_SIZE,color: Colors.white,
          //             overflow: TextOverflow.ellipsis),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(width: 10,),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    right: TITLE_ICONS_RIGHT_PADDING_SIZE),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: TITLE_ICON_SIZE,
                  color: Colors.amber,
                ),
              ),
              Text(
                _profileController.completedQuestList.length
                    .toString(),
                style: const TextStyle(
                    fontSize: TITLE_COUNT_SIZE, color: Colors.white,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
