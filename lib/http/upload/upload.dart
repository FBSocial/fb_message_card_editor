import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:fb_message_card_editor/http/http_utils.dart';
import 'package:fb_message_card_editor/http/upload/cos_auth.dart';
import 'package:fb_message_card_editor/http/upload/upload_api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as get_x;



import 'package:lib_utils/config/sp_service.dart';
import 'package:lib_utils/loggers.dart';

import 'package:path/path.dart' as p;

Dio _dio = Dio();

CosAuth? _cosAuth;

// 获取 cos auth
// 优先从内存中获取，其次从本地储存中获取，最后从网络获取
Future<CosAuth?> getCosAuth({bool fromNet = false}) async {
  if (fromNet) {
    await _getCosAuthFromServer();
    return _cosAuth;
  }
  if (_cosAuth == null || !_cosAuth!.checkAuthIsAvailable()) {
    final local = SpService.instance.getString(SP.cosAuth);
    if (local != null) {
      _cosAuth = CosAuth.fromJson(json.decode(local));
      if (!_cosAuth!.checkAuthIsAvailable()) {
        await _getCosAuthFromServer();
      }
    } else {
      await _getCosAuthFromServer();
    }
  }
  return _cosAuth;
}

Future<void> _getCosAuthFromServer() async {
  try {
    final res = await UploadApi.uploadToken();
    _cosAuth = CosAuth.fromJson(res);
    await SpService.instance
        .setString(SP.cosAuth, jsonEncode(_cosAuth!.toJson()));
  } catch (e) {
    final bool isNetworkError = Http.isNetworkError(e);
    EasyLoading.showToast(isNetworkError ? networkErrorText : '文件上传失败'.tr);
  }
}

Future<String?> uploadHeadFile(File file, {ProgressCallback? onSendProgress}) {
  return uploadFileIfNotExist(
    bytes: file.readAsBytesSync().buffer.asUint8List(),
    fileType: "headImage",
    onSendProgress: onSendProgress,
  );
}

/// 上传一个文件，文件名字以 [hash] 命名。如果 CDN 上存在这个文件，则不会重复上传。
/// 如果传入了 [hash] 则会作为文件名，否则会根据 [bytes] 计算 [hash] 值。
// ignore: missing_return
Future<String?> uploadFileIfNotExist(
    {required Uint8List bytes,
    String? filename,
    String? hash,
    String fileType = "unknow",
    ProgressCallback? onSendProgress}) async {
  hash ??= md5.convert(bytes.buffer.asUint8List()).toString();

  final cosAuth = await getCosAuth();
  if (cosAuth == null) return null;
  final String extension =
      filename == null ? "" : p.extension(filename).toLowerCase();
  final key =
      "${fileType.contains("headImage") ? cosAuth.uploadPathService : cosAuth.uploadPath}$fileType/$hash$extension";
  final uploadUrl = "${getHost(cosAuth, fileType)}/$key";
  final downloadUrl = "${getCdnUrl(cosAuth, fileType)}/$key";

  try {
    // 如果 CDN 上已经有这个资源，不用再上传
    final result = await _dio.head(uploadUrl);
    if (result.statusCode == 200) return downloadUrl;
    throw Error();
  } catch (error) {
    ///如果视频审核不通过后，cdn会返回403，这里为了防止进入死循环，加了视频类型的[fileType]的判断
    if (error is DioError &&
        error.response?.statusCode == HttpStatus.forbidden) {
      if (fileType == UploadType.video) return downloadUrl;
      // 如果 cos 信息超时，重新获取最新的认证信息
      await _getCosAuthFromServer();
      return uploadFileIfNotExist(
          bytes: bytes,
          filename: filename,
          hash: hash,
          fileType: fileType,
          onSendProgress: onSendProgress);
    } else {
      try {
        // 文件不存在，继续上传。
        final res = await _dio.post(getHost(cosAuth, fileType)!,
            data: formData(key, cosAuth, bytes, filename, fileType));
        if (res.statusCode == 200) {
          return downloadUrl;
        } else {
          logger.info("uploadFileIfNotExist ${res.statusMessage}");
          throw "上传文件失败%s-%s"
              .trArgs([res.statusCode.toString(), res.statusMessage!]);
        }
        // final data = {
        //   "key": key,
        //   "success_action_status": '200',
        //   "Signature": cosAuth.authorization,
        //   "x-cos-security-token": cosAuth.token,
        //   "file": bytes.buffer.toString(),
        // };
      } catch (error) {
        // 如果 cos 信息超时，重新获取最新的认证信息
        if (error is DioError && error.response?.statusCode == 403) {
          await _getCosAuthFromServer();
          return uploadFileIfNotExist(
              bytes: bytes,
              filename: filename,
              hash: hash,
              fileType: fileType,
              onSendProgress: onSendProgress);
        }
        rethrow;
      }
    }
  }
}

FormData formData(String key, CosAuth cosAuth, Uint8List bytes,
    String? filename, String type) {
  if (type == UploadType.video)
    return FormData.fromMap({
      "key": key,
      "success_action_status": 200,
      "Signature": cosAuth.auditAuthorization,
      "x-cos-security-token": cosAuth.auditToken,
      "file": MultipartFile.fromBytes(bytes, filename: filename),
    });
  else
    return FormData.fromMap({
      "key": key,
      "success_action_status": 200,
      "Signature": cosAuth.authorization,
      "x-cos-security-token": cosAuth.token,
      "file": MultipartFile.fromBytes(bytes, filename: filename),
    });
}

String? getHost(CosAuth cosAuth, String type) {
  if (type == UploadType.video)
    return cosAuth.auditHost;
  else
    return cosAuth.host;
}

String? getCdnUrl(CosAuth cosAuth, String type) {
  if (type == UploadType.video)
    return cosAuth.auditUrl;
  else
    return cosAuth.cdnUrl;
}

class UploadType {
  static String video = 'video';
  static String live = 'live';
  static String image = 'image';
  static String audio = 'audio';
  static String unKnow = 'unknow';
}
