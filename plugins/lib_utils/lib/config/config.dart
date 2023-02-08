import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lib_net/lib_net.dart' as net;
import 'package:lib_utils/loggers.dart';

import 'sp_service.dart';

enum Env {
  dev,
  dev2, //开发环境2 原测试环境
  pre,
  pro,
  sandbox,
  newtest,
}

/// 配置类
class Config {
  static bool useHttps = true;

  static String get httpScheme => useHttps ? 'https' : 'http';

  static const _hosts = {
    Env.dev: "a1-dev.fanbook.mobi", // 开发环境
    Env.dev2: "a1-test.fanbook.mobi", // 开发环境2
    Env.newtest: "a1-newtest.fanbook.mobi", // 测试环境
    Env.sandbox: "a1-fat.fanbook.mobi", // 测试环境
    Env.pre: "a1-pre.fanbook.mobi", // 预发布环境
    Env.pro: "a1.fanbook.mobi", // 正式环境
  };
  static const _wsUri = {
    Env.dev: "gateway-dev.fanbook.mobi", // 开发环境
    Env.dev2: "gateway-test.fanbook.mobi", // 开发环境
    Env.newtest: "gateway-newtest.fanbook.mobi", // 测试环境
    Env.sandbox: "gateway-fat.fanbook.mobi", // 测试环境
    Env.pre: "gateway-pre.fanbook.mobi", // 预发布环境
    Env.pro: "gateway.fanbook.mobi", // 正式环境
  };
  static const _memberListHosts = {
    Env.pro: "m1.fanbook.mobi",
    Env.pre: "m1.fanbook.mobi",
    Env.sandbox: "m1-fat.fanbook.mobi",
    Env.dev2: "a1-test.fanbook.mobi",
    Env.newtest: "m1-newtest.fanbook.mobi",
    Env.dev: "a1-dev.fanbook.mobi",
  };

  static const _miniProgramHosts = {
    Env.pro: "open.fanbook.mobi",
    Env.pre: "open.fanbook.mobi",
    Env.sandbox: "server-apply-fat.fanbook.mobi",
    Env.dev2: "server-apply-test.fanbook.mobi",
    Env.newtest: "open-newtest.fanbook.mobi",
    Env.dev: "server-apply-test.fanbook.mobi",
  };

  static const _mallHosts = {
    Env.dev: "mall-dev1.fanbook.mobi", // 开发环境
    Env.dev2: "mall-dev2.fanbook.mobi", // 开发环境2
    Env.newtest: "mall-newtest.fanbook.mobi", // 测试环境
    Env.sandbox: "mall-fat.fanbook.mobi", // 测试环境
    Env.pre: "mall-pre.fanbook.mobi", // 预发布环境
    Env.pro: "mall.fanbook.mobi", // 正式环境
  };

  static String? get wsUri => _wsUri[env];

  /// 当前服务器环境
  static Env env = Env.pro;

  static bool autoLogin = false;

  /// 渠道
  static String channel = "ios";

  /// 用户token
  static String? _token = "";

  /// 用户归属地
  static String geoRegion = '';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// 媒体信息
  static MediaQueryData? mediaInfo;

  /// 专属邀请码不识别path列表
  static List<String> exclusiveLinkExcludeList = [];

  static set token(String? v) {
    // Http.dio.options.headers[HttpHeaders.authorizationHeader] = v;
    logger.info("Token: $v");
    _token = v;

    ///设置新net库的token
    net.Http.tokenManger.token = v;
  }

  ///取消绑定，清除账号
  static void clearToken() {
    _token = "";
    SpService.instance.setString(SP.token, "");
  }

  static String webUUid = "";

  static const String _appKey = "HkFMtgKxPX0RvwnrYb8O";

  static String get appKey => _appKey;

  static const String _appSecret = "PvDPw9970JZtdY0H0nR0";

  static String get appSecret => _appSecret;

  static String? get token => _token;

  /// 服务器地址
  static String get host =>
      "${useHttps ? "https" : "http"}://${customHost ?? _hosts[env]}";

  static String get memberListUri =>
      "${useHttps ? "https" : "http"}://${_memberListHosts[env]}";

