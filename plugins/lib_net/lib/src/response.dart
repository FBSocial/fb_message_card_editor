import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class FbResponse {
  final bool status;

  final String message;
  final String desc;
  final int code;
  final Object? data;

  FbResponse(this.status, this.code, this.message, this.desc, this.data);

  factory FbResponse.fromJson(Map<String, dynamic> json) =>
      _$FbResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FbResponseToJson(this);
}
