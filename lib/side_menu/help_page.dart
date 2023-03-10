import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/models/npc.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:bike_adventure/side_menu/private_clause.dart';
import 'package:bike_adventure/side_menu/private_right.dart';
import 'package:bike_adventure/side_menu/service_codec.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int currentStepQuest = 0;
  int currentStepFavorite = 0;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
    controller: scrollController,
    slivers: [
      SliverAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.7),
        foregroundColor: Colors.white,
        floating: true,
        pinned: true,
        snap: false,
        centerTitle: false,
        title: _buildTitleBar(),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.cancel_rounded,
                color: Colors.white,
              )),
        ],
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    '바이크로 갈 수 있는 멋진 장소를 탐방해 보세요',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                      'Quest를 통해 카페/맛집/캠핑/로드 지역을 탐방할 수 있습니다.'),
                ),
                Text('사장님이 바이커인 경우와 멋진 풍경 또는 와인딩 코스는 Quest에서 볼 수 있습니다.'),
                Text('NPC는 교육/어시스트/장비상점/튜닝샵/웹스토어/브랜드샵/맛집 지역이 등록 되어있습니다.'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('중앙에 맵 버튼을 통해 찾아가려는 곳에 정보를 미리 확인해 보세요. 주변 카페나 맛집을 미리 알 수 있습니다.'),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 8.0),
                //   child: Text(
                //       '퀘스트 완료(+15점) 이 후 출석(+1점)으로 점수를 올릴 수 있습니다.'),
                // ),
              ],
            ),
          ),
          const Divider(),
          // const Padding(
          //     padding: EdgeInsets.all(12.0),
          //     child: Text('퀘스트 등록 방법',
          //         style: TextStyle(
          //             fontSize: 14, fontWeight: FontWeight.w700))),
          // Stepper(
          //   physics: const ClampingScrollPhysics(),
          //   steps: [
          //     Step(
          //       title: const Text('Step 1'),
          //       content: Wrap(children: const [
          //         Text('메뉴 버튼 '),
          //         Icon(
          //           Icons.add_rounded,
          //           size: 18,
          //         ),
          //         Text('을 누루고, "퀘스트 등록" 버튼을 터치하세요.'),
          //       ]),
          //     ),
          //     const Step(
          //       title: Text('Step 2'),
          //       content: Text('퀘스트 등록 창에서 카카오맵을 통한 위치를 정확히 입력 할 수 있습니다. '
          //           '단, 다른 바이커들이 퀘스트를 완료하기 위해서는 30m 안에서만 완료 버튼이 활성화 됩니다. '
          //           '퀘스트 이름, 지역과 최소 한 장의 사진이 꼭 필요합니다.'),
          //     ),
          //     const Step(
          //       title: Text('Step 3'),
          //       content: Text('퀘스트 등록 버튼을 통해 서버에 저장시킬 수 있습니다. '
          //           'My Quests 탭에서 내가 등록한 퀘스트를 확인할 수 있습니다. '
          //           '원한다면 등록한 퀘스트를 삭제할 수도 있습니다. '
          //           '단, NPC를 따로 확인할 수 있는 창은 없습니다. '),
          //     ),
          //   ],
          //   currentStep: currentStepQuest,
          //   onStepTapped: (int newStep) {
          //     setState(() {
          //       currentStepQuest = newStep;
          //     });
          //   },
          //   controlsBuilder: (_, details) {
          //     return Container();
          //   },
          // ),
          // const Divider(),
          const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('아이콘 설명',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      FaIcon(FontAwesomeIcons.delicious,
                          color: Colors.green, size: 15),
                      SizedBox(
                        width: 10,
                      ),
                      Text('참여 가능한 퀘스트')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 17, color: Colors.amber),
                      SizedBox(
                        width: 10,
                      ),
                      Text('완료한 퀘스트')
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              // direction: Axis.horizontal,
              // alignment: WrapAlignment.start,
              // spacing: 12,
              runSpacing: 12,
              children: [
                _expQuestIcon(0, '카페'),
                _expQuestIcon(1, '맛집'),
                _expQuestIcon(2, '캠핑'),
                _expQuestIcon(3, '로드'),
                _expNpcIcon(6, '교육'),
                _expNpcIcon(7, '어시스트'),
                _expNpcIcon(0, '브랜드샵'),
                _expNpcIcon(1, '장비상점'),
                _expNpcIcon(2, '튜닝샵'),
                _expNpcIcon(3, '웹스토어'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: const Divider(),
          ),
          // const Padding(
          //     padding: EdgeInsets.all(12.0),
          //     child: Text('바이커 즐겨찾기 방법',
          //         style: TextStyle(
          //             fontSize: 14, fontWeight: FontWeight.w700))),
          // Stepper(
          //   physics: const ClampingScrollPhysics(),
          //   steps: [
          //     Step(
          //       title: const Text('Step 1'),
          //       content: Wrap(children: const [
          //         Text('즐겨찾기를 원하는 바이커의 퀘스트를 터치하여 퀘스트 페이지로 들어갑니다.'),
          //       ]),
          //     ),
          //     Step(
          //       title: const Text('Step 2'),
          //       content: Wrap(
          //         children: const [
          //           Text('퀘스트 페이지 안에 '),
          //           Icon(
          //             Icons.favorite_border_rounded,
          //             size: 18,
          //           ),
          //           Text('표시를 터치하면 즐겨찾기가 활성화 되면서  '),
          //           Icon(
          //             Icons.favorite_rounded,
          //             size: 18,
          //           ),
          //           Text('표시로 바뀌게 됩니다.'),
          //         ],
          //       ),
          //     ),
          //     const Step(
          //       title: Text('Step 3'),
          //       content: Text('퀘스트탭 상단에 즐겨찾기를 한 바이커들을 볼 수 있습니다.'
          //           '즐겨찾기한 바이커를 터치하면 해당 바이커가 등록한 퀘스트를 한 번에 볼 수 있습니다.'),
          //     ),
          //   ],
          //   currentStep: currentStepFavorite,
          //   onStepTapped: (int newStep) {
          //     setState(() {
          //       currentStepFavorite = newStep;
          //     });
          //   },
          //   controlsBuilder: (_, details) {
          //     return Container();
          //   },
          // ),
          // const Divider(),
          const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('모험 포인트란?',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
            child: Text('모험 포인트를 얻을 수 있는 방법은 퀘스트를 수행하는 것입니다. '
                '퀘스트를 수행할 때마다 +15, 출석 체크로 +1, 카페 이벤트를 통해 +3을 얻을 수 있습니다. '
                '이런 점수를 얻기 위해서는 해당 위치 100m 안에서 만 수행 가능합니다. '
                '랭킹 탭은 자신이 가진 모험 포인트에 대한 랭킹입니다.\n'
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            thickness: 10,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Wrap(
              children: [
                InkWell(
                    onTap: () {
                      Get.to(() => const PrivateClause(), transition: Transition.downToUp);
                    },
                    child: const Text(
                      '서비스 이용약관',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    )),
                const SizedBox(width: 10,),
                InkWell(
                    onTap: () {
                      Get.to(() => const PrivateRight(), transition: Transition.downToUp);
                    },
                    child: const Text(
                      '개인정보 처리방침',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    )),
                const SizedBox(width: 10,),
                InkWell(
                    onTap: () {
                      Get.to(() => const ServiceCodec(), transition: Transition.downToUp);
                    },
                    child: const Text(
                      '앱 이용약관',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    )),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Take-off.kr',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '주소:서울 금천구 가산디지털1로 171 가산 SK v1 Center 1605호',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '사업자등록번호:211-88-47544',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '개인정보관리책임자:김관빈',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '대표이사:김동보',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ]),
      ),
    ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.personChalkboard, size: 25),
            Container(
              width: 20,
            ),
            const Text(
              '도움말',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  _expNpcIcon(int i, String s) {
    return                 Container(
      width: 100,
      child: Row(
          children: [
            getNpcIcon(i),
            const SizedBox(
              width: 10,
            ),
            Text(s)
          ],
        ),
    );
  }
  _expQuestIcon(int i, String s) {
    return                 Container(
      width: 100,
      child: Row(
        children: [
          getQuestIcon(i),
          const SizedBox(
            width: 10,
          ),
          Text(s)
        ],
      ),
    );
  }
}