  static String? get host2 => _hosts[env];

  static String? getHostEnv(env) => _hosts[env];
  static String? customHost;

  // 审核开关host非线上版本都使用test接口
  static String get auditHost =>
      "https://${kDebugMode ? _hosts[Env.newtest] : _hosts[Env.pro]}";

  /// 小程序页面主机链接
  static String get miniProgramHost => "https://${_miniProgramHosts[env]}";

  /// 商城地址
  static String get mallHost =>
      "${useHttps ? "https" : "http"}://${_mallHosts[env]}";

  /// 是否是调试模式，调试模式会打印一些日志，release模式下，isDebug会自动改为false
  static bool isDebug = false;

  /// 日志搜集服务器地址
  static String logHost =
      "https://ccbdfe97d2b7469f9cbce30c0906074d@106.52.247.238:9000/3";

  /// appId
  static String appId = "wx5a6ce7e89c14128d";

  /// 白名单 {video: false, guild: false, channel: false} ， 退出登录得清除
  static Map? permission;

  /// ios universalLink
  /// https://fanbook.idreamsky.com/
  // static String universalLink = "https://huaming.idreamsky.com/app/";
  static String universalLink = "https://fanbook.idreamsky.com/app/";

  static String webLinkPrefix = 'https://fanbook.mobi/';

  /// 直播模块使用的appId
  static int liveAppId = 4216177565;

  /// 直播模块使用的app签名
  static String liveAppSign =
      "a4e3860318ed03b757793c9482cdda4f5c6836dd9086a19460ef6bd2e84a550c";

  /// 有赞商城个人中心
  static String storeUrl =
      'https://shop99800212.youzan.com/wscuser/membercenter?kdt_id=99608044&reft=1636701529835&spm=f.94850414';

  /// 邀请链接正则
  static RegExp inviteCodePattern = RegExp(r"^[A-Za-z\d]{8}$");

  static final Map<Env, String> _liveHosts = {
    Env.pro: "https://live.fanbook.mobi",
    Env.pre: "https://live.fanbook.mobi",
    Env.sandbox: "https://live-fat.fanbook.mobi",
    Env.dev2: "https://live-test.fanbook.mobi",
    Env.newtest: "https://live-newtest.fanbook.mobi",
    Env.dev: "https://r1-dev.fanook.mobi",
  };

  static final Map<Env, String> _liveWebWSS = {
    Env.pro: "wss://webliveroom4216177565-api.zego.im/ws",
    Env.pre: "wss://webliveroom4216177565-api.zego.im/ws",
    Env.dev2: "wss://webliveroom-test.zego.im/ws",
    Env.newtest: "wss://webliveroom-test.zego.im/ws",
    Env.dev: "wss://webliveroom-test.zego.im/ws",
  };

  /// 直播模块的api请求地址
  static String? liveHost = _liveHosts[env];

  /// 直播分享host，目前开发环境用的sandbox的
  static final Map<Env, String> _liveShareHosts = {
    Env.pro: "fanbook.mobi",
    Env.pre: "fanbook.mobi",
    Env.sandbox: "sandbox-web.fanbook.mobi",
    Env.dev2: "sandbox-web.fanbook.mobi",
    Env.newtest: "newtest.fanbook.mobi",
    Env.dev: "r1-dev.fanook.mobi",
  };

  /// 直播分享url
  static String liveShareUrl = "$httpScheme://${_liveShareHosts[env]}/live";

  static String liveShareUrlPrefix = "${_liveShareHosts[env]}/live";

  /// 直播web socket地址
  static String? liveWssUrl = _liveWebWSS[env];

  static final Map<Env, String> _liveObsDetailsHosts = {
    Env.pro: "fanbook.mobi",
    Env.pre: "fanbook.mobi",
    Env.sandbox: "newtest.fanbook.mobi",
    Env.dev2: "test.fanbook.mobi",
    Env.newtest: "newtest.fanbook.mobi",
    Env.dev: "test.fanbook.mobi",
  };

  /// 直播obs查看详情地址
  static String obsExplainUrl =
      "$httpScheme://${_liveObsDetailsHosts[env]}/live/explain";

