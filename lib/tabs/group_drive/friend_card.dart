
import 'package:bike_adventure/constants/motorcycles.dart';
import 'package:bike_adventure/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({Key? key, required this.friend, required this.onUpdateFriend, required this.onDeleteFriend}) : super(key: key);
  final Friend friend;
  final Future<bool> Function(String fid, bool isUnpair, bool isPairing, bool isAccept) onUpdateFriend;
  final Future<bool> Function(String fid) onDeleteFriend;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: ListTile(
            leading:                       ClipOval(
              clipBehavior: Clip.antiAlias,
              child: getAvatarImg(),
            ),
            title: Text(
              friend.user.nick,
              maxLines: 1,
              style: const TextStyle(
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(
              '@' +
                  getBikeText(
                      friend.user.bikeBrand, friend.user.bikeModel),
              style: const TextStyle(color: Colors.black54),
            ),
            trailing: getFriendStateIcon(context, friend.user.uid, friend.state),
        ));
  }

  Widget getAvatarImg() {
    if (friend.user == null || friend.user.uid == 0 || friend.user.avatar.isEmpty) {
      return Image.asset(
        'assets/icons/nobody_avatar3.png',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      );
    }

    return Image.network(
      friend.user.avatar,
      fit: BoxFit.cover,
      height: 50,
      width: 50,
    );
  }

  getFriendStateIcon(context, String fid, eFriendState state) {
    switch(state) {
      case eFriendState.REQUEST:
        return ElevatedButton(
          onPressed: () {},
          child: Text("요청 중"),
        );
      case eFriendState.RESPONSE:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.grey),
          onPressed: () async {
            bool isSuccess = await _onAlertButtonsPressed(context, AlertType.info, '페어링', '동행 요청을 받았습니다. 활성화 할까요?');
            debugPrint(isSuccess.toString());
            if (isSuccess) {
              onUpdateFriend(fid, false, false, true);
            }
          },
          child: Text("요청 받음"),
        );
      case eFriendState.PAIRING:
        return ElevatedButton(
          onPressed: () async {
            bool isSuccess = await _onAlertButtonsPressed(context, AlertType.info, '비활성화', '현재 활성화 중 입니다. 비활성화 할까요?');
            if (isSuccess) {
              onUpdateFriend(fid, true, false, false);
            }
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.amber),
          child: Text("페어링 중"),
        );
      case eFriendState.UNPAIR:
        return ElevatedButton(
          onPressed: () async {
            bool isSuccess = await _onAlertButtonsPressed(context, AlertType.info, '활성화', '현재 비활성화 중 입니다. 다시 활성화 할까요?');
            if (isSuccess) {
              onUpdateFriend(fid, false, true, false);
            }
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.grey),
          child: Text("비활성화"),
        );
    }
  }

  _onAlertButtonsPressed(context, type, title, desc) async {
    bool isSuccess = false;
    await Alert(
      context: context,
      type: type, // AlertType.warning,
      title: title, //"RFLUTTER ALERT",
      desc: desc, //"Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: Text(
            "취소",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context, false),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "수락",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context, true),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0),
          ]),
        )
      ],
    ).show().then((value) {
      if (value != null) {
        isSuccess = value;
      }
    });

    return isSuccess;
  }
}
