// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PullMessageReq _$PullMessageReqFromJson(Map<String, dynamic> json) =>
    PullMessageReq(
      channels: Map<String, String?>.from(json['channels'] as Map),
      t: json['t'] as String,
      pullTime: json['pull_time'] as int?,
    );

Map<String, dynamic> _$PullMessageReqToJson(PullMessageReq instance) =>
    <String, dynamic>{
      'channels': instance.channels,
      't': instance.t,
      'pull_time': instance.pullTime,
    };
