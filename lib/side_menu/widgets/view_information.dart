import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/models/quest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewInformation extends StatefulWidget {
  const ViewInformation({Key? key}) : super(key: key);

  @override
  _ViewInformationState createState() => _ViewInformationState();
}

class _ViewInformationState extends State<ViewInformation> {
  final WriterQuestController _writerController = Get.find<WriterQuestController>();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('어떤 곳인가요?', style: TextStyle(fontWeight: FontWeight.w500)),
      const Text('정보가 없으면 퀘스트가 어렵습니다..',
          style: TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(
        height: 20,
      ),
      _questTypeMenuButton(),
      const SizedBox(
        height: 20,
      ),
      // _buildQuestType(),
      _buildQuestName(),
      const SizedBox(
        height: 20,
      ),
      _buildQuestYoutubeUrl(),
      const SizedBox(
        height: 20,
      ),
      // _parkingSizeMenuButton(),
      // const SizedBox(
      //   height: 20,
      // ),
    ]);
  }

  TextField _buildQuestYoutubeUrl() {
    return TextField(
      controller: _writerController.youtubeEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _writerController.youtubeEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        labelText: '유투브 URL',
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

  Widget _buildQuestName() {
    return TextField(
      controller: _writerController.nameEditingController,
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
              _writerController.nameEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.black,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        labelText: '${getQuestTypeText(_writerController.questType.index)} 이름',
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

  Widget _questTypeMenuButton() {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
          // color: Colors.indigo,
          gradient: LinearGradient(
              colors: [Colors.white70, Colors.white]),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Center(
        child: PopupMenuButton(
          // icon: Icon(Icons.local_parking_rounded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getQuestIcon(_writerController.questType.index,
                  size: 18.0, color: Colors.black),
              const SizedBox(
                width: 10,
              ),
              Text(getQuestTypeText(_writerController.questType.index)),
            ],
          ),
          onSelected: (result) {
            setState(() {
              _writerController.questType = result as eQuestType;
            });
          },
          itemBuilder: (_) => eQuestType.values
              .map((e) => PopupMenuItem(
                  value: e,
                  child: Text(
                    getQuestTypeText(e.index),
                    style: const TextStyle(fontSize: 12),
                  )))
              .toList(),
        ),
      ),
    );
  }

  Widget _parkingSizeMenuButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          // color: Colors.indigo,
          gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade700]),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Center(
        child: PopupMenuButton(
          // icon: Icon(Icons.local_parking_rounded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_parking_rounded,
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(getParkingSizeText(_writerController.parkingSize.index)),
            ],
          ),
          onSelected: (result) {
            setState(() {
              _writerController.parkingSize = result as eParkingSize;
            });
          },
          itemBuilder: (_) => eParkingSize.values
              .map((e) => PopupMenuItem(
                  value: e,
                  child: Text(
                    getParkingSizeText(e.index),
                    style: const TextStyle(fontSize: 12),
                  )))
              .toList(),
        ),
      ),
    );
  }
}
