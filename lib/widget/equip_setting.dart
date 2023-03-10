import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const H_PADDING_SIZE = 12.0;
const V_PADDING_SIZE = 0.0;

class EquipSetting extends StatefulWidget {
  const EquipSetting({Key? key, required this.eType}) : super(key: key);

  final EQUIP_TYPE eType;

  @override
  _EquipSettingState createState() => _EquipSettingState();
}

class _EquipSettingState extends State<EquipSetting> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final TextEditingController _textEditingController = TextEditingController();
  bool isModify = false;

  @override
  void initState() {
    isModify = _profileController.getProfileEquipsText(widget.eType).isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: H_PADDING_SIZE, vertical: V_PADDING_SIZE),
      child: Row(
        children: [
          Container(
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    getEquipTypeText(widget.eType),
                    maxLines: 2,
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: isModify
                          ? SizedBox(
                              height: 30,
                              child: TextField(
                                  controller: _textEditingController,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: HINT_BOX_DECO_COLOR,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: _profileController
                                            .getProfileEquipsText(widget.eType)
                                            .isEmpty
                                        ? '여기에 입력해 주세요'
                                        : _profileController
                                            .getProfileEquipsText(widget.eType),
                                    hintStyle: TextStyle(fontSize: 12),
                                    // prefixIcon: Icon(Icons.search),
                                  )))
                          : Text(
                              _profileController
                                  .getProfileEquipsText(widget.eType),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                  isModify
                      ? IconButton(
                          icon: const Icon(Icons.build_rounded),
                          color: Colors.grey,
                          iconSize: 20,
                          onPressed: () {
                            setState(() {
                              _profileController.setProfileEquips(
                                  widget.eType, _textEditingController.text);
                              isModify = !isModify;
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.brightness_low_rounded),
                          color: Colors.grey,
                          iconSize: 20,
                          onPressed: () {
                            setState(() {
                              isModify = !isModify;
                            });
                          },
                        )
                ],
              )),
        ],
      ),
    );
  }
}
