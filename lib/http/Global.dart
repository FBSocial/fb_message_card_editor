import 'dart:convert';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_card/ast/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lib_net/src/api/user_api.dart' as user;
import 'package:json_annotation/json_annotation.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/config/sp_service.dart';
import 'package:lib_utils/universal_platform.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

const platform = MethodChannel('buff.com/social');

/// 全局数据存储
class Global {
  /// 用户信息
  static LocalUser user = LocalUser();
  static String logoUrl =
      "https://xms-dev-1251001060.cos.ap-guangzhou.myqcloud.com/x-project/user-upload-files/7eb34fc0fe22d5829dc0777357475cf6.jpg";

  /// 版本信息
  static PackageInfo? packageInfo;

  static String iPhone13ProMax = "iPhone14,2";
  static String iPhone13Pro = "iPhone14,3";

  static DeviceInfo? deviceInfo;

  /// 保存设备id的Key
  static const saveDeviceIdKey = "fb_device_id";

  static int androidSdkInt = -1;

  static Future<void> getAndroidSdkInt() async {
    androidSdkInt = await platform.invokeMethod("getSdkInt") ?? -1;
  }

  /// 判断android id是否为有效值
  static bool _isValidAndroidId(String? androidId) {
    if (androidId == null || androidId.isEmpty) return false;
    final parseRet = int.tryParse(androidId);
    return parseRet == null || parseRet != 0;
  }

  /// 如果是华为，或者 荣耀 手机
  static bool isHuaweiOrHonor() {
    if (Global.deviceInfo == null) {
      return false;
    }
    return 'honor' == Global.deviceInfo?.brand?.toLowerCase() ||
        'huawei' == Global.deviceInfo?.brand?.toLowerCase();
  }

  /// 单独拿出来的原因是抽离androidId获取时机，其它平台没必要，影响最小化
  static Future<void> getAndroidDeviceInfo() async {
    deviceInfo ??= DeviceInfo();

    if (!UniversalPlatform.isAndroid) return;
    // 从androidInfo设置到deviceInfo中任意一个属性为空，就证明android平台还没获取设备信息
    if (deviceInfo!.systemVersion != null &&
        deviceInfo!.systemVersion!.isNotEmpty) return;

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    final androidInfo = await deviceInfoPlugin.androidInfo;
    deviceInfo!.systemVersion = androidInfo.version.release;
    deviceInfo!.sdkInt = androidInfo.version.sdkInt;
    deviceInfo!.brand = androidInfo.brand;
    deviceInfo!.model = androidInfo.model;

    // 先从缓存里面取值判断是否有效
    // 1. 有效则无需再缓存，直接给全局内存deviceInfo赋值
    // 1. 无效则通过deviceInfo插件获取原生的ANDROID_ID值
    // 若插件获取到的值依然无效，则使用fb_前缀+uuid的方式生成一个，并缓存
    const storage = FlutterSecureStorage();
    final cachedDeviceId = await storage.read(key: saveDeviceIdKey);
    if (!_isValidAndroidId(cachedDeviceId)) {
      /// NOTE(jp@jin.dev): 2022/8/12 此处获取AndroidId可能存在合规问题
      const _androidIdPlugin = AndroidId();
      final String? androidId =
          await _androidIdPlugin.getId() ?? deviceInfo?.identifier;
      if (_isValidAndroidId(androidId)) {
        deviceInfo!.identifier = androidId;
      } else {
        deviceInfo!.identifier = 'fb_${const Uuid().v4()}';
      }
      await storage.write(key: saveDeviceIdKey, value: deviceInfo!.identifier);
    } else {
      deviceInfo!.identifier = cachedDeviceId;
    }

    if (deviceInfo!.channel.noValue) {
      deviceInfo!.channel =
          await platform.invokeMethod('getChannelValue') ?? 'android';
      Config.channel = deviceInfo!.channel;
    }
  }

