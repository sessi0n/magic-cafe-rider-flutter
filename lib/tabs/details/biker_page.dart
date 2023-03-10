// import 'package:bike_adventure/constants/enums.dart';
// import 'package:bike_adventure/controllers/profile_controller.dart';
// import 'package:bike_adventure/controllers/rank_controller.dart';
// import 'package:bike_adventure/models/quest.dart';
// import 'package:bike_adventure/customs/custom_indicator_bike.dart';
// import 'package:bike_adventure/models/user.dart';
// import 'package:bike_adventure/tabs/details/quest_list_stick.dart';
// import 'package:bike_adventure/tabs/my_quest_page.dart';
// import 'package:bike_adventure/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
//
// class BikerPage extends StatefulWidget {
//   const BikerPage({Key? key, required this.uid}) : super(key: key);
//   final String uid;
//
//   @override
//   State<BikerPage> createState() => _BikerPageState();
// }
//
// class _BikerPageState extends State<BikerPage> {
//   final RankController _rankController = Get.find<RankController>();
//   final ProfileController _profileController = Get.find<ProfileController>();
//   final ScrollController _sliverScrollController = ScrollController();
//   var isPinned = false;
//   bool isLoading = true;
//   bool isFavorite = false;
//
//   @override
//   void initState() {
//     // _rankController.getData();
//     _rankController.getBikerDetail(widget.uid);
//     _sliverScrollController.addListener(() {
//       if (!isPinned &&
//           _sliverScrollController.hasClients &&
//           _sliverScrollController.offset > kToolbarHeight) {
//         setState(() {
//           isPinned = true;
//         });
//       } else if (isPinned &&
//           _sliverScrollController.hasClients &&
//           _sliverScrollController.offset < kToolbarHeight) {
//         setState(() {
//           isPinned = false;
//         });
//       }
//     });
//
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (_rankController.isRankerLoading.value) {
//         return const CustomIndicatorBike(size: 200);
//       }
//       isFavorite = isFavoriteTarget(_rankController.ranker!.uid);
//
//       return Scaffold(
//         body: CustomScrollView(
//           controller: _sliverScrollController,
//           slivers: [
//             _buildSliverAppBar(),
//             _rankController.ranker!.youtubeUrl.isNotEmpty ? SliverAppBar(
//               backgroundColor: Colors.white,
//               pinned: true,
//               automaticallyImplyLeading: false,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 120,
//                     child: buildAnyLinkPreviewHorizontal(
//                         _rankController.ranker!.youtubeUrl),
//                   ),
//                 ),
//               ),
//             ) : SliverToBoxAdapter(
//               child: Container(),
//             ),
//             _rankController.ranker!.instagram.isNotEmpty ? SliverAppBar(
//               backgroundColor: Colors.white,
//               pinned: true,
//               automaticallyImplyLeading: false,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 120,
//                     child: buildAnyLinkPreviewHorizontal(
//                         _rankController.ranker!.instagram),
//                   ),
//                 ),
//               ),
//             ) : SliverToBoxAdapter(
//               child: Container(),
//             ),
//             SliverList(
//                 delegate: SliverChildListDelegate(const [
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text('등록 퀘스트'),
//                   )
//                 ])),
//             SliverList(delegate: SliverChildBuilderDelegate((_, index) {
//               Quest quest = _rankController.questList[index];
//               eQuestBinding eType = _profileController.getQuestBindingType(quest.qid);
//
//               return QuestListStick(quest: quest, eType: eType);
//             }, childCount: (_rankController.questList.length))),
//             Obx(() {
//               if (_rankController.questList.isEmpty) {
//                 return const SliverToBoxAdapter(
//                   child: SizedBox(
//                     height: 300,
//                     child: Center(
//                       child: Text(
//                         '바이커가 등록한 퀘스트가 없습니다.',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 );
//               }
//
//               return SliverToBoxAdapter(
//                 child: Container(),
//               );
//             }),
//           ],
//         ),
//       );
//     });
//   }
//
//   SliverAppBar _buildSliverAppBar() {
//     return SliverAppBar(
//       backgroundColor: Colors.black,
//       foregroundColor: Colors.white,
//       expandedHeight: 220.0,
//       floating: false,
//       pinned: true,
//       actions: [
//         InkWell(
//             onTap: () async {
//               final result = await _profileController
//                   .setFavorite(_rankController.ranker!.uid);
//
//               if (result > 0) {
//                 pushSnackbar(
//                     '즐겨찾기', '정상적으로 ${result == 1 ? '추가' : '삭제'} 됐습니다.');
//
//                 setState(() {
//                   isFavorite =
//                       isFavoriteTarget(_rankController.ranker!.uid);
//                 });
//               }
//             },
//             child: isFavorite
//                 ? const Center(child: Padding(
//                   padding: EdgeInsets.only(right: 8.0),
//                   child: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 18),
//                 ))
//                 : const Center(child: Padding(
//                   padding: EdgeInsets.only(right: 8.0),
//                   child: FaIcon(FontAwesomeIcons.heart, size: 18),
//                 ))),
//         const SizedBox(width: 10,),
//       ],
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(0),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Flexible(
//                     child: Text(_rankController.ranker!.nick,
//                         maxLines: 1,
//                         style: const TextStyle(
//                             fontSize: 20,
//                             overflow: TextOverflow.ellipsis,
//                             color: Colors.white)),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   _rankController.ranker!.instagram.isNotEmpty
//                       ? InkWell(
//                       onTap: () async {
//                         launchURL(_rankController.ranker!.instagram);
//                       },
//                       child: const FaIcon(FontAwesomeIcons.instagram,
//                           color: Colors.white, size: 20))
//                       : Container(),
//                   _rankController.ranker!.instagram.isNotEmpty &&
//                       _rankController.ranker!.youtubeUrl.isNotEmpty
//                       ? const SizedBox(
//                     width: 10,
//                   )
//                       : Container(),
//                   _rankController.ranker!.youtubeUrl.isNotEmpty
//                       ? InkWell(
//                       onTap: () async {
//                         launchURL(_rankController.ranker!.youtubeUrl);
//                       },
//                       child: const FaIcon(FontAwesomeIcons.youtube,
//                           color: Colors.white, size: 20))
//                       : Container(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//           background: Image.network(
//             getProfileImageUrl(_rankController.ranker!),
//             fit: BoxFit.cover,
//           )),
//     );
//   }
//
//   isFavoriteTarget(targetUid) {
//     if (targetUid == _profileController.profile!.uid) {
//       return true;
//     }
//
//     User? biker = _profileController.favoriteBikers
//         .firstWhereOrNull((element) => element.uid == targetUid);
//
//     return biker != null;
//   }
// }