  /// 圈子分享的url
  static String circleShareUrl =
      "$httpScheme://${h5CircleLinkHosts[env]}/circle/";

  /// 发消息是否使用http
  static bool useHttpSendMsg = false;

  /// 各种协议的h5页面host地址
  static final Map<Env, String> _protocolHosts = {
    Env.pro: "fanbook.idreamsky.com",
    Env.pre: "fanbook-pre.fanbook.mobi",
    Env.sandbox: "fanbook-fat.fanbook.mobi",
    Env.dev2: "fanbook-test.fanbook.mobi",
    Env.newtest: "fanbook-newtest.fanbook.mobi",
    Env.dev: "fanbook-dev.fanbook.mobi",
  };

  static String? protocolHost = _protocolHosts[env];

  static String webDomain = 'fanbook.mobi';

  /// 输入框根据平台使用配置
  ///
  /// android版本需要>=android 10(api level 29)
  static bool get useNativeInput {
    return false;
  }

  // || UniversalPlatform.isAndroidAboveLevel(29);

  /// 直播屏幕共享配置-iOS
  static const String appGroupID = "group.com.idreamsky.buff";
  static const String extensionName = "screenshare";
  static const String broadcastNotificationName =
      "ZGFinishReplayKitBroadcastNotificationName";

  static const h5CircleLinkHosts = {
    Env.pro: "fanbook.mobi",
    Env.pre: "pre.fanbook.mobi",
    Env.sandbox: "fat.fanbook.mobi",
    Env.dev2: "test.fanbook.mobi",
    Env.newtest: "newtest.fanbook.mobi",
    Env.dev: "test.fanbook.mobi",
  };

  static const tcDocHosts = {
    Env.pro: "fanbook.mobi/",
    Env.pre: "pre.fanbook.mobi",
    Env.sandbox: "fat.fanbook.mobi",
    Env.dev2: "test.fanbook.mobi",
    Env.newtest: "newtest.fanbook.mobi",
    Env.dev: "test.fanbook.mobi",
  };

  /// 新成员验证地址
  static String? newMemberValidationUrl = _newMemberValidationHosts[env];

  static const _newMemberValidationHosts = {
    Env.dev: "http://192.168.104.85:3608/home?fb_redirect&open_type=mp&debug",
    // 开发环境
    Env.dev2: "http://192.168.104.85:3608/home?fb_redirect&open_type=mp&debug",
    // 开发环境2
    Env.newtest:
        "https://open-newtest.fanbook.mobi/mp/138519745866498048/368318954306932736/home?fb_redirect&open_type=mp&debug",
    // 测试环境
    Env.sandbox:
        "https://open-fat.fanbook.mobi/mp/138519745866498048/368318954306932736/home?fb_redirect&open_type=mp",
    // 沙盒环境
    Env.pre:
        "https://open.fanbook.mobi/mp/138519745866498048/368318954306932736/home?fb_redirect&open_type=mp",
    // 预发布环境
    Env.pro:
        "https://open.fanbook.mobi/mp/138519745866498048/368318954306932736/home?fb_redirect&open_type=mp",
    // 正式环境
  };

  ///新邀请链接域名
  static const _newWebLinkHosts = {
    Env.pro: "https://in.fanbook.cn/",
    Env.pre: "https://in-pre.fanbook.mobi/",
    Env.sandbox: "https://in-fat.fanbook.mobi/",
    Env.newtest: "https://in-newtest.fanbook.mobi/",
    Env.dev: "https://in-test.fanbook.mobi/",
    Env.dev2: "https://in-test.fanbook.mobi/",
  };

  static String newWebLinkPrefix = _newWebLinkHosts[env] ?? "";

  static Future<void> initEnv() async {
    // 提前获取环境，之前Engine/init/env有点滞后
    final savedEnvVar = SpService.instance.getInt(SP.networkEnvSharedKey);
    if (savedEnvVar != null) {
      Config.env = Env.values[savedEnvVar];
    } else if (Config.isDebug) {
      Config.env = Env.newtest;
    }
  }

  /// * CDN路径中webp格式
  static String get webpPath => '/format/webp';
}
