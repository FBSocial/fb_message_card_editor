// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FbResponse _$FbResponseFromJson(Map<String, dynamic> json) => FbResponse(
      json['status'] as bool,
      // FIXME 账号已注销登入会返回 string 类型，暂做兼容，重新生成代码将会覆盖
      json['code'] is int ? json['code'] as int : int.parse(json['code']),
      json['message'] as String,
      json['desc'] as String,
      json['data'],
    );

Map<String, dynamic> _$FbResponseToJson(FbResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'desc': instance.desc,
      'code': instance.code,
      'data': instance.data,
    };
