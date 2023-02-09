import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fb_message_card_editor/app/routes/app_pages.dart';
import 'package:fb_message_card_editor/http/Global.dart';
import 'package:fb_message_card_editor/http/strategy/http_mobile_strategy.dart';
import 'package:fb_message_card_editor/http/strategy/http_strategy.dart';
import 'package:fb_message_card_editor/http/strategy/http_web_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as get_x;
import 'package:lib_net/lib_net.dart' as net;
import 'package:lib_net/lib_net.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/config/sp_service.dart';
import 'package:lib_utils/random_string.dart';
import 'package:lib_utils/utils.dart';
import 'package:uuid/uuid.dart';

import 'interceptor/channel_mutex_interceptor.dart';
import 'interceptor/logging_interceptor.dart';

String networkErrorText = '网络质量不佳，请稍后重试'.tr;

/// 封装了消息代理，服务器错误处理
class Http {
  static Dio dio = Dio();
  static int timeOut = 15; // 超时时间， 单位s
  static bool useProxy = false;

  static void init({
    bool closeOld = false,
  }) {
    useProxy = SpService.instance.getBool(SP.useProxy) ?? false;
    final String? proxy = SpService.instance.getString(SP.proxySharedKey);

    net.Env env = net.Env.newTest;
    final savedEnvVar = SpService.instance.getInt(SP.networkEnvSharedKey);
    if (savedEnvVar != null) {
      env = net.Env.values[savedEnvVar];
    } else if (Config.isDebug) {
      env = net.Env.newTest;
    }

    net.Http.errorToaster = (msg) {
      EasyLoading.showInfo(msg.tr);
    };
    print('init... ');
    Global.getDeviceInfo().then((value) {
      print('reinitialize ');
      net.Http.reinitialize(
        env: env,
        proxy: useProxy ? proxy : null,
        superProperties: SuperProperties(
            version: Global.packageInfo!.version,
            platform: Global.deviceInfo!.systemName!.toLowerCase(),
            channel: Config.channel,
            systemName: Global.deviceInfo!.systemName!.toLowerCase(),
            deviceId: Global.deviceInfo!.identifier,
            buildNumber: Global.packageInfo?.buildNumber ?? ''),
      );
      net.Http.dio!.interceptors
        ..add(MutexInterceptor())
        ..add(LoggingInterceptor());
    });

    if (closeOld) {
      ///关闭所有请求，dio无法继续使用, 重新new一个dio
      dio.close(force: true);
      dio = Dio();
    }

    HttpStrategy strategy;
    if (kIsWeb) {
      strategy = WebHttpStrategy();
    } else {
      strategy = MobileHttpStrategy();
    }
    strategy.init(dio, timeOut);

    if (useProxy && isNotNullAndEmpty(proxy)) setProxy(dio, proxy);
  }