  ///这里将该方法公有化，用于给外部确认，[deviceInfo]是否初始化完成
  static Future<void> getDeviceInfo() async {
    deviceInfo ??= DeviceInfo();

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    // Create storage
    const storage = FlutterSecureStorage();

    /// 获取缓存的设备Id
    String? deviceId = '';

    /// 因为FlutterSecureStorage目前只支持 移动平台和linux,所以此处要做兼容,否则会报错
    if (UniversalPlatform.isMobileDevice || UniversalPlatform.isLinux) {
      deviceId = await storage.read(key: saveDeviceIdKey);
    }

    if (UniversalPlatform.isIOS) {
      deviceInfo!.channel = 'ios';
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo!.systemName = iosInfo.systemName;
      deviceInfo!.systemVersion = iosInfo.systemVersion;
      deviceInfo!.brand = iosInfo.model;
      deviceInfo!.model = iosInfo.utsname.machine;
      if (deviceId == null || deviceId.isEmpty) {
        final identifierForVendor = iosInfo.identifierForVendor;
        if (identifierForVendor != null || identifierForVendor!.isNotEmpty) {
          deviceInfo!.identifier = iosInfo.identifierForVendor;
        }
      }
    } else if (UniversalPlatform.isAndroid) {
      // !!! androidInfo的获取过程中会获取androidId，这个触及敏感权限
      // !!! 所以android平台的deviceInfo凡是从androidInfo获取的都先不设置
      // !!! 上面两个值暂不需要androidInfo填充
      // !!! 获取时机查看［getAndroidDeviceInfo］方法的调用时机
      //
      // final androidInfo = await deviceInfoPlugin.androidInfo;
      // deviceInfo.systemVersion = androidInfo.version.release;
      // deviceInfo.sdkInt = androidInfo.version.sdkInt;
      // deviceInfo.brand = androidInfo.brand;
      // deviceInfo.model = androidInfo.model;
      // if (deviceId == null || deviceId.isEmpty) {
      //   final androidId = androidInfo.androidId;
      //   if (androidId != null || androidId.isNotEmpty) {
      //     deviceInfo.identifier = androidId;
      //   }
      // }

      deviceInfo!.systemName = "android";
      deviceInfo!.channel =
          await platform.invokeMethod('getChannelValue') ?? 'android';
    } else if (UniversalPlatform.isWeb) {
      /// 如果是给对外的独立圈子,给特定的渠道号
      deviceInfo!.channel = 'web';
    } else if (UniversalPlatform.isWindows) {
      deviceInfo!.channel = 'windows';
    } else if (UniversalPlatform.isMacOS) {
      deviceInfo!.channel = 'mac';
    } else if (UniversalPlatform.isLinux) {
      deviceInfo!.channel = 'linux';
    } else if (UniversalPlatform.isFuchsia) {
      deviceInfo!.channel = 'fuchsia';
    }

    Config.channel = deviceInfo!.channel;

    /// 如果缓存中的设备ID为空,那么就保存设备ID
    if (deviceId == null || deviceId.isEmpty) {
      if (!UniversalPlatform.isAndroid) {
        try {
          await storage.write(
              key: saveDeviceIdKey, value: deviceInfo!.identifier);
        } catch (e) {
          print(e);
        }
      }
    } else {
      deviceInfo!.identifier = deviceId;
    }

    if (UniversalPlatform.isMobileDevice) {
      // deviceInfo!.thumbDir = await MultiImagePicker.requestThumbDirectory();
      // deviceInfo!.mediaDir = await MediaPicker.userDataCachePath();
    }
  }
}

class DeviceInfo {
  String? systemName = "Web";
  String? systemVersion = "";
  int? sdkInt = -1; // only for android
  String? identifier = 'fb_${const Uuid().v4()}';
  String? thumbDir = "";
  String? mediaDir = "";
  String channel = "";
  String? brand = "";
  String? model = "";
}

@JsonSerializable()
class LocalUser extends ChangeNotifier {
  // TODO 这些字段不应该有这么多默认值
  @JsonKey(name: "user_id")
  String id = "";
  String nickname = "";
  String username = "";
  String avatar = "";
  String avatarNft = "";
  String avatarNftId = "";
  String token = "";
  String mobile = "";
  int? gender = 0;

  /// 备注名相关内容
  ///
  Map toJson() {
    return {
      'user_id': id,
      'nickname': nickname,
      'username': username,
      'sign': token,
      'mobile': mobile,
      'avatar': avatar,
      'gender': gender
    };
  }
  static LocalUser fromUserInfo(Map res) {
    return LocalUser()
      ..id = res['user_id'] ?? ''
      ..nickname = res['nickname'] ?? ''
      ..username = res['username'] ?? ''
      ..avatar = res['avatar'] ?? ''
      ..token = res['sign']!
      ..mobile = ascii.decode(base64.decode(res['encryption_mobile']??''))
      ..gender = res['gender'];
  }

  //
  static LocalUser fromUserInfoRes(user.UserLoginRes res) {
    return LocalUser()
      ..id = res.userId ?? ''
      ..nickname = res.nickname ?? ''
      ..username = res.username ?? ''
      ..avatar = res.avatar ?? ''
      ..token = res.sign!
      ..mobile = ascii.decode(base64.decode(res.encryptionMobile!))
      ..gender = res.gender;
  }

  // static LocalUser fromJson(Map json) =>
  //     _$LocalUserFromJson(json as Map<String, dynamic>);

  /// - 当设置了avatar后，avatarNft和avatarNftId都设置为空
  Future<void> update({
    String? id,
    String? nickname,
    String? username,
    String? avatar,
    String? avatarNft,
    String? avatarNftId,
    String? token,
    String? desc,
    String? mobile,
    int? gender,
  }) async {
    if (id != null) this.id = id;
    if (nickname != null) this.nickname = nickname;
    if (username != null) this.username = username;
    if (avatar != null) this.avatar = avatar;
    if (avatarNft != null) this.avatarNft = avatarNft;
    if (avatarNftId != null) this.avatarNftId = avatarNftId;
    if (token != null) this.token = token;
    if (mobile != null) this.mobile = mobile;
    if (gender != null) this.gender = gender;

    cache();
    notifyListeners();
  }

  void cache() {
    final copy = toJson();
    final content = utf8.encode(mobile);
    copy['encryption_mobile'] = base64Encode(content);
    if (copy.containsKey("mobile")) copy.remove("mobile");
    final cahce = json.encode(copy);
    SpService.instance.setString(SP.userInfoSharedKey, cahce);
  }

  /// 从缓存中读取用户信息
  Future<void> read() async {
    final jsonStr = SpService.instance.getString(SP.userInfoSharedKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      final userInfo = json.decode(jsonStr);
      Global.user = fromUserInfo(userInfo);
    }
  }
}
