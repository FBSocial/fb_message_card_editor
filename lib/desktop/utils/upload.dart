// import 'dart:async';
// import 'dart:convert';
// // import 'dart:html' as html;
// import 'dart:typed_data';
//
// import 'package:crypto/crypto.dart';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import 'package:path/path.dart' as p;
//
// CosAuth _cosAuth;
//
// class UploadType {
//   static String video = 'video';
//   static String live = 'live';
//   static String image = 'image';
//   static String audio = 'audio';
//   static String unKnow = 'unknow';
// }
//
// // 获取 cos auth
// // 优先从内存中获取，其次从本地储存中获取，最后从网络获取
// Future<CosAuth> getCosAuth({bool fromNet = false}) async {
//   if (fromNet) {
//     await _getCosAuthFromServer();
//     return _cosAuth;
//   }
//   if (_cosAuth == null || !_cosAuth.checkAuthIsAvailable()) {
//     final local = SpService.to.getString(SP.cosAuth);
//     if (local != null) {
//       _cosAuth = CosAuth.fromJson(json.decode(local));
//       if (!_cosAuth.checkAuthIsAvailable()) {
//         await _getCosAuthFromServer();
//       }
//     } else {
//       await _getCosAuthFromServer();
//     }
//   }
//   return _cosAuth;
// }
//
// Future<void> _getCosAuthFromServer() async {
//   try {
//     final res = await UploadApi.uploadToken();
//     _cosAuth = CosAuth.fromJson(res);
//     await SpService.to.setString(SP.cosAuth, jsonEncode(_cosAuth.toJson()));
//   } catch (e) {
//     final bool isNetworkError = Http.isNetworkError(e);
//     showToast(isNetworkError ? networkErrorText : '文件上传失败'.tr);
//   }
// }
//
// /// 上传一个文件，文件名字以 [hash] 命名。如果 CDN 上存在这个文件，则不会重复上传。
// /// 如果传入了 [hash] 则会作为文件名，否则会根据 [bytes] 计算 [hash] 值。
// /// 由于web端数组限制，bytes构造file会报错  Failed to construct 'File': Array length exceeds supported limit，无法获取file时可传bytes
// // ignore: missing_return
// Future<String> uploadFileIfNotExist(
//     // ignore: type_annotate_public_apis
//     {file,
//     Uint8List bytes,
//     String filename,
//     String hash,
//     String fileType = "unknow",
//     ProgressCallback onSendProgress,
//     int retryCount = 0}) async {
//   assert((file == null && bytes != null) || (file != null && bytes == null));
//
//   final unit8List = bytes ?? await webUtil.createUnit8ListFromFile(file);
//   hash ??= md5.convert(unit8List).toString();
//   final cosAuth = await getCosAuth();
//   if (cosAuth == null) return null;
//   final String extension =
//       filename == null ? "" : p.extension(filename).toLowerCase();
//   final key =
//       "${fileType.contains("headImage") ? cosAuth.uploadPathService : cosAuth.uploadPath}$fileType/$hash$extension";
//
//   final uploadUrl = "${getHost(cosAuth, fileType)}/$key";
//   final downloadUrl = "${getCdnUrl(cosAuth, fileType)}/$key";
//
//   // 如果 CDN 上已经有这个资源，不用再上传
//   final result = await http.head(Uri.parse(uploadUrl));
//   if (result.statusCode == 200) return downloadUrl;
//   // 文件不存在，继续上传。
//   final request =
//       http.MultipartRequest('POST', Uri.parse(getHost(cosAuth, fileType)));
//   request.fields['key'] = key;
//   request.fields['success_action_status'] = '200';
//   request.fields['Signature'] = getAuthorization(cosAuth, fileType);
//   request.fields['x-cos-security-token'] = getToken(cosAuth, fileType);
//   request.files.add(http.MultipartFile.fromBytes('file', unit8List.toList()));
//   final res = await request.send();
//   if (res.statusCode == 200) {
//     return downloadUrl;
//   } else if (res.statusCode == 403) {
//     if (retryCount >= 10) {
//       logger.info("上传文件失败${res.statusCode} ${res.reasonPhrase}");
//     } else {
//       await _getCosAuthFromServer();
//       return uploadFileIfNotExist(
//           file: file,
//           bytes: bytes,
//           filename: filename,
//           hash: hash,
//           fileType: fileType,
//           onSendProgress: onSendProgress,
//           retryCount: ++retryCount);
//     }
//   } else {
//     logger.info("上传文件失败${res.statusCode} ${res.reasonPhrase}");
//   }
// }
//
// String getHost(CosAuth cosAuth, String type) {
//   if (type == UploadType.video)
//     return cosAuth.auditHost;
//   else
//     return cosAuth.host;
// }
//
// String getCdnUrl(CosAuth cosAuth, String type) {
//   if (type == UploadType.video)
//     return cosAuth.auditUrl;
//   else
//     return cosAuth.cdnUrl;
// }
//
// String getAuthorization(CosAuth cosAuth, String type) {
//   if (type == UploadType.video)
//     return cosAuth.auditAuthorization;
//   else
//     return cosAuth.authorization;
// }
//
// String getToken(CosAuth cosAuth, String type) {
//   if (type == UploadType.video)
//     return cosAuth.auditToken;
//   else
//     return cosAuth.token;
// }
// // Future<String> _post(FormData data) {
// //   final Completer<String> completer = Completer<String>();
// //   final xhr = html.HttpRequest();
// //   final data = html.FormData();
// //   xhr.open('POST', cosAuth.host);
// //   xhr.onReadyStateChange.listen((e) async {
// //     if (xhr.readyState == html.HttpRequest.DONE) {
// //       if (xhr.status == 200) {
// //         completer.complete(downloadUrl);
// //       } else if (xhr.status == 403) {
// //         await _getCosAuthFromServer();
// //         return uploadFileIfNotExist(
// //             file: file,
// //             filename: filename,
// //             hash: hash,
// //             fileType: fileType,
// //             onSendProgress: onSendProgress);
// //       }
// //     }
// //   });
// //   xhr.send(data);
// //   return completer.future;
// // }
// //
// // Future<Response> _head(String url) {
// //   final Completer<Response> completer = Completer<Response>();
// //   final xhr = html.HttpRequest();
// //   xhr.open('POST', cosAuth.host);
// //   xhr.onReadyStateChange.listen((e) async {
// //     if (xhr.readyState == html.HttpRequest.DONE) {
// //       if (xhr.status == 200) {
// //         completer.complete(xhr.response);
// //       } else {
// //         throw Error();
// //       }
// //     }
// //   });
// //   xhr.send();
// //   return completer.future;
// // }
