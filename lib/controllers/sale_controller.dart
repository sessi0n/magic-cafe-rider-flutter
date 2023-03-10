import 'dart:convert';

import 'package:bike_adventure/api/api_request.dart';
import 'package:bike_adventure/models/sale.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleData {
  Sale sale;
  User user;

  SaleData.fromJson(Map<String, dynamic> map)
      : sale = Sale.fromJson(map['sale']),
        user = User.fromJson(map['user']);
}

class SaleController extends GetxController {
  var scrollController = ScrollController().obs;
  var isLoading = false.obs;
  var isFirstLoading = true.obs;
  var hasMore = false.obs;
  var pageNum = 0;
  var pageSize = 20;

  RxList saleDataList = <SaleData>[].obs;

  @override
  void onInit() {
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent &&
          hasMore.value) {
        pageNum++;
        getSaleData();
      }
    });
    super.onInit();
  }

  getSaleData() async {
    if (pageNum == 0) {
      saleDataList.clear();
      hasMore.value = false;
    }

    isLoading.value = true;
    var body = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };

    ApiRequest request = ApiRequest(url: '/sale/list', body: body);
    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        var body = json.decode(value.body);

        parseSaleListBody(body);
      }
    }).catchError((onError) {
      print(onError);
    });

    isLoading.value = false;
    isFirstLoading.value = false;

    if (kDebugMode) {
      print('SaleController length: ${saleDataList.length}');
    }
  }

  void parseSaleListBody(body) {
    for (var e in body['saleInfos'] as List) {
      saleDataList.add(SaleData.fromJson(e));
    }

    hasMore.value = !((body['saleInfos'] as List).length < pageSize);
  }

  insertSale(sendObj) async {
    var ret = false;
    ApiRequest request = ApiRequest(url: '/sale/add', body: sendObj);

    await request.post().then((value) {
      if (kDebugMode) {
        print('Response status: ${value.statusCode}');
        print('Response body: ${value.body}');
      }
      if (value.statusCode == 200) {
        // var body = json.decode(value.body);

        // parseSaleListBody(body);
        ret = true;
      }
    }).catchError((onError) {
      print(onError);
    });

    // await _npcController.getSearchNpcData(isInit: true);
    pageNum = 0;
    getSaleData();

    return ret;
  }
}
