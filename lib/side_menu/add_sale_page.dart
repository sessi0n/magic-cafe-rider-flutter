import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/writer_sale_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({Key? key}) : super(key: key);

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  bool isUpload = true;

  final WriterSaleController writerSaleController = Get.find<WriterSaleController>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildAppBar(),
        SliverList(
            delegate: SliverChildListDelegate([
          _cardMenuInfo(),
        ]))
      ],
      ),
    ),
    );
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
              const ImageIcon(
                AssetImage('assets/icons/box4.png'),
                size: APP_BAR_ICONS_SIZE,
                color: Colors.white,
              ),
              Container(
                width: 10,
              ),
              const Text(
                'SAIL 등록',
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

  _cardMenuInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildSaleTitle(),
            const SizedBox(
              height: 20,
            ),
            _buildWebUrl(),
            const SizedBox(
              height: 20,
            ),
            buildDate(),
            const SizedBox(
              height: 20,
            ),
                addQuestButton(context),
          ]),
        ),
      ],
    );
  }

  Padding addQuestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.indigo,
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blueAccent.shade700]),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(3.0))),
        child: RawMaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.app_registration_rounded,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "SALE 등록하기",
                style:
                TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();

            if (!writerSaleController.isValid()) {
              pushSnackbar('SALE 등록', '잘못된 값이 있습니다');
              return;
            }

            if (!getUrlValid(writerSaleController.urlEditingController.text)) {
              pushSnackbar('SALE 등록', '잘못된 URL 입니다');
              return;
            }

            showAlertDialog(context, "SALE 등록 중...");
            bool ret = await writerSaleController.insertSale();

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
              if (ret) {
                writerSaleController.clear();
              }

              Get.back(result: {'result': ret});
            });
          },
        ),
      ),
    );
  }

  Row buildDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white, offset: Offset(0, 4), blurRadius: 5.0)
            ],
          ),
          child: TextButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                var now = DateTime.now();
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(now.year, 1, 1),
                    maxTime: DateTime(now.year + 1, 12, 31), onChanged: (date) {
                  // print('change $date');
                }, onConfirm: (date) {
                  // print('confirm $date');
                  setState(() {
                    writerSaleController.start = date;
                    writerSaleController.isWriteStart = true;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.ko);
              },
              child: !writerSaleController.isWriteStart
                  ? const Text(
                      '시작 날짜',
                      style: TextStyle(color: Colors.blue),
                    )
                  : Text(getSaleDateText(writerSaleController.start))),
        ),
        Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white, offset: Offset(0, 4), blurRadius: 5.0)
            ],
          ),
          child: TextButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                var now = DateTime.now();

                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(now.year, 1, 1),
                    maxTime: DateTime(now.year + 1, 12, 31), onChanged: (date) {
                  // print('change $date');
                }, onConfirm: (date) {
                  // print('confirm $date');
                  setState(() {
                    writerSaleController.end = date;
                    writerSaleController.isWriteEnd = true;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.ko);
              },
              child: !writerSaleController.isWriteEnd
                  ? const Text(
                      '끝 날짜',
                      style: TextStyle(color: Colors.blue),
                    )
                  : Text(getSaleDateText(writerSaleController.end))),
        ),
      ],
    );
  }

  TextField _buildWebUrl() {
    return TextField(
      controller: writerSaleController.urlEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.ac_unit_rounded,
          color: Colors.black,
          size: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              writerSaleController.urlEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        labelText: 'WEB URL',
        labelStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        // focusedBorder: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //   borderSide: BorderSide(width: 1, color: Colors.green),
        // ),
        // enabledBorder: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //   borderSide: BorderSide(width: 1, color: Colors.green),
        // ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildSaleTitle() {
    return TextField(
      controller: writerSaleController.titleEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.ac_unit_rounded,
          color: Colors.black,
          size: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              writerSaleController.titleEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        labelText: '타이틀',
        labelStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
