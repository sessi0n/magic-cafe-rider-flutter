import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/customs/alert_dialog.dart';
import 'package:bike_adventure/main_page.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Advisor extends StatefulWidget {
  const Advisor({Key? key}) : super(key: key);

  @override
  State<Advisor> createState() => _AdvisorState();
}

class _AdvisorState extends State<Advisor> {
  final ProfileController profileController = Get.find<ProfileController>();
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  String attachImg = '';

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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
        child: Text('개선 및 제안'),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
            // textInputAction: TextInputAction.go,
            keyboardType: TextInputType.multiline,
            controller: textEditingController,
            onSubmitted: (text) async {
              textEditingController.text = text;
            },
            maxLines: 20,
            decoration: InputDecoration(
              filled: true,
              fillColor: HINT_BOX_DECO_COLOR,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: '제안 및 문의 내용',
              hintStyle: const TextStyle(fontSize: 12),
              // prefixIcon: Icon(Icons.search),
              // suffixIcon: const Icon(Icons.search)
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Flexible(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                    attachImg.isEmpty ? '첨부 파일이 없습니다' : attachImg,
                    style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,
                  ),
                      )),
                ),
              ),
            ),
            Flexible(
                flex: 2,
                child: OutlinedButton(
                    onPressed: () async {
                      // final ImagePicker _picker = ImagePicker();
                      final XFile? image = await getImagePicker(source: ImageSource.gallery);
                      // await _picker.pickImage(
                      //     source: ImageSource.gallery, imageQuality: 50);
                      if (image != null && image.path.isNotEmpty) {
                        setState(() {
                          attachImg = image.path;
                        });
                      }
                    },
                    child: const Text('첨부'))),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          showAlertDialog(context, "개선 및 제안 등록 중...");
          await profileController.pushCs(textEditingController.text, attachImg);
          await Future.delayed(const Duration(seconds: 1));
          textEditingController.clear();
          attachImg = '';
          Get.back();
          showAlertDialog(context, "감사합니다.");
          await Future.delayed(const Duration(seconds: 1));
          // Get.back();
          Get.offAll(() => const MainPage());
          // Get.back();
          // Get.back();
        }, child: const Text('개선 및 제안 하기')),
      ),
    ]))
      ],
    ));
  }

  Widget _buildTitleBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.restore,
              size: APP_BAR_ICONS_SIZE,
              color: Colors.white,
            ),
            Container(
              width: 10,
            ),
            const Text(
              '사용문의/제안',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              width: 50,
            ),
          ],
        ),
      ],
    );
  }


}
