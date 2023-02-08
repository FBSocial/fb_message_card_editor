// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationPendingListReq _$RelationPendingListReqFromJson(
        Map<String, dynamic> json) =>
    RelationPendingListReq(
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 1000,
    );

Map<String, dynamic> _$RelationPendingListReqToJson(
        RelationPendingListReq instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
    };

FriendApply _$FriendApplyFromJson(Map<String, dynamic> json) => FriendApply(
      userId: json['user_id'] as String,
      time: json['timestamp'] as int,
      relationType: $enumDecodeNullable(_$RelationTypeEnumMap, json['type']) ??
          RelationType.unrelated,
    );

Map<String, dynamic> _$FriendApplyToJson(FriendApply instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'timestamp': instance.time,
      'type': _$RelationTypeEnumMap[instance.relationType]!,
    };

const _$RelationTypeEnumMap = {
  RelationType.none: 0,
  RelationType.friend: 1,
  RelationType.blocked: 2,
  RelationType.pendingIncoming: 3,
  RelationType.pendingOutgoing: 4,
  RelationType.unrelated: 99,
};

UpdateUserInfoReq _$UpdateUserInfoReqFromJson(Map<String, dynamic> json) =>
    UpdateUserInfoReq(
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String?,
      gender: json['gender'] as int?,
      avatar: json['avatar'] as String?,
      avatarNftId: json['avatar_nft_id'] as String?,
    );

Map<String, dynamic> _$UpdateUserInfoReqToJson(UpdateUserInfoReq instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'avatar': instance.avatar,
      'avatar_nft_id': instance.avatarNftId,
    };

UserLoginReq _$UserLoginReqFromJson(Map<String, dynamic> json) => UserLoginReq(
      type: json['type'] as String,
      code: json['code'] as String?,
      device: json['device'] as String?,
      loginToken: json['loginToken'] as String?,
      mobile: json['mobile'] as String?,
      areaCode: json['area_code'] as String?,
      thirdParty: json['third_party'] as String?,
      transaction: json['transaction'] as String?,
      encryptType: json['encrypt_type'] as String?,
    );

Map<String, dynamic> _$UserLoginReqToJson(UserLoginReq instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('device', instance.device);
  writeNotNull('loginToken', instance.loginToken);
  writeNotNull('mobile', instance.mobile);
  writeNotNull('area_code', instance.areaCode);
  writeNotNull('third_party', instance.thirdParty);
  writeNotNull('transaction', instance.transaction);
  writeNotNull('encrypt_type', instance.encryptType);
  return val;
}

UserLoginRes _$UserLoginResFromJson(Map<String, dynamic> json) => UserLoginRes(
      username: json['username'] as String?,
      notice: json['notice'] as bool?,
      n: (json['n'] as num?)?.toDouble(),
      mobile: json['mobile'] as String?,
      presenceStatus: (json['presence_status'] as num?)?.toDouble(),
      joinedAt: (json['joined_at'] as num?)?.toDouble(),
      nickname: json['nickname'] as String?,
      userId: json['user_id'] as String?,
      encryptionMobile: json['encryption_mobile'] as String?,
      gender: json['gender'] as int?,
      sign: json['sign'] as String?,
      email: json['email'],
      bindedData: json['binded_data'] == null
          ? null
          : BindedData.fromJson(json['binded_data'] as Map<String, dynamic>),
      preData: json['pre_data'] == null
          ? null
          : PreData.fromJson(json['pre_data'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
      discriminator: json['discriminator'] as String?,
      areaCode: json['area_code'] as int?,
      thirdParty: json['third_party'] as String?,
    );

Map<String, dynamic> _$UserLoginResToJson(UserLoginRes instance) =>
    <String, dynamic>{
      'username': instance.username,
      'notice': instance.notice,
      'n': instance.n,
      'mobile': instance.mobile,
      'presence_status': instance.presenceStatus,
      'joined_at': instance.joinedAt,
      'nickname': instance.nickname,
      'user_id': instance.userId,
      'encryption_mobile': instance.encryptionMobile,
      'gender': instance.gender,
      'sign': instance.sign,
      'email': instance.email,
      'binded_data': instance.bindedData,
      'pre_data': instance.preData,
      'avatar': instance.avatar,
      'discriminator': instance.discriminator,
      'area_code': instance.areaCode,
      'third_party': instance.thirdParty,
    };

BindedData _$BindedDataFromJson(Map<String, dynamic> json) => BindedData(
      new_: json['new_'] as String?,
      old: json['old'] as String?,
    );

Map<String, dynamic> _$BindedDataToJson(BindedData instance) =>
    <String, dynamic>{
      'new_': instance.new_,
      'old': instance.old,
    };

PreData _$PreDataFromJson(Map<String, dynamic> json) => PreData(
      avatar: json['avatar'] as String?,
      gender: json['gender'] as int?,
      nickname: json['nickname'] as String?,
    );

Map<String, dynamic> _$PreDataToJson(PreData instance) => <String, dynamic>{
      'avatar': instance.avatar,
      'gender': instance.gender,
      'nickname': instance.nickname,
    };

LoginWithWeChatReq _$LoginWithWeChatReqFromJson(Map<String, dynamic> json) =>
    LoginWithWeChatReq(
      type: json['type'] as String?,
      code: json['code'] as String,
    );

Map<String, dynamic> _$LoginWithWeChatReqToJson(LoginWithWeChatReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'code': instance.code,
    };

LoginWidthAppleReq _$LoginWidthAppleReqFromJson(Map<String, dynamic> json) =>
    LoginWidthAppleReq(
      identityToken: json['identityToken'] as String?,
      familyName: json['familyName'] as String?,
      givenName: json['givenName'] as String?,
      email: json['email'] as String?,
      userIdentifier: json['userIdentifier'] as String?,
      authorizationCode: json['authorizationCode'] as String,
    );

Map<String, dynamic> _$LoginWidthAppleReqToJson(LoginWidthAppleReq instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('identityToken', instance.identityToken);
  writeNotNull('familyName', instance.familyName);
  writeNotNull('givenName', instance.givenName);
  writeNotNull('email', instance.email);
  writeNotNull('userIdentifier', instance.userIdentifier);
  val['authorizationCode'] = instance.authorizationCode;
  return val;
}
