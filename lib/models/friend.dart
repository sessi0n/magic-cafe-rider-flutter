import 'package:bike_adventure/models/user.dart';
import 'package:get/get.dart';



enum eFriendState {
  REQUEST,
  RESPONSE,
  PAIRING,
  UNPAIR
}

class Friend {
  User user;
  eFriendState state;

  Friend.fromJson(Map<String, dynamic> map) :
    user = User.fromJson(map['user']),
    state = getEnumTypeByString(map['state']);

  static getEnumTypeByString(str) {
    return eFriendState.values.firstWhereOrNull((e) => e.toString() == 'eFriendState.' + str) ?? eFriendState.REQUEST;
  }
}
