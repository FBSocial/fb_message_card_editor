import 'package:fb_message_card_editor/app/modules/login/login_logic.dart';
import 'package:get/get.dart';



class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginLogic>(
      () => LoginLogic(),
    );
  }
}
