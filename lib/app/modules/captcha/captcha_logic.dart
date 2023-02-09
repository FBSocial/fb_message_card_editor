import 'dart:async';

import 'package:fb_message_card_editor/app/modules/login/api/User_Api.dart';
import 'package:fb_message_card_editor/app/routes/app_pages.dart';
import 'package:fb_message_card_editor/desktop/js/web_cookies.dart';
import 'package:fb_message_card_editor/http/Global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lib_net/src/api/user_api.dart' as user;
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/config/sp_service.dart';

import 'captcha_state.dart';

class CaptchaLogic extends GetxController {
  String updateCountWidget = 'updateCountWidget';

  final CaptchaState state = CaptchaState();
  TextEditingController? captchaController;
  final int _limitLength = 6;
  int count = 60;
  Timer? _countTimer;
  bool enableReSend = false;
  String mobile;
  late FocusNode node;

  Rx<String> codeRequestQueue = Rx<String>('');

  late Worker worker;

  CaptchaLogic(this.mobile);

  @override
  void onInit() {
    super.onInit();
    captchaController = TextEditingController();
    node = FocusNode();
    node.requestFocus();
    worker = debounce<void>(codeRequestQueue, doRequest,
        time: const Duration(milliseconds: 500));
    startCount();
  }

  @override
  void onClose() {
    super.onClose();
    captchaController?.dispose();
    _countTimer?.cancel();
  }

  void getCaptcha() {
    if (!enableReSend) return;
    enableReSend = false;
    UserApi.sendCaptcha(this.mobile, '', '86').then((res) {
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
      update([updateCountWidget]);
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
        mobile,
        captchaController?.text ?? "",
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
        _setCookie(resultMap['sign']);
      } else {
        unawaited(SpService.instance.setString(SP.token, resultMap['sign']));
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
    WebCookiesUtils.setCookie(tokenKey, token);
    // 设置当前域名token
    // webUtil.setCookie(tokenKey, token, secure: !Config.isDebug, expires: day);
    // 设置一级域名token
    // webUtil.setCookie(
    //   tokenKey,
    //   token,
    //   secure: !Config.isDebug,
    //   domain: '.${Config.webDomain}',
    //   path: '/',
    //   expires: day
    // );
  }
}
