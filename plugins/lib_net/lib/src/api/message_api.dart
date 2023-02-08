import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../lib_net.dart';

part 'message_api.g.dart';

/////////////////////////////////////////////////////////////////////////
// notPull http版本
// http://yapi.ids111.com/project/10/interface/api/9638
/////////////////////////////////////////////////////////////////////////

@JsonSerializable(fieldRename: FieldRename.snake)
class PullMessageReq {
  final Map<String, String?> channels;
  final String t;
  final int? pullTime;

  const PullMessageReq({
    required this.channels,
    required this.t,
    this.pullTime,
  });

  factory PullMessageReq.fromJson(Map<String, dynamic> json) =>
      _$PullMessageReqFromJson(json);

  Map<String, dynamic> toJson() => _$PullMessageReqToJson(this);
}

class MessageApi {
  static Future<Exception?> pullMessages({
    required PullMessageReq data,
    Function(String)? onSuccess,
    Function(int errCrode, String errMsg)? onFail,
    Options? options,
  }) =>
      Http.post(
        "/api/pullMsg/pull",
        data: data,
        options: options,
        cancelToken: CancelToken(),
        onSuccess: (data) {
          if (onSuccess != null) {
            onSuccess(data);
          }
        },
        onFail: onFail,
      );
}
