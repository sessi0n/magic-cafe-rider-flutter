import 'package:bike_adventure/controllers/my_accept_quest_controller.dart';
import 'package:bike_adventure/controllers/my_complete_quest_controller.dart';
import 'package:bike_adventure/controllers/my_reg_quest_controller.dart';
import 'package:bike_adventure/controllers/profile_controller.dart';
import 'package:bike_adventure/controllers/quest_controller.dart';
import 'package:bike_adventure/controllers/npc_controller.dart';
import 'package:bike_adventure/controllers/rank_controller.dart';
import 'package:bike_adventure/controllers/sale_controller.dart';
import 'package:bike_adventure/controllers/writer_npc_controller.dart';
import 'package:bike_adventure/controllers/writer_quest_controller.dart';
import 'package:bike_adventure/controllers/google_service_controller.dart';
import 'package:bike_adventure/controllers/writer_sale_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(SystemController());
    // Get.lazyPut<QuestController>(() => QuestController());
    // Get.lazyPut<NpcController>(() => NpcController());
    // Get.lazyPut<WriterQuestController>(() => WriterQuestController(), fenix: true);
    // Get.lazyPut<WriterNpcController>(() => WriterNpcController(), fenix: true);
    // Get.lazyPut<MyCompleteQuestController>(() => MyCompleteQuestController());
    // Get.lazyPut<MyAcceptQuestController>(() => MyAcceptQuestController());
    // Get.lazyPut<MyRegQuestController>(() => MyRegQuestController());
    // Get.lazyPut<MyQuestController>(() => MyQuestController());
    // Get.lazyPut<RankController>(() => RankController());
    // Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    // Get.lazyPut<BikersController>(() => BikersController());
    Get.put(ProfileController());
    Get.put(QuestController());
    Get.put(NpcController());
    Get.put(SaleController());
    Get.put(WriterQuestController());
    Get.put(WriterNpcController());
    Get.put(WriterSaleController());
    Get.put(MyCompleteQuestController());
    Get.put(MyAcceptQuestController());
    Get.put(MyRegQuestController());
    Get.put(RankController());
    // Get.put(BikersController());
    Get.put(GoogleServiceController());

    print('AppBinding ALL has been created');
  }
}
