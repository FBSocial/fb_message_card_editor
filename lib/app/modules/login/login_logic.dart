import 'package:fb_message_card_editor/app/modules/login/api/User_Api.dart';
import 'package:fb_message_card_editor/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  TextEditingController? mobileController;

  @override
  void onInit() {
    super.onInit();
    mobileController = TextEditingController(text: '')
      ..addListener(() async {});
  }

  void getCode() async {
    String phone = mobileController?.text.trim() ?? "";
    if (phone.length != 11) {
      return;
    }
    final resultMap = await UserApi.sendCaptcha(phone, 'web', '86').then((value) {
      Get.toNamed(Routes.CAPTCHA, arguments: phone);
    });
    print('resultMap:$resultMap');
  }
}
