import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lib_net/lib_net.dart';

import '../type_transformer.dart';

part 'common_api.g.dart';

/////////////////////////////////////////////////////////////////////////
// 获取支付宝口令正则
// http://yapi.ids111.com/project/10/interface/api/384
/////////////////////////////////////////////////////////////////////////
@JsonSerializable()
class PrerequisiteConfigRes {
  final Alipay? alipay;
  @JsonKey(name: "redbag")
  final RedPack? redPack;
  final bool? readHistory;
  @JsonKey(name: "ledou", fromJson: TypeTransformer.int2bool)
  final bool leBean;
  @JsonKey(name: "nft", fromJson: TypeTransformer.int2bool)
  final bool walletBean;
  @JsonKey(name: "welogin")
  final int? wechatLogin;
  @JsonKey(name: "applelogin")
  final int? appleLogin;
  @JsonKey(name: "notification")
  final BgNotification? notificationInfo;
  @JsonKey(name: "official_operation_bot_id")
  final String? officialOperationBotId;
  @JsonKey(name: "setting")
  final UrlCheckEntity? urlCheckEntity;

  PrerequisiteConfigRes(
      this.alipay,
      this.redPack,
      this.readHistory,
      this.leBean,
      this.walletBean,
      this.wechatLogin,
      this.appleLogin,
      this.notificationInfo,
      this.officialOperationBotId,
      this.urlCheckEntity); // 链接黑名单配置项

  factory PrerequisiteConfigRes.fromJson(Map<String, dynamic> json) =>
      _$PrerequisiteConfigResFromJson(json);

  Map<String, dynamic> toJson() => _$PrerequisiteConfigResToJson(this);
}

@JsonSerializable()
class UrlCheckEntity {
  @JsonKey(name: "risk_domain")
  final String? checkHost;
  @JsonKey(name: "risk_intercept_url")
  final String? checkInterceptUrl;
  @JsonKey(name: "risk_switch", fromJson: TypeTransformer.int2bool)
  final bool isEnable;

  const UrlCheckEntity({
    this.checkHost,
    this.checkInterceptUrl,
    this.isEnable = false,
  });

  factory UrlCheckEntity.defaultValue() {
    return UrlCheckEntity(
      checkHost: HttpConfig.defaultLinkCheckHost,
      checkInterceptUrl:
          "https://fb-cdn.fanbook.mobi/fanbook/app/link_ban.html",
      isEnable: true,
    );
  }

  factory UrlCheckEntity.fromJson(Map<String, dynamic> json) =>
      _$UrlCheckEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UrlCheckEntityToJson(this);
}

@immutable
@JsonSerializable()
class BgNotification {
  @JsonKey(name: "open")
  final bool enableNotDisturbBgNoti;

  @JsonKey()
  final int total;

  const BgNotification({this.enableNotDisturbBgNoti = true, this.total = 5});

  factory BgNotification.fromJson(Map<String, dynamic> json) =>
      _$BgNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$BgNotificationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Alipay {
  final String rule;
  final int maxLen;

  Alipay(this.rule, this.maxLen);

  factory Alipay.fromJson(Map<String, dynamic> json) => _$AlipayFromJson(json);

  Map<String, dynamic> toJson() => _$AlipayToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RedPack {
  final int singleMaxMoney; // 发送单个红包最大金额
  final int maxNum;
  final int period;

  RedPack(this.singleMaxMoney, this.maxNum, this.period);

  factory RedPack.fromJson(Map<String, dynamic> json) =>
      _$RedPackFromJson(json);

  Map<String, dynamic> toJson() => _$RedPackToJson(this);
}

class CommonApi {
  static Future<Exception?> prerequisiteConfig({
    Function(PrerequisiteConfigRes)? onSuccess,
    Function(int errCrode, String errMsg)? onFail,
  }) =>
      Http.post(
        "/api/common/alipay",
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess(PrerequisiteConfigRes.fromJson(data));
          }
        },
        onFail: onFail,
      );
}
