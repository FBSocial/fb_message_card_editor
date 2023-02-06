import 'dart:async';

import 'package:fb_message_card_editor/app/modules/login/api/User_Api.dart';
import 'package:fb_message_card_editor/app/routes/app_pages.dart';
import 'package:fb_message_card_editor/http/Global.dart';
import 'package:flutter/foundation.dart';
import 'package:fb_message_card_editor/desktop/utils/web_util/web_util.dart';
import 'package:lib_utils/config/sp_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lib_net/src/api/user_api.dart' as user;
import 'captcha_state.dart';
import 'package:lib_utils/config/config.dart';

class CaptchaLogic extends GetxController {
  final CaptchaState state = CaptchaState();
  final TextEditingController captchaController = TextEditingController();
  final int _limitLength = 6;
  int count = 60;
  Timer? _countTimer;
  bool enableReSend = false;
  String? mobile;
  late FocusNode node;

  Rx<String> codeRequestQueue = Rx<String>('');

  late Worker worker;

  CaptchaLogic(this.mobile);

  @override
  void onInit() {
    super.onInit();
    node = FocusNode();
    node.requestFocus();
    worker = debounce<void>(codeRequestQueue, doRequest,
        time: const Duration(milliseconds: 500));
    startCount();
  }

  void getCaptcha(String mobile) {
    this.mobile = mobile;
    if (!enableReSend) return;
    enableReSend = false;
    UserApi.sendCaptcha(mobile, '', '86').then((res) {
      EasyLoading.showSuccess('验证码已发送');
      startCount();
    }).catchError((e) {
      enableReSend = true;
    });
  }

  void startCount() {
    count = 60;
    _countTimer?.cancel();
    _countTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;
      if (count == 0) {
        enableReSend = true;
        _countTimer?.cancel();
      }
    });
  }

  Future<void> onChanged(value) async {
    if (value.trim().length != _limitLength) {
      return;
    }
    codeRequestQueue.subject.add(value);
  }

  Future<void> doRequest(void _) async {
    try {
      EasyLoading.show();
      FocusScope.of(Get.context!).unfocus();
      final resultMap = await UserApi.login(
        mobile!,
        captchaController.text,
        'web',
        '',
        thirdParty: '',
      );

      Global.user =
          LocalUser.fromUserInfoRes(user.UserLoginRes.fromJson(resultMap))
            ..cache();

      print('_jsonMap:$resultMap');
      Config.token = resultMap['sign'];
      EasyLoading.dismiss();

      if (kIsWeb) {
        // _setCookie(resultMap['sign']);
      }
      Get.toNamed(Routes.HOME);
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  static void _setCookie(String token) {
    final int day =
        (SpService.instance.getBool(SP.rememberPwd) ?? false) ? 30 : 1;
    const tokenKey = 'token';
    // 设置当前域名token
    webUtil.setCookie(tokenKey, token, secure: !Config.isDebug, expires: day);
    // 设置一级域名token
    webUtil.setCookie(
      tokenKey,
      token,
      secure: !Config.isDebug,
      domain: '.${Config.webDomain}',
      path: '/',
      expires: day,
    );
  }
}
