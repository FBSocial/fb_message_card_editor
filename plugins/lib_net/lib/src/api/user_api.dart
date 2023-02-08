import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lib_net/src/http.dart';

part 'user_api.g.dart';

/////////////////////////////////////////////////////////////////////////
// 好友待定列表
// http://yapi.ids111.com/project/10/interface/api/1221
/////////////////////////////////////////////////////////////////////////

enum RelationType {
  @JsonValue(0)
  none,
  @JsonValue(1)
  friend,
  @JsonValue(2)
  blocked,
  @JsonValue(3)
  pendingIncoming,
  @JsonValue(4)
  pendingOutgoing,
  @JsonValue(99)
  unrelated,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RelationPendingListReq {
  final int page;
  final int? size;

  const RelationPendingListReq({
    this.page = 1,
    this.size = 1000,
  });

  factory RelationPendingListReq.fromJson(Map<String, dynamic> json) =>
      _$RelationPendingListReqFromJson(json);

  Map<String, dynamic> toJson() => _$RelationPendingListReqToJson(this);
}

// TODO 这个结构体有三个字段没有用到
@JsonSerializable(fieldRename: FieldRename.snake)
class FriendApply {
  final String userId;

  // final String username;
  // final String avatar;
  @JsonKey(name: "timestamp")
  final int time;

  // final String nickname;
  @JsonKey(defaultValue: RelationType.unrelated, name: "type")
  final RelationType relationType;

  const FriendApply({
    required this.userId,
    // required this.username,
    // required this.avatar,
    required this.time,
    // required this.nickname,
    required this.relationType,
  });

  factory FriendApply.fromJson(Map<String, dynamic> json) =>
      _$FriendApplyFromJson(json);

