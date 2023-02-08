import 'package:flutter/services.dart';
import 'package:lib_utils/loggers.dart';
import 'package:lib_utils/universal_platform.dart';

Future<void> backToDeskTop() async {
  //初始化通信管道-设置退出到手机桌面
  const String channel = "android/back/desktop";
  const platform = MethodChannel(channel);
  //通知安卓返回,到手机桌面
  try {
    if (UniversalPlatform.isAndroid) await platform.invokeMethod('backDesktop');
  } on PlatformException catch (e) {
    logger.info("通信失败(设置回退到安卓手机桌面:设置失败) $e");
  }
  return;
}