  // 设置系统 http 代理也抓不到 flutter 的包，必须设置 dio 的代理才能抓到。
  static void setProxy(Dio dio, String? proxy) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return "PROXY $proxy";
      };
      // 需要校验所有证书：只有有效的根证书才能被信任。
      // CA颁发的证书，被系统成功认证的话，不会走到这个回调；没有成功认证会走到这里。直接返回false,拒绝这些情况的请求。
      // 我们的证书是CA颁发的，被系统认证的。因此能够正常访问。
      client.badCertificateCallback = (cert, host, port) {
        // return false;
        return true;
      };
      return null;
    };
  }

  static Map<String, dynamic> getHeader(
      {Map<String, dynamic>? headers, Map? data}) {
    final Map<String, dynamic> headerMap = headers ?? {};
    // 内置通用header 发请求的时候再来取token
    final Map commonHeaders = {
      "Nonce": const Uuid().v4(),
      "Timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "Authorization": Config.token ?? ""
    };
    if (!kIsWeb) commonHeaders["AppKey"] = Config.appKey;

    // 优先外部传入的header的。commonHeaders覆盖非null
    commonHeaders.forEach((key, value) {
      if (value == null) {
        headerMap[key] = value;
      } else {
        headerMap.putIfAbsent(key, () => value);
      }
    });
    final List signList = ["Nonce", "AppKey", "Timestamp", "Authorization"];
    final Map signMap = Map.from(headerMap);
    signMap.removeWhere((key, value) {
      if (signList.contains(key)) {
        return false;
      } else {
        return true;
      }
    });
    if (data == null) {
      signMap["RequestBody"] = "";
    } else {
      data["transaction"] = RandomString.length(12);
      signMap["RequestBody"] = jsonEncode(data);
    }
    final List<String> keys = List.from(signMap.keys);
    keys.sort((a, b) => a.compareTo(b));
    String signStr = keys.map((e) {
      if (signMap[e] == null) {
        return "$e=";
      } else {
        return "$e=${signMap[e]}";
      }
    }).reduce((v, element) {
      return "$v&$element";
    });
    signStr += "&${Config.appSecret}";
    signStr = Uri.encodeComponent(signStr);
    //遵循RFC-3986标准(https://tools.ietf.org/html/rfc3986)
    // encodeComponent 执行的是 [2396标准]，`-_.!~*'()`不转。[3986标准]`-._~`不转
    // 因此，还需要对 `!*'()`进行转码
    signStr = signStr.replaceAllMapped(RegExp("[!*'()]"), (match) {
      final s = match[0];
      // if(s.length == 1){
      //   var i = int.parse(s[0]);
      //   return "%";
      // }
      if (s == "!") return "%21";
      if (s == "*") return "%2A";
      if (s == "'") return "%27";
      if (s == "(") return "%28";
      if (s == ")") return "%29";
      return s!;
    });
    // signStr = Uri.encodeQueryComponent(signStr);

    // logger.info("path: $path data:$data");
    // logger.info("signStr: " + signStr);
    final signature = md5.convert(utf8.encode(signStr)).toString();
    headerMap["signature"] = signature;
    return headerMap;
  }

  /// 发送消息请求
  static Future<dynamic> request(String path,
      {Map? data,
      Options? options,
      bool autoRetryIfNetworkUnavailable = false,
      bool showDefaultErrorToast = false,
      CancelToken? cancelToken,
      bool? isOriginDataReturn = false, //是否源数据返回
      bool isReturnString = false,
      bool isBody = false,
      int retries = 0}) async {
    try {
      // Logger.net(path, data: data);
      options ??= Options();
      options.headers = getHeader(headers: options.headers, data: data);

      if (retries > 0) {
        final String? channelId = data!["channel_id"];
      } else if (autoRetryIfNetworkUnavailable && retries == 0) {}

      Response<dynamic> res;

      HttpStrategy strategy;
      if (kIsWeb) {
        strategy = WebHttpStrategy();
      } else {
        strategy = MobileHttpStrategy();
      }

      res = await strategy.post(
          dio: dio,
          path: path,
          data: isBody ? jsonEncode(data) : data,
          cancelToken: cancelToken,
          options: options,
          timeOut: timeOut);

      // logger.info('http path = $path , data = $data, res = $res');
      ///成功但是不返回数据
      if (res.statusCode == 204) {
        return {};
      }

      var resData = res.data;
      if (res.data is String && !isReturnString) {
        resData = jsonDecode(res.data);
      }

      if (isOriginDataReturn!) {
        return resData;
      }

      if (resData["status"] == true) {
        return resData["data"];
      }

      if (resData["ok"] == true) {
        return resData["result"];
      }

      final String errorMes =
          errorCode2Message["${resData["code"] ?? resData["message"]}"] ??
              resData["desc"] ??
              "";
      final int code = int.tryParse("${resData["code"]}") ??
          int.tryParse("${resData["message"]}") ??
          0;
      if (showDefaultErrorToast && errorMes.isNotEmpty) _showToast(errorMes);
      throw RequestArgumentError(code, url: path, message: errorMes);
    } on RequestArgumentError catch (e) {
      if (quitCodeSet.contains(e.code) &&
          path != '/api/user/ct' &&
          path != '/api/user/login' &&
          path != '/api/common/verification') {
        // 退出登录
        await _logout(error: e);
      }
      rethrow;
    } catch (e) {
      if (e is DioError) {
        final String error =
            "${e.toString()} (path:${Config.host + path} params:${e.requestOptions.data})";
        if (showDefaultErrorToast) {
          if (kIsWeb) {
            _showError(networkErrorText, error);
          } else {
            /// 先不提示错误，看看是否可行
            if (e.type == DioErrorType.response) {
              _showError("服务器开小差了，请稍后重试".tr, error);
            } else if (e.type != DioErrorType.cancel) {
              /// 审核检测报错会在检测工具类中toast
              /// 当异常类型为DioErrorType.cancel时为代码中主动取消请求，为正常业务逻辑，不弹toast提示,其他情况提示网络质量问题
              _showError(networkErrorText, error);
            }
          }
        }
      } else if (e is TimeoutException) {
        final String error =
            "${e.toString()} (path:${Config.host + path} params:$data)";
        if (showDefaultErrorToast) _showError(networkErrorText, error);
      }

      rethrow;
    }
  }

  //
  // static Future<void> _logout({RequestArgumentError? error}) async {
  //   if (Routes.currentRoute == app_pages.Routes.LOGIN) return;
  //   Routes.currentRoute = app_pages.Routes.LOGIN;
  //
  //   GlobalState.logout();
  //
  //   CountryModel? country;
  //   final countryString = SpService.instance.getString(SP.country);
  //   if (countryString != null && countryString.isNotEmpty) {
  //     final map = json.decode(countryString);
  //     country = CountryModel.fromMap(map);
  //   }
  //
  //   // todo 登入过期会一直重连
  //   final alterInfo = (error?.code == 903) ? error!.message : '登录已过期，请重新登录'.tr;
  //
  //   if (alterInfo != null) {
  //     unawaited(Future.delayed(const Duration(milliseconds: 300)).then((value) {
  //       showTokenFailDialog(get_x.Get.context!, alterInfo: alterInfo);
  //     }));
  //   }
  //   unawaited(get_x.Get.offAllNamed(app_pages.Routes.LOGIN,
  //       arguments: LoginArgs(country: country)));
  // }

  static void _showError(String toast, String error) {
    if (isNotNullAndEmpty(toast)) EasyLoading.showInfo(toast);
  }

  static void _showToast(String toast) {
    EasyLoading.showInfo(toast);
  }

  static bool isNetworkError(Object? error) {
    return error is DioError &&
        [
          DioErrorType.cancel,
          DioErrorType.connectTimeout,
          DioErrorType.sendTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.other,
        ].contains(error.type);
  }

  static _logout({required RequestArgumentError error}) {
    if (get_x.Get.currentRoute == Routes.LOGIN) return;
    Global.user = LocalUser();
    Config.token = '';
    unawaited(SpService.instance.setString(SP.token, ''));
    unawaited(SpService.instance.setString(SP.userInfoSharedKey, ''));
    get_x.Get.offAndToNamed(Routes.LOGIN);
  }
}

