// import 'package:bike_adventure/constants/motorcycles.dart';
// import 'package:bike_adventure/controllers/rank_controller.dart';
// import 'package:bike_adventure/customs/custom_indicator_bike.dart';
// import 'package:bike_adventure/models/user.dart';
// import 'package:bike_adventure/side_menu/side_menu_page.dart';
// import 'package:bike_adventure/tabs/details/ranker_detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class RankPage extends StatefulWidget {
//   const RankPage({Key? key}) : super(key: key);
//
//   @override
//   _RankPageState createState() => _RankPageState();
// }
//
// class _RankPageState extends State<RankPage> {
//   final RankController _rankController = Get.find<RankController>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _rankController.getData();
//     });
//   }
//
//   @override
//   void dispose() {
//     // _questController.searchType = SearchType.NONE;
//     // _questController.pageNum = 0;
//     // _questController.isFirstLoading.value = true;
//     super.dispose();
//   }
//
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       endDrawer: const SideMenuPage(),
//       drawerEnableOpenDragGesture: false,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         centerTitle: false,
//         elevation: 0,
//         title: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Icon(Icons.leaderboard_rounded),
//             Container(
//               width: 10,
//             ),
//             const Text(
//               'RANK',
//               style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700),
//             ),
//             Container(
//               width: 50,
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         if (_rankController.isLoading.value) {
//           return const CustomIndicatorBike(size: 120);
//         }
//         return Column(
//           children: [
//             Container(
//               height: 265,
//               color: Colors.black.withOpacity(0.7),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 0, bottom: 0, left: 8.0, right: 8.0),
//                 child: Column(
//                   // scrollDirection: Axis.vertical,
//                   // shrinkWrap: false,
//                   children: [
//                     Stack(
//                       children: [
//                         WinnerListSimpleBox(
//                             ranker: _rankController.getRankerByRanking(1)),
//                         const Icon(
//                           Icons.star_rounded,
//                           size: 42,
//                           color: Colors.orangeAccent,
//                         ),
//                         const Positioned(
//                             top: 14,
//                             left: 17,
//                             child: Text('1',
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white))),
//                       ],
//                     ),
//                     Stack(
//                       children: [
//                         WinnerListSimpleBox(
//                             ranker: _rankController.getRankerByRanking(2)),
//                         const Icon(
//                           Icons.star_rounded,
//                           size: 41,
//                           color: Colors.deepPurpleAccent,
//                         ),
//                         const Positioned(
//                             top: 13,
//                             left: 16.8,
//                             child: Text('2',
//                                 style: TextStyle(
//                                     fontSize: 13.8,
//                                     fontWeight: FontWeight.w700))),
//                       ],
//                     ),
//                     Stack(
//                       children: [
//                         WinnerListSimpleBox(
//                             ranker: _rankController.getRankerByRanking(3)),
//                         const Icon(
//                           Icons.star_rounded,
//                           size: 40,
//                           color: Colors.brown,
//                         ),
//                         const Positioned(
//                             top: 13,
//                             left: 16.5,
//                             child: Text('3',
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white))),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _rankController.rankerList.length < 4
//                 ? const SizedBox(
//                     height: 300,
//                     child: Center(
//                       child: Text(
//                         '랭커가 없습니다.',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   )
//                 :
//             Expanded(
//                 child: Padding(
//               padding:
//                   const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
//               child: Container(
//                 // height: 300,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       topRight: Radius.circular(20.0)),
//                 ),
//                 child: ListView.builder(
//                   itemCount: _rankController.rankerList.length,
//                   itemBuilder: (_, index) {
//                     if (index < 4) {
//                       return Container();
//                     }
//                     return RankerListSimpleBox(
//                         ranker: _rankController.rankerList[index]);
//                   },
//                 ),
//               ),
//             )),
//           ],
//         );
//       }),
//     );
//   }
// }
//
// class WinnerListSimpleBox extends StatelessWidget {
//   const WinnerListSimpleBox({Key? key, required this.ranker}) : super(key: key);
//
//   // final int index;
//   final User ranker;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: InkWell(
//         onTap: () async {
//           if (ranker.uid == '0') {
//             return;
//           }
//           final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
//               transition: Transition.rightToLeftWithFade);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             // color: Colors.grey.shade600,
//             borderRadius: BorderRadius.circular(15.0),
//             // gradient: const LinearGradient(
//             //   colors: [Colors.amber, Colors.amber],
//             //   [Colors.grey, Colors.grey.shade700],
//             //   : [Colors.grey, Colors.grey.shade700]
//             // ),
//             color: Colors.white,
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     ClipOval(
//                       clipBehavior: Clip.antiAlias,
//                       child: ranker.uid == '0'
//                           ? Image.asset(
//                               ranker.avatar,
//                               fit: BoxFit.cover,
//                               height: 50,
//                               width: 50,
//                             )
//                           : Image.network(
//                               ranker.avatar,
//                               fit: BoxFit.cover,
//                               height: 50,
//                               width: 50,
//                             ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ranker.nick,
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                           Text(
//                             '@' +
//                                 getBikeText(ranker.bikeBrand, ranker.bikeModel),
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.sports_score_rounded,
//                       color: Colors.black54,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: Text(
//                         '${ranker.score}',
//                         maxLines: 1,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WinnerList extends StatelessWidget {
//   const WinnerList({Key? key, required this.ranker}) : super(key: key);
//
//   // final int index;
//   final User ranker;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: InkWell(
//         onTap: () async {
//           final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
//               transition: Transition.rightToLeftWithFade);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             // color: Colors.grey.shade600,
//             borderRadius: BorderRadius.circular(15.0),
//             gradient: const LinearGradient(
//               colors: [Colors.black26, Colors.black],
//               // [Colors.grey, Colors.grey.shade700],
//               // : [Colors.grey, Colors.grey.shade700]
//             ),
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                   flex: 2,
//                   child: ClipOval(
//                     clipBehavior: Clip.antiAlias,
//                     child: Image.network(
//                       ranker.avatar,
//                       fit: BoxFit.cover,
//                       height: 50,
//                       width: 50,
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   flex: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           ranker.nick,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         Text(
//                           '@name',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   flex: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 12.0),
//                     child: Row(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.sports_score_rounded,
//                           color: Colors.white,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Flexible(
//                           child: Text(
//                             '${ranker.score}',
//                             maxLines: 1,
//                             style: TextStyle(
//                               color: Colors.white,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WinnerBox extends StatelessWidget {
//   const WinnerBox({Key? key, required this.ranker, this.height})
//       : super(key: key);
//   final User ranker;
//   final double? height;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(alignment: AlignmentDirectional.topCenter, children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 30.0),
//           child: Container(
//             decoration: const BoxDecoration(
//               // gradient: LinearGradient(
//               //   colors: [Colors.yellow.shade600, Colors.orange, Colors.red],
//               // ),
//               gradient: LinearGradient(
//                 colors: [Colors.white, Colors.black12],
//                 // [Colors.grey, Colors.grey.shade700],
//                 // : [Colors.grey, Colors.grey.shade700]
//               ),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black26,
//                     offset: Offset(0, 4),
//                     blurRadius: 5.0)
//               ],
//               // border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30.0),
//                   topRight: Radius.circular(30.0)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(1.0),
//               child: Container(
//                 height: height ?? 150,
//                 width: 80,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.white, Colors.grey],
//                     // [Colors.grey, Colors.grey.shade700],
//                     // : [Colors.grey, Colors.grey.shade700]
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black26,
//                         offset: Offset(0, 4),
//                         blurRadius: 5.0)
//                   ],
//                   // color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30.0),
//                       topRight: Radius.circular(30.0)),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             // gradient: LinearGradient(
//             //   colors: [Colors.yellow.shade600, Colors.orange, Colors.red],
//             // ),
//             gradient: const LinearGradient(
//               colors: [Colors.white, Colors.white10],
//               // [Colors.grey, Colors.grey.shade700],
//               // : [Colors.grey, Colors.grey.shade700]
//             ),
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
//             ],
//             border: Border.all(color: Colors.grey),
//             shape: BoxShape.circle,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(1.0),
//             child: Container(
//               height: 70,
//               width: 70,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 // border: Border.all(color: Colors.black),
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage('assets/banner/sample_avatar.jpg'),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 80,
//           child: Column(
//             children: [
//               Text(
//                 ranker.nick,
//                 style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
//               ),
//               Text(
//                 '${ranker.ranking}',
//                 style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         )
//       ]),
//     );
//   }
// }
//
// class RankerListSimpleBox extends StatelessWidget {
//   const RankerListSimpleBox({Key? key, required this.ranker}) : super(key: key);
//   final User ranker;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: InkWell(
//         onTap: () async {
//           final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
//               transition: Transition.rightToLeftWithFade);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             // color: Colors.grey.shade600,
//             borderRadius: BorderRadius.circular(15.0),
//             // gradient: const LinearGradient(
//             //   colors: [Colors.white, Colors.white10],
//             // [Colors.grey, Colors.grey.shade700],
//             // : [Colors.grey, Colors.grey.shade700]
//             // ),
//             color: Colors.white.withOpacity(0.9),
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
//             ],
//           ),
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     ClipOval(
//                       clipBehavior: Clip.antiAlias,
//                       child: Image.network(
//                         ranker.avatar,
//                         fit: BoxFit.cover,
//                         height: 40,
//                         width: 40,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             ranker.nick,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             '@' +
//                                 getBikeText(ranker.bikeBrand, ranker.bikeModel),
//                             style: const TextStyle(
//                               color: Colors.black54,
//                               fontSize: 11,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.sports_score_rounded,
//                       color: Colors.black,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: Text(
//                         '${ranker.score}',
//                         maxLines: 1,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class RankerList extends StatelessWidget {
//   const RankerList({Key? key, required this.ranker}) : super(key: key);
//   final User ranker;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: InkWell(
//         onTap: () async {
//           final result = await Get.to(() => RankerDetailPage(uid: ranker.uid),
//               transition: Transition.rightToLeftWithFade);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             // color: Colors.grey.shade600,
//             borderRadius: BorderRadius.circular(15.0),
//             gradient: const LinearGradient(
//               colors: [Colors.white, Colors.white10],
//               // [Colors.grey, Colors.grey.shade700],
//               // : [Colors.grey, Colors.grey.shade700]
//             ),
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
//             ],
//             // boxShadow: const [
//             //   BoxShadow(
//             //     color: Colors.black,
//             //     offset: Offset(1.0, 1.0), //(x,y)
//             //     blurRadius: 6.0,
//             //   ),
//             // ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                   flex: 2,
//                   child: ClipOval(
//                     clipBehavior: Clip.antiAlias,
//                     child: Image.network(
//                       ranker.avatar,
//                       fit: BoxFit.cover,
//                       height: 50,
//                       width: 50,
//                     ),
//                     // child: Image.asset(
//                     //   'assets/banner/sample_avatar.jpg',
//                     //   height: 50,
//                     //   width: 50,
//                     //   fit: BoxFit.cover,
//                     // ),
//                   ),
//                 ),
//                 Flexible(
//                   flex: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           ranker.nick,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         const Text(
//                           '@name',
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   flex: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 12.0),
//                     child: Row(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Icon(
//                           Icons.sports_score_rounded,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         Flexible(
//                           child: Text(
//                             '${ranker.score}',
//                             maxLines: 1,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
