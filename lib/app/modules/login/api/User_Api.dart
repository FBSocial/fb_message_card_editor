import 'package:fb_message_card_editor/http/Global.dart';
import 'package:fb_message_card_editor/http/http_utils.dart';
import 'package:dio/dio.dart';
import 'fb_encryption.dart';

class UserApi {
  static String updateTokenUrl = '/api/common/ctk';

  static Future sendCaptcha(String mobile, String device, String? areaCode,
      {String? codeType}) {
    return Http.request("/api/common/verification", data: {
      "mobile": fbEncrypt(mobile),
      "device": device,
      "area_code": areaCode,
      "code_type": codeType, // 用于区分不同类型的短信验证
      "encrypt_type": "FBE",
    });
  }

  static Future login(
      String mobile, String code, String device, String areaCode,
      {String thirdParty = ""}) async {
    // 登录后的接口需要用到deviceInfo的信息，所以这里获取一下，方法内部已经做了平台兼容处理
    await Global.getAndroidDeviceInfo();
    return Http.request("/api/user/login", showDefaultErrorToast: true, data: {
      "type": "mobile",
      "third_party": thirdParty,
      "mobile": fbEncrypt(mobile.toString()),
      "code": fbEncrypt(code),
      "device": device,
      "area_code": areaCode,
      "encrypt_type": "FBE",
    });
  }

  static Future getChatId() {
    return Http.request(
        'https://a1-newtest.fanbook.mobi/api/bot/d38d0bf1f449f8f08181b5b678a8123fdbbcc86d4b901c10377b3d57946f2184b9dec5005c6398b1aa6c4024ec29052e/getPrivateChat',
        showDefaultErrorToast: true,
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "user_id": Global.user.id,
        });
  }

  static Future sendPreView(num chat_id, String json) {
    return Http.request(
        'https://a1-newtest.fanbook.mobi/api/bot/d38d0bf1f449f8f08181b5b678a8123fdbbcc86d4b901c10377b3d57946f2184b9dec5005c6398b1aa6c4024ec29052e/sendMessage',
        showDefaultErrorToast: true,
        isBody: true,
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "chat_id": chat_id,
          "text": json,
        });
  }
}