final errorCode2Message = {
  "903": "账号被封禁".tr,
  "1000": "成功".tr,
  "1001": "参数错误".tr,
  "1002": "频道创建失败".tr,
  "1003": "用户创建失败".tr,
  "1004": "账号不存在".tr,
  "1005": "密码错误".tr,
  "1006": "频道删除失败".tr,
  "1007": "用户不存在".tr,
  "1008": "请先加入服务器".tr,
  "1009": "服务创建失败".tr,
  "1010": "用户 已经加入过服务器".tr,
  "1011": "服务器不存在".tr,
  "1012": "你没有所需的权限".tr,
  "1013": "dm频道创建失败".tr,
  "1014": "分类错误".tr,
  "1015": "已达今日发送次数上限".tr,
  "1016": "验证码已过期".tr,
  "1017": "短信发送失败".tr,
  "1018": "验证码错误".tr,
  "1019": "保存失败".tr,
  "1020": "发送消息太频繁了，请稍后再试".tr,
  "1021": "频道不存在".tr,
  "1025": "该邀请链接不存在或已失效".tr,
  "1029": "操作失败".tr,
  "1031": "好友申请已失效".tr,
  "1034": "消息不存在".tr,
  "1035": "身份组不存在".tr,
  "1036": "消息已撤回".tr,
  "1037": "发送失败，已被对方拒收".tr,
  "1038": "发送失败，已被对方拒收".tr,
  "1040": "对方不接受添加好友".tr,
  "1041": "对方已是你的好友".tr,
  "1042": "token授权错误".tr,
  "1043": "授权超时".tr,
  "1047": "发送已超过2分钟，无法撤回".tr,
  "1050": "请完善基础信息".tr,
  "1052": "直播间已存在，请勿重复创建".tr,
  "1059": "表态已删除".tr,
  "1061": "无创建文档权限".tr,
  "1068": "你已经被服务器加入黑名单".tr,
  "1070": "该消息已被pin".tr,
  "1071": "该消息已取消pin".tr,
  "1087": "找不到评论".tr,
  "1088": "没有权限".tr,
  "1089": "内容已删除".tr,
  "1090": "动态已被置顶".tr,
  "1091": "动态已被取消置顶".tr,
  "1093": "选择的频道不存在，修改后重试".tr,
  "1094": "内容重复提交".tr,
  "1101": "你可创建的服务器已达上限".tr,
  "1109": "未完成问卷".tr,
  "1105": "未实名认证".tr,
  "1207": "当前使用的是内测版本，无法使用充值功能。如有需要，请从App Store下载正式版本。".tr,
  "2002": "该机器人正在使用中，无法移除".tr,
  "2006": "机器人已被移除".tr,
  "3001": "你输入的金额错误".tr,
  "3002": "今天发出的红包金额已达上限".tr,
  "3003": "你输入的红包金额或个数有误".tr,
  "3004": "你已收过该红包了".tr,
  "3005": "一天内收同一人的红包不能超过10次".tr,
  "3006": "一天内收红包不能超过100次".tr,
  "3007": "红包不存在或还没放开领取".tr,
  "3008": "你尚未绑定支付宝账号".tr,
  "3009": "领取失败，请检查支付宝账号后重试".tr,
  "3010": "该支付宝已被绑定在其他账号下".tr,
  "3011": "支付宝账号绑定失败".tr,
  "3012": "你不能抢自己发的红包".tr,
  "3013": "你已经绑定了支付宝".tr,
  "4002": "机器人身份组，无法删除".tr,
  "4001": "该设备已达到每日注册数上限，请明日再试".tr,
  "4003": "机器人身份组，无法添加".tr,
  "6002": "文件不存在".tr,
  "6003": "已经拥有该权限".tr,
  "6004": "找不到根目录".tr,
  "6005": "不支持的文档类型.tr",
  "6006": "最多添加100个协作者".tr,
  "6007": "文档设置不可生成副本".tr,
  "4004": "操作过快".tr,
  "5001": "您已表态过".tr,
  "8001": "手机号格式错误".tr,
  "8002": "仅限年满18周岁的中国大陆用户使用".tr,
  "8003": "保存钱包数据异常".tr,
  "8004": "已实名认证".tr,
  "8005": "身份证号有误，请修改后重试".tr,
  "8100": "服务异常，请稍后再试！".tr,
  "8101": "服务异常，请稍后再试！".tr,
  "8102": "服务异常，请稍后再试！".tr,
  "8103": "服务异常，实名认证失败！".tr,
  "8104": "服务异常，请稍后再试！".tr,
  "8105": "手机号持有人与实名信息不符".tr,
  "9000": "验证码已过期".tr,
  "9429": "请求过于频繁，请稍后再试！".tr,
};

///返回的错误吗表示需要退出登录
final quitCodeSet = {
  ///账号被封禁
  903,

  ///token授权错误
  1042,

  ///授权超时
  1043,
};

class RequestArgumentError implements Exception {
  final int code;
  final String? url;
  final String? message;

  RequestArgumentError(this.code, {this.message = '', this.url});

  @override
  String toString() {
    return "network error: $url $code";
  }
}
