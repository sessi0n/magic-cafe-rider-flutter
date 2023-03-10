import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CafeOwnerWord extends StatefulWidget {
  const CafeOwnerWord({Key? key}) : super(key: key);

  @override
  State<CafeOwnerWord> createState() => _CafeOwnerWordState();
}

class _CafeOwnerWordState extends State<CafeOwnerWord> {
  final ProfileController profileController = Get.find<ProfileController>();
  TextEditingController textEditingController = TextEditingController();
  String word = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      word = await profileController.getOwnerWord();

      setState(() {
        textEditingController.text = word;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Get.back();
            }),
        centerTitle: true,
        title: const Text(
          '사장님 한마디',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: TextField(
            // textInputAction: TextInputAction.go,
            keyboardType: TextInputType.multiline,
            controller: textEditingController,
            onSubmitted: (text) async {
              textEditingController.text = text;
            },
            maxLines: 30,
            decoration: InputDecoration(
              filled: true,
              fillColor: HINT_BOX_DECO_COLOR,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: '카페 홍보 내용',
              hintStyle: const TextStyle(fontSize: 12),
              // prefixIcon: Icon(Icons.search),
              // suffixIcon: const Icon(Icons.search)
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              showAlertDialog(context, "등록 중...");
              await profileController.setOwnerWord(textEditingController.text);
              await Future.delayed(const Duration(seconds: 1));
              textEditingController.clear();
              Get.back();
              showAlertDialog(context, "등록됐습니다.");
              await Future.delayed(const Duration(seconds: 1));
              Get.offAll(() => const MainPage());
            }, child: const Text('등록 하기')),
          ),

        ],
      ),
    ));
  }
}
