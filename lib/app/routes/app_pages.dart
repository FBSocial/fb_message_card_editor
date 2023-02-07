import 'package:fb_message_card_editor/app/modules/captcha/captcha_binding.dart';
import 'package:fb_message_card_editor/app/modules/captcha/captcha_view.dart';
import 'package:fb_message_card_editor/app/modules/login/login_binding.dart';
import 'package:fb_message_card_editor/app/modules/login/login_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CAPTCHA,
      page: () => CaptchaPage(),
      binding: CaptchaBinding(),
    ),
  ];
}
