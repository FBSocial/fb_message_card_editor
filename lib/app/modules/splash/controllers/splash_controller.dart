import 'package:fb_message_card_editor/app/routes/app_pages.dart';
import 'package:fb_message_card_editor/http/Global.dart';
import 'package:fb_message_card_editor/http/http_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lib_utils/config/sp_service.dart';
import 'package:lib_utils/config/config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;

  bool get isLogin =>
      SpService.instance.getInt(SP.tokenUpdateTime) != null &&
      Global.user.id.isNotEmpty &&
      DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(
              SpService.instance.getInt(SP.tokenUpdateTime)!)
          .add(const Duration(days: 30)));

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  _init() async {
    assert((() {
      Config.isDebug = true;
      Config.env = Env.dev;
      return true;
    })());
    await SpService.instance.ensureInitialized();
    Global.packageInfo = kIsWeb
        ? PackageInfo(
            appName: 'fanbook',
            version: '1.6.50',
            packageName: 'web',
            buildNumber: '20')
        : await PackageInfo.fromPlatform();
    await Global.user.read();
    Config.initEnv();
    Config.env = Env.newtest;

    Http.init();
    Get.toNamed(Routes.LOGIN);
    // if (isLogin) {
    //   Get.toNamed(Routes.HOME);
    // } else {
    //   Get.toNamed(Routes.LOGIN);
    // }
  }
}
