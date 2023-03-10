import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/controllers/sale_controller.dart';
import 'package:bike_adventure/customs/custom_indicator_bike.dart';
import 'package:bike_adventure/models/sale.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:bike_adventure/side_menu/side_menu_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:any_link_preview/any_link_preview.dart';

class SalePage extends StatefulWidget {
  const SalePage({Key? key}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final SaleController saleController = Get.find<SaleController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.getSaleData();
    });
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
          controller: saleController.scrollController.value,
          slivers: [
            _buildAppBar(scaffoldKey),
            Obx(() {
              if (!saleController.isLoading.value) {
                if (saleController.saleDataList.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          '세일하는 웹페이지가 없습니다.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                }
              }
              return SliverToBoxAdapter(
                child: Container(),
              );
            }),
            Obx(() {
              return SliverList(
                  delegate: SliverChildBuilderDelegate((_, index) {
                return _buildList(
                    index,
                    saleController.saleDataList[index].sale,
                    saleController.saleDataList[index].user);
              }, childCount: (saleController.saleDataList.length)));
            }),
            Obx(() {
              return SliverToBoxAdapter(
                child: saleController.isLoading.value
                    ? (saleController.isFirstLoading.value
                        ? const CustomIndicatorBike(size: 200)
                        : const LinearProgressIndicator())
                    : const SizedBox(height: 60),
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
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.tags, size: 25),
          Container(
            width: 10,
          ),
          const Text(
            'Sale & Event',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => scaffoldKey.currentState.openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildList(int index, Sale sale, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Container(
            height: isInSaleDate(sale.end)
                ? 210 : 110,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // flex: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // getQuestIcon(attr.type.index),
                              const Icon(
                                Icons.link,
                                size: 12,
                              ),
                              Expanded(
                                // flex: 10,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    sale.title,
                                    style: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w700),
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        // '${getAreaCityText(attr.area, attr.city)}',
                        '${getSaleDateText(sale.start)}',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        '~ ${getSaleDateText(sale.end)}',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                isInSaleDate(sale.end)
                    ? SizedBox(height: 150, child: sale.imgUrl.isNotEmpty ? buildNetImg(sale.imgUrl, sale.url) : buildAnyLinkPreview(sale.url))
                    : buildSaleOff(),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Container buildSaleOff() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        // border: Border.all(
        //   width: 1,
        //   color: Colors.grey,
        // ),
        // boxShadow: const [
        //   BoxShadow(
        //       color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      ),
      child: const Center(
          child: Text(
        'Sale OFF',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      )),
    );
  }

  buildNetImg(String imgUrl, String url) {
    return InkWell(
      onTap: () {
        launchURL(url);
      },
      child: Container(
        // height: 220,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius:
            const BorderRadius.all(Radius.circular(3.0)),
            image: DecorationImage(
              image: NetworkImage(
                Environment.cdnUrl + imgUrl,
                // _profileController.getMyProfileImg(),
              ),
              fit: BoxFit.fitWidth,
            )),
      ),
    );
  }
}
