import 'package:get/get.dart';

import 'captcha_logic.dart';

class CaptchaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaptchaLogic>(() {
      return CaptchaLogic(Get.arguments);
    });
  }
}
