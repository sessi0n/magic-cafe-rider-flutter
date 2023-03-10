import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/constants/enums.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/models/picutre_image.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/models/review.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/tabs/details/complete_quest_in_kakao_map.dart';
import 'package:bike_adventure/tabs/details/kakaoMapViewer2.dart';
import 'package:bike_adventure/tabs/details/modify_my_quest.dart';
import 'package:bike_adventure/tabs/details/ranker_detail_page.dart';
import 'package:bike_adventure/widget/kakao_navi_open_btn.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';

class DetailQuestPage extends StatefulWidget {
  const DetailQuestPage({Key? key, required this.quest, required this.eBinding})
      : super(key: key);
  final Quest quest;
  final eQuestBinding eBinding;

  @override
  _DetailQuestPageState createState() => _DetailQuestPageState();
}

class _DetailQuestPageState extends State<DetailQuestPage> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final QuestController _questController = Get.find<QuestController>();

  var youtubeEditingController = TextEditingController();
  var instagramEditingController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GalleryItem> galleryItems = List.empty(growable: true);
  bool isFavorite = false;
  bool isDeleteLoading = false;
  late Quest quest;
  List<Review> reviews = [];
  String ownerWord = '';
  String menuImgUrl = '';
  var reviewEditingController = TextEditingController();

  @override
  void initState() {
    quest = widget.quest;
    super.initState();

    setState(() {
      isFavorite = isFavoriteTarget(widget.quest.writer!.uid);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reviews = await _questController.getReviews(
          quest.qid, _profileController.profile!.uid);
      ownerWord = await _questController.getOwnerWord(quest.qid);
      menuImgUrl = await _questController.getCafeMenuUrl(quest.qid);

      if (quest.questImages.isEmpty) {
        List<PictureImage> images =
            await _questController.getQuestImages(quest.qid);
        for (var element in images) {
          galleryItems.add(GalleryItem(
              resource: element.pictureUrl, id: element.idx, isLocal: false));
        }
      } else {
        for (var element in quest.questImages) {
          galleryItems.add(GalleryItem(
              resource: element.pictureUrl, id: element.idx, isLocal: false));
        }
      }

      setState(() {
        reviews;
        ownerWord;
        galleryItems;
      });
    });
  }

  @override
  void dispose() {
    youtubeEditingController.dispose();
    instagramEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMine = _profileController.profile!.uid == quest.writer!.uid;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: NotificationListener<ScrollNotification>(
          child: CustomScrollView(
            // controller: _scrollController1,
            slivers: [
              _buildSliverAppBar(),
              SliverList(
                delegate: SliverChildListDelegate([
                  allButtons(context, quest),
                  KakaoMapViewer2(
                    lat: quest.lat,
                    lng: quest.lng,
                    mapHeight: 250.0,
                  ),
                  KakaoNaviOpenBtn(
                      name: quest.name,
                      location: quest.location,
                      lat: quest.lat,
                      lng: quest.lng),
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, left: 12.0, top: 20.0),
                      child: _buildListTitle()),
                  _buildListAddress(),
                  const SizedBox(
                    height: 2,
                  ),
                  quest.youtubeUrl.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 120,
                            child:
                                buildAnyLinkPreviewHorizontal(quest.youtubeUrl),
                          ),
                        )
                      : addYoutubeButton(isMine),
                  quest.instagram.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 120,
                            child:
                                buildAnyLinkPreviewHorizontal(quest.instagram),
                          ),
                        )
                      : addInstagramButton(isMine),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0, left: 12.0, top: 20, bottom: 20.0),
                    child: _buildSubPictures(context),
                    // child: _buildGallay(),
                  ),
                  buildPictureHelp(),
                  const Divider(),
                  _buildCafeMenuImage(),
                  const Divider(),
                  _buildListCounter(),
                  const Divider(),
                  _buildOwnerWord(),
                  // _buildReviewComment(),
                  Obx(
                    () => _buildQuestButton2(context, quest),
                  ),
                ]),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((_, index) {
                // return _buildList(index, _questController.questList[index]);
                return _buildReviewComment(
                    index: index, review: reviews[index]);
              }, childCount: (reviews.length))),
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  _buildEmptyReviewComment(),
                  const SizedBox(height: 30)
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSubPictures(context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: galleryItems.length,
        itemBuilder: (_, index) {
          return GalleryItemThumbnail(
            item: galleryItems[index],
            onTap: () {
              openPicture(context, index, galleryItems);
            },
          );
        },
      ),
    );
  }

  Padding _buildListCounter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // _buildQuestCount(quest.acceptCount, '진행 중인 바이커들', Colors.blueAccent,
          //     Icons.play_circle_rounded),
          _buildQuestCount(quest.completeCount, '현재 퀘스트 완료 수',
              Colors.deepPurpleAccent, Icons.done_all_outlined),
        ],
      ),
    );
  }

  Expanded _buildQuestCount(int count, String text, colors, icon) {
    return Expanded(
      child: Container(
          // width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 6,
                color: colors,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(child: Text(text)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      icon,
                      size: 18,
                      color: COMPLETED_COUNT_COLOR,
                    ),
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                        fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getQuestIcon(quest.type.index, size: 25.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                quest.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListAddress() {
    return Card(
      // elevation: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  quest.location,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: quest.location))
                      .then((value) => pushSnackbar('주소 복사', quest.location));
                },
                icon: Icon(
                  Icons.content_copy_rounded,
                  size: 15,
                )),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      expandedHeight: 220.0,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
          background: galleryItems.isNotEmpty
              ? Image.network(
                  galleryItems[0].resource,
                  fit: BoxFit.cover,
                )
              : Container()),
    );
  }

  btnFavorite() async {
    return InkWell(
        onTap: () async {
          final result =
              await _profileController.setFavorite(quest.writer!.uid);

          if (result > 0) {
            pushSnackbar('즐겨찾기', '정상적으로 ${result == 1 ? '추가' : '삭제'} 됐습니다.');

            setState(() {
              isFavorite = isFavoriteTarget(quest.writer!.uid);
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
              )));
  }

  Widget _buildQuestButton2(context, quest) {
    eQuestBinding eType = _profileController.getQuestBindingType(quest.qid);

    if (eType == eQuestBinding.completed) {
      return writeReview();
    }
    if (eType == eQuestBinding.registered) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 40,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.orange.shade700]),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(3.0))),
            child: MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder(),
              child: const Text(
                '완료 요청',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () async {
                final result = await Get.to(() => CompleteQuestInKakaoMap(
                      quest: quest,
                      type: eInBindType.complete,
                    ));
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: Get.width,
            height: 40,
            child: Text('+퀘스트를 완료하면 리뷰를 쓸 수 있습니다'),
          ),
        ],
      ),
    );
  }

  Widget writeReview() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            controller: reviewEditingController,
            onSubmitted: (text) async {
              reviewEditingController.text = text;
            },
            maxLines: 1,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '리뷰 쓰기',
                hintStyle: const TextStyle(fontSize: 12),
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    reviews = await _questController.writeReview(
                        quest.qid,
                        _profileController.profile!.uid,
                        reviewEditingController.text);
                    reviewEditingController.clear();
                    setState(() {
                      reviews;
                    });
                  },
                  icon: const FaIcon(FontAwesomeIcons.circleArrowUp,
                      color: Colors.green, size: 32),
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteQuestButton(context) {
    eQuestBinding eType = _profileController.getQuestBindingType(quest.qid);

    if (eType == eQuestBinding.registered) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
        child: Row(
          children: [
            SizedBox(
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                child: const Text(
                  '삭제',
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
                onPressed: () async {
                  showDeleteAlertDialog(context, quest);
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                child: const Text(
                  '수정',
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
                onPressed: () async {
                  Quest? back = await Get.to(() =>
                      ModifyMyQuest(quest: quest, eBinding: widget.eBinding));
                  setState(() {
                    if (back != null) {
                      // Get.off(() => DetailQuestPage(
                      //     quest: back, eBinding: widget.eBinding));
                      setState(() {
                        galleryItems.clear();
                        back.questImages.forEach((element) {
                          galleryItems.add(GalleryItem(
                              resource: element.pictureUrl,
                              id: element.idx,
                              isLocal: false));
                        });
                        quest = back;
                      });
                    }
                  });
                  // _writerController.clear();
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  isFavoriteTarget(targetUid) {
    if (targetUid == _profileController.profile!.uid) {
      return true;
    }

    User? biker = _profileController.favoriteBikers
        .firstWhereOrNull((element) => element.uid == targetUid);

    return biker != null;
  }

  showYoutubeInputDialog(BuildContext context, q) {
    AlertDialog alert = AlertDialog(
        title: const Text(
          '유투브 URL 입력',
          style: TextStyle(fontSize: 16),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: youtubeEditingController,
          // decoration: InputDecoration(hintText: "오른쪽에 붙여넣기 버튼이 있습니다"),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (!getUrlValid(youtubeEditingController.text)) {
                  pushSnackbar('유투브 URL 수정', '정상적인 URL이 아닙니다');
                  return;
                }
                Quest ret = await _questController.modifyYoutubeUrl(
                    q,
                    _profileController.profile!.uid,
                    youtubeEditingController.text);

                Navigator.pop(context);
                setState(() {
                  quest = ret;
                });
              },
              child: const Text('수정'))
        ]);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {});
  }

  showInstagramInputDialog(BuildContext context, q) {
    AlertDialog alert = AlertDialog(
        title: const Text(
          '인스타 URL 입력',
          style: TextStyle(fontSize: 16),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: instagramEditingController,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (!getUrlValid(instagramEditingController.text)) {
                  pushSnackbar('인스타 URL 수정', '정상적인 URL이 아닙니다');
                  return;
                }
                Quest ret = await _questController.modifyInstagramUrl(
                    q,
                    _profileController.profile!.uid,
                    instagramEditingController.text);

                Navigator.pop(context);
                setState(() {
                  quest = ret;
                });
              },
              child: const Text('수정'))
        ]);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {});
  }

  showDeleteAlertDialog(BuildContext context, quest) {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetYesOrNo('정말 이 퀘스트를 삭제하시겠습니까?'),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        showDeleteAlertDialog2(context, quest);
      }
    });
  }

  showDeleteAlertDialog2(BuildContext context, quest) async {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetCircularProgressIndicator("퀘스트 삭제 중..."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) async {});

    bool result = await _profileController.removeQuest(quest);
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(
          () => const MainPage(
                initialPage: 2,
              ),
          transition: Transition.rightToLeftWithFade);
    });
  }

  isItMine() {
    return quest.writer!.uid == _profileController.profile!.uid;
  }

  btnReport(context, quest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          showReportAlertDialog(context, quest);
        },
        child: Row(
          children: const [
            Icon(Icons.report, size: 13),
            Text('신고', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  btnBlock(context, quest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          showBlockAlertDialog(context, quest);
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

  showReportAlertDialog(BuildContext context, quest) {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetYesOrNo('정말 이 퀘스트를 신고하시겠습니까?'),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        showDeleteAlertDialog3(context, quest);
      }
    });
  }

  showBlockAlertDialog(BuildContext context, Quest quest) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 180,
        child: alertDialogWidgetYesOrNo(
            '정말 이 사용자를 차단하시겠습니까?\n이제부터 이 사용자의 퀘스트를 볼 수 없습니다.'),
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
        showDeleteAlertDialog4(context, quest.writer);
      }
    });
  }

  showDeleteAlertDialog3(BuildContext context, quest) async {
    AlertDialog alert = AlertDialog(
      content: alertDialogWidgetCircularProgressIndicator("퀘스트 신고 중..."),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) async {});

    bool result = await _profileController.reportQuest(quest);
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      pushSnackbar('신고', '신고하였습니다');
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

  allButtons(context, quest) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
        child: Container(
          child: InkWell(
            onTap: () {
              Get.back(result: {'result': false});
            },
            child: Row(
              children: [
                const Icon(Icons.keyboard_arrow_left,
                    color: Colors.black, size: 30),
                Flexible(
                  child: Text(
                    quest.name,
                    maxLines: 1,
                    style: const TextStyle(
                        height: 1.3,
                        fontSize: 17,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      !isItMine() ? Container() : _buildDeleteQuestButton(context),
      // !isItMine() ? btnBlock(context, quest) : Container(),
      !isItMine()
          ? const SizedBox(
              width: 7,
            )
          : Container(),
      !isItMine() ? btnReport(context, quest) : Container(),
      // const SizedBox(width: 10,),
    ]);
  }

  addYoutubeButton(bool isMine) {
    if (!isMine) {
      return Container();
    }
    return InkWell(
      onTap: () {
        showYoutubeInputDialog(context, quest);
      },
      child: Row(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //모서리를 둥글게 하기 위해 사용
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0, //그림자 깊이
            child: const FaIcon(FontAwesomeIcons.youtube,
                color: Colors.red, size: 50),
          ),
          const Text('유투브 URL 추가')
        ],
      ),
    );
  }

  addInstagramButton(bool isMine) {
    if (!isMine) {
      return Container();
    }
    return InkWell(
      onTap: () {
        showInstagramInputDialog(context, quest);
      },
      child: Row(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //모서리를 둥글게 하기 위해 사용
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0, //그림자 깊이
            child: const FaIcon(FontAwesomeIcons.instagram,
                color: Colors.blue, size: 50),
          ),
          const Text('인스타 URL 추가')
        ],
      ),
    );
  }

  buildPictureHelp() {
    if (quest.pictureHelp.isEmpty) {
      return Container();
    }

    if (getUrlValid(quest.pictureHelp)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '사진 도움 주신 분 링크 : ',
              style: TextStyle(fontSize: 12),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  launchURL(quest.pictureHelp);
                },
                child: Text(quest.pictureHelp,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _buildEmptyReviewComment() {
    if (reviews.isEmpty) {
      return const Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: ListTile(
            leading:
                FaIcon(FontAwesomeIcons.comment, color: Colors.teal, size: 20),
            // leading: ,
            title: Text(
              '리뷰가 없습니다.',
              style: TextStyle(fontSize: 14),
            ),
          ));
    }

    return Container();
  }

  _buildReviewComment({index, required Review review}) {
    bool isMine = review.uid == _profileController.profile!.uid;

    return Card(
        color: Colors.white,
        // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: ListTile(
          leading: InkWell(
            onTap: () async {
              final result = await Get.to(
                  () => RankerDetailPage(uid: review.reviewer!.uid),
                  transition: Transition.rightToLeftWithFade);
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: review.reviewer!.avatar.isNotEmpty
                    ? Image.network(
                        review.reviewer!.avatar,
                        fit: BoxFit.cover,
                        width: 35,
                        height: 35,
                      )
                    : Image.asset(
                        'assets/icons/nobody_avatar3.png',
                      ),
              ),
            ),
          ),
          title: Text(
            review.context,
            style: const TextStyle(fontSize: 14),
          ),
          trailing: isMine
              ? InkWell(
                  onTap: () async {
                    reviews = await _questController.removeReview(
                        review.rid, quest.qid, _profileController.profile!.uid);
                    reviewEditingController.clear();
                    setState(() {
                      reviews;
                    });
                  },
                  child: const FaIcon(FontAwesomeIcons.trashCan,
                      color: Colors.teal, size: 20),
                )
              : Container(
                  width: 1,
                ),
        ));
  }

  _buildOwnerWord() {
    if (ownerWord.isEmpty) {
      return Container();
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.heartCircleExclamation,
              color: Colors.amber,
            ),
            title: Text('카페 주인장'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              ownerWord,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  _buildCafeMenuImage() {
    if (menuImgUrl.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: OutlinedButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (_) => ImageDialog(imgUrl: menuImgUrl)
          );
          // PhotoView(
          //   imageProvider: CachedNetworkImageProvider(menuImgUrl),
          // );
          // ImageDialog(imgUrl: menuImgUrl,);
        },
        child: const SizedBox(
          // margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: FaIcon(
              FontAwesomeIcons.clipboardList,
              color: Colors.green,
            ),
            title: Text(
              '카페 메뉴판',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}
class ImageDialog extends StatelessWidget {
  const ImageDialog({Key? key, required this.imgUrl}) : super(key: key);
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child:            PhotoView(
        imageProvider: CachedNetworkImageProvider(imgUrl),
      )
      // child: Container(
      //   width: 200,
      //   height: 200,
      //   decoration: BoxDecoration(
      //       image: DecorationImage(
      //           image: CachedNetworkImageProvider(imgUrl),
      //           fit: BoxFit.cover
      //       )
      //   ),
      // ),
    );
  }
}