  Map<String, dynamic> toJson() => _$FriendApplyToJson(this);
}
/////////////////////////////////////////////////////////////////////////
// 修改用户信息
// http://yapi.ids111.com/project/10/interface/api/1122
/////////////////////////////////////////////////////////////////////////

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateUserInfoReq {
  final String userId;
  final String? nickname;
  final int? gender;
  final String? avatar;
  final String? avatarNftId;

  const UpdateUserInfoReq({
    required this.userId,
    this.nickname,
    this.gender,
    this.avatar,
    this.avatarNftId,
  });

  factory UpdateUserInfoReq.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoReqFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserInfoReqToJson(this);
}

/////////////////////////////////////////////////////////////////////////
// 手机/极光登陆/注册
// http://yapi.ids111.com/project/10/interface/api/924
/////////////////////////////////////////////////////////////////////////

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class UserLoginReq {
  final String type;
  final String? code;
  final String? device;
  @JsonKey(name: "loginToken")
  final String? loginToken;
  final String? mobile;
  final String? areaCode;
  final String? thirdParty;
  final String? transaction;
  final String? encryptType;

  const UserLoginReq({
    required this.type,
    this.code,
    this.device,
    this.loginToken,
    this.mobile,
    this.areaCode,
    this.thirdParty,
    this.transaction,
    this.encryptType,
  });

  factory UserLoginReq.fromJson(Map<String, dynamic> json) =>
      _$UserLoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginReqToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserLoginRes {
  final String? username;
  final bool? notice;
  final double? n;
  final String? mobile;
  final double? presenceStatus;
  final double? joinedAt;
  final String? nickname;
  final String? userId;
  final String? encryptionMobile;
  final int? gender;
  final String? sign;
  final dynamic email;
  final BindedData? bindedData;
  final PreData? preData;
  final String? avatar;
  final String? discriminator;
  final int? areaCode;
  final String? thirdParty;

  const UserLoginRes({
    this.username,
    this.notice,
    required this.n,
    this.mobile,
    this.presenceStatus,
    this.joinedAt,
    required this.nickname,
    this.userId,
    this.encryptionMobile,
    this.gender,
    required this.sign,
    this.email,
    this.bindedData,
    this.preData,
    this.avatar,
    required this.discriminator,
    required this.areaCode,
    this.thirdParty,
  });

  factory UserLoginRes.fromJson(Map<String, dynamic> json) =>
      _$UserLoginResFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginResToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BindedData {
  final String? new_;
  final String? old;

  const BindedData({
    this.new_,
    this.old,
  });

  factory BindedData.fromJson(Map<String, dynamic> json) =>
      _$BindedDataFromJson(json);

  Map<String, dynamic> toJson() => _$BindedDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PreData {
  final String? avatar;
  final int? gender;
  final String? nickname;

  const PreData({
    this.avatar,
    this.gender,
    this.nickname,
  });

  factory PreData.fromJson(Map<String, dynamic> json) =>
      _$PreDataFromJson(json);

  Map<String, dynamic> toJson() => _$PreDataToJson(this);
}

/////////////////////////////////////////////////////////////////////////
// 微信登录
// http://yapi.ids111.com/project/10/interface/api/1086
/////////////////////////////////////////////////////////////////////////
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginWithWeChatReq {
  final String? type;
  final String code;

  const LoginWithWeChatReq({
    this.type,
    required this.code,
  });

  factory LoginWithWeChatReq.fromJson(Map<String, dynamic> json) =>
      _$LoginWithWeChatReqFromJson(json);

  Map<String, dynamic> toJson() => _$LoginWithWeChatReqToJson(this);
}
/////////////////////////////////////////////////////////////////////////
// 苹果登录
// http://yapi.ids111.com/project/10/interface/api/978
/////////////////////////////////////////////////////////////////////////

@JsonSerializable(includeIfNull: false)
class LoginWidthAppleReq {
  final String? identityToken;
  final String? familyName;
  final String? givenName;
  final String? email;
  final String? userIdentifier;
  final String authorizationCode;

  const LoginWidthAppleReq({
    required this.identityToken,
    this.familyName,
    this.givenName,
    this.email,
    required this.userIdentifier,
    required this.authorizationCode,
  });

  factory LoginWidthAppleReq.fromJson(Map<String, dynamic> json) =>
      _$LoginWidthAppleReqFromJson(json);

  Map<String, dynamic> toJson() => _$LoginWidthAppleReqToJson(this);
}

class UserApi {
  static Future<void> relationPendingList({
    required RelationPendingListReq data,
    Function(List<FriendApply>)? onSuccess,
    Function(int errCode, String errMsg)? onFail,
  }) =>
      Http.post(
        "/api/relation/pendingList",
        data: data,
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess(
                (data as List).map((e) => FriendApply.fromJson(e)).toList());
          }
        },
        onFail: onFail,
      );

  static Future<Exception?> updateUserInfo({
    required UpdateUserInfoReq data,
    Function()? onSuccess,
    Function(int errCrode, String errMsg)? onFail,
  }) =>
      Http.post(
        "/api/user/updateInfo",
        data: data,
        options: Options(extra: {Http.kOptionErrorToast: true}),
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess();
          }
        },
        onFail: onFail,
      );

  static Future<Exception?> userLogin({
    required UserLoginReq data,
    Function(UserLoginRes)? onSuccess,
    Function(int errCrode, String errMsg)? onFail,
  }) =>
      Http.post(
        "/api/user/login",
        data: data,
        options: Options(extra: {Http.kOptionErrorToast: true}),
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess(UserLoginRes.fromJson(data));
          }
        },
        onFail: onFail,
      );

  static Future<Exception?> loginWithWeChat({
    required LoginWithWeChatReq data,
    Function(UserLoginRes)? onSuccess,
    Function(int errCrode, String errMsg)? onFail,
  }) =>
      Http.post(
        "/api/user/loginwx",
        data: data,
        options: null,
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess(UserLoginRes.fromJson(data));
          }
        },
        onFail: onFail,
      );

  static Future<Exception?> loginWidthApple({
    required LoginWidthAppleReq data,
    Function(UserLoginRes)? onSuccess,
    Function(int errCrode, String errMsg)? onFail,
  }) =>
      Http.post(
        "/api/user/loginapple",
        data: data,
        options: null,
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess(UserLoginRes.fromJson(data));
          }
        },
        onFail: onFail,
      );
}
