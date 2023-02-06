import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:fb_message_card_editor/desktop/utils/web_util/web_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher_string.dart';


class WebUtil implements WebUtilBase {
  @override
  void callJsMethod(String methodName, List params) {}

  // @override
  // void downloadFile(String url) {
  //   /// 使用浏览器下载，cdn上应该要做设置
  //   if (UniversalPlatform.isMacOS) {
  //     launchUrlString(url);
  //   } else if (UniversalPlatform.isWindows) {
  //     DesktopOpenFile.openUrl(url);
  //   }
  // }
  //
  // @override
  // // ignore: missing_return
  // String getHref() {}
  //
  // _LocalNotification _localNotification;
  //
  // @override
  // void initNotification() {
  //   _localNotification = _LocalNotification.createNotification();
  //   _localNotification?.initialize();
  // }
  //
  // @override
  // Future<void> pushLocalNotification(
  //     String title, String body, Map<String, String> extra) async {
  //   // 窗口在前台的情况下，当前选中的频道或者私信不推送
  //   // 窗口在后台或者托盘的情况下，显示推送
  //   final bool isWindowVisible = await _localNotification.isWindowVisible();
  //   final bool isCurrentOrDm = extra.containsKey("channel_id") &&
  //       (GlobalState.selectedChannel.value?.id == extra["channel_id"] ||
  //           TextChannelController.dmChannel?.id == extra["channel_id"]);
  //   final bool isShouldNotPush = isWindowVisible && isCurrentOrDm;
  //   if (isShouldNotPush) {
  //     return;
  //   }
  //   unawaited(_localNotification?.push(title, body, extra));
  // }

  @override
  void setBadge(int badge) {}

  // @override
  // // ignore: missing_return, type_annotate_public_apis
  // Future<String> createBlobUrlFromFile(file) {}
  //
  // @override
  // // ignore: type_annotate_public_apis, missing_return
  // Future<Uint8List> createUnit8ListFromFile(file) {}
  //
  // @override
  // // ignore: type_annotate_public_apis, missing_return
  // Future<Asset> getAssetInfo(file) {}
  //
  // @override
  // // ignore: type_annotate_public_apis, missing_return
  // Future<Asset> getImageInfo(file) {}
  //
  // @override
  // // ignore: type_annotate_public_apis, missing_return
  // Future<Asset> getVideoInfo(file) {}

  @override
  // ignore: type_annotate_public_apis, missing_return
  Future<Uint8List> compressImageFromElement(blobPath, {double quality = 0.6}) {
    return File(blobPath).readAsBytes();
  }

  @override
  void refreshHtml() {}

  @override
  void setCookie(
    String key,
    String value, {
    String? domain,
    String? path,
    bool secure =false,
    int expires = 0,
  }) {}

  @override
  String getCookie(String key) => '';

  @override
  void wakeUpApp(String postId, String topicId) {}

  // @override
  // // ignore: missing_return
  // String gzip(Uint8List bytes) {}
  //
  // Future<Asset> getAsstInfoByXFile(XFile file) async {
  //   if (file.mimeType == null) {
  //     return getFileInfoByXFile(file);
  //   }
  //
  //   if (file.mimeType.startsWith('image/')) {
  //     return getImageInfoByXFile(file);
  //   } else if (file.mimeType.startsWith('video/')) {
  //     return getVideoInfoByXFile(file);
  //   } else {
  //     return getFileInfoByXFile(file);
  //   }
  // }

  Future<Asset> getImageInfoByXFile(XFile file) async {
    final Completer<Asset> completer = Completer<Asset>();
    final image = Image.file(File(file.path));
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, _) {
          if (!completer.isCompleted) {
            completer.complete(Asset(
              null,
              file.path,
              file.name,
              info.image.width.toDouble(),
              info.image.height.toDouble(),
              file.mimeType,
            ));
          }
        }, onError: (exception, stackTrace) {
          completer.complete(null);
        }));
    return completer.future;
  }
  //
  // Future<Asset> getVideoInfoByXFile(XFile file) async {
  //   final controller = VideoPlayerControllerDesktop.file(file.path);
  //   await controller.initialize();
  //   final width = controller.width;
  //   final height = controller.height;
  //   final duration = controller.duration;
  //   final path = "${Directory.systemTemp.path}${Platform.pathSeparator}social";
  //   final dir = Directory(path);
  //   if (!dir.existsSync()) {
  //     await dir.create();
  //   }
  //   final snapshotName =
  //       "video_snapshot_${DateTime.now().millisecondsSinceEpoch}.jpg";
  //
  //   final snapshot = File("${dir.path}${Platform.pathSeparator}$snapshotName");
  //   controller.takeSnapshot(snapshot, width, height);
  //   await controller.dispose();
  //
  //   //调用dispose后似乎没有马上释放相关数据,此时如果新创建VideoPlayerControllerDesktop会导致初始化失败,所以await
  //   //该逻辑只适用于调用getVideoInfoByXFile,如果直接调用VideoPlayerControllerDesktop还是有可能造成相关问题
  //   await Future.delayed(const Duration(milliseconds: 10));
  //   return Future.value(Asset(null, file.path, file.name, width.toDouble(),
  //       height.toDouble(), file.mimeType,
  //       duration: duration.toDouble(),
  //       thumbName: snapshotName,
  //       thumbWidth: width.toDouble(),
  //       thumbHeight: height.toDouble(),
  //       thumbFilePath: snapshot.path));
  // }

  Future<Asset> getFileInfoByXFile(XFile file) {
    return Future.value(Asset(
      null,
      file.path,
      file.name,
      null,
      null,
      file.mimeType,
    ));
  }

  @override
  Future<String> createBlobUrlFromFile(file) {
    // TODO: implement createBlobUrlFromFile
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> createUnit8ListFromFile(file) {
    // TODO: implement createUnit8ListFromFile
    throw UnimplementedError();
  }

  @override
  void downloadFile(String url) {
    // TODO: implement downloadFile
  }

  @override
  Future<Asset> getAssetInfo(file) {
    // TODO: implement getAssetInfo
    throw UnimplementedError();
  }

  @override
  String getHref() {
    // TODO: implement getHref
    throw UnimplementedError();
  }

  @override
  Future<Asset> getImageInfo(file) {
    // TODO: implement getImageInfo
    throw UnimplementedError();
  }

  @override
  Future<Asset> getVideoInfo(file) {
    // TODO: implement getVideoInfo
    throw UnimplementedError();
  }

  @override
  String gzip(Uint8List bytes) {
    // TODO: implement gzip
    throw UnimplementedError();
  }

  @override
  void initNotification() {
    // TODO: implement initNotification
  }

  @override
  void pushLocalNotification(String title, String body, Map<String, String> extra) {
    // TODO: implement pushLocalNotification
  }
}

// abstract class _LocalNotification {
//   static _LocalNotification createNotification() {
//     if (Platform.isWindows) {
//       return _WindowsLocalNotification();
//     } else if (Platform.isMacOS) {
//       return _MacosLocalNotification();
//     }
//     return null;
//   }
//
//   /// 处理通知跳转
//   void _handlerNotification(Map extra) {
//     final String type = "${extra["type"]}";
//     if (type != null) {
//       switch (int.parse(type)) {
//         case JPushType.relationAdd:
//         case JPushType.relationCancel:
//           JPushUtil.gotoRelation();
//           break;
//         case JPushType.relationFriend:
//           final String userId = extra["user_id"];
//           if (userId != null) {
//             JPushUtil.gotoDmChannel(userId);
//           }
//           break;
//         case JPushType.channel:
//           if (extra["channel_id"] != null) {
//             JPushUtil.gotoChannel(
//               "${extra["channel_id"]}",
//               "${extra["message_id"]}",
//               "${extra["channel_type"] ?? ""}",
//               "${extra["user_id"]}",
//             );
//             WinToast.instance().remove(channelId: extra['channel_id']);
//             WebToolTipManager.instance.clear();
//           }
//           break;
//         case JPushType.circleComment:
//         // ignore: no_duplicate_case_values
//         case JPushType.circleLike:
//           var data = extra['data'];
//           if (data == null && extra['circleData'] != null) {
//             data = jsonDecode(extra['circleData']);
//           }
//           if (data == null) return;
//
//           try {
//             final Map<String, dynamic> circleData =
//                 data.cast<String, dynamic>();
//             final message = MessageEntity.fromJson(circleData);
//             final content = message.content as CirclePostNewsEntity;
//             final postId = content.postId;
//             final commentId = message.quoteL1.hasValue
//                 ? message.quoteL1
//                 : content.commentId?.toString();
//             final guildId = extra['guild_id'] ?? message.guildId;
//
//             final circleNewsChannelId = message.channelId;
//             logger.info(
//                 'getChat notification: guildId: $guildId, postId: $postId - $commentId - $circleNewsChannelId');
//             if (postId.noValue) return;
//
//             //圈子动态消息-直接跳转到详情页
//             final detailData = CircleDetailData(
//               null,
//               extraData: ExtraData(
//                   guildId: guildId,
//                   circleNewsChannelId: circleNewsChannelId,
//                   circleNewsMessageId: message.messageId,
//                   postId: postId,
//                   commentId: commentId,
//                   lastCircleType: content.circleType,
//                   extraType: ExtraType.fromPush),
//             );
//             JPushUtil.gotoCircle(detailData: detailData);
//           } catch (e) {
//             logger.info('getChat notification error -- $e');
//           }
//           break;
//         default:
//           break;
//       }
//     }
//   }
//
//   void initialize();
//
//   Future push(String title, String body, Map<String, String> extra);
//
//   Future<bool> isWindowVisible();
// }

// class _WindowsLocalNotification extends _LocalNotification
//     implements EventListener {
//   @override
//   void initialize() {
//     final ValueListenable<bool> event = DesktopLifecycle.instance.isActive;
//     event.addListener(() {
//       final active = DesktopLifecycle.instance.isActive.value;
//       if (active) {
//         final channelId = GlobalState.selectedChannel.value?.id;
//         if (channelId == null || channelId.isEmpty) return;
//         WinToast.instance().remove(channelId: channelId);
//       }
//     });
//     GlobalState.selectedChannel.addListener(() {
//       WinToast.instance()
//           .remove(channelId: GlobalState.selectedChannel.value?.id);
//     });
//     WinToast.instance().initialize(
//         appName: 'Fanbook',
//         productName: 'Fanbook',
//         companyName: 'iDreamSky',
//         eventListener: this);
//   }
//
//   @override
//   Future push(String title, String body, Map<String, String> extra) async {
//     if (!await WinToast.instance().isSupport()) return null;
//     String avatar = p.joinAll([
//       p.dirname(Platform.resolvedExecutable),
//       'data/flutter_assets/assets',
//       'app-icon/icon.ico'
//     ]);
//     if (extra.containsKey("user_id")) {
//       final userInfo = await UserInfo.getUserInfoRoles(extra["user_id"]);
//       if (userInfo != null) {
//         // 优先展示nft头像
//         final avatarUrl = strNoEmpty(userInfo.avatarNft)
//             ? userInfo.avatarNft
//             : userInfo.avatar ?? "";
//         if (strNoEmpty(avatarUrl)) {
//           final file = await CustomCacheManager.instance
//               .getSingleFile(avatarUrl, key: avatarUrl);
//           avatar = file.path;
//         }
//       }
//     }
//     WinToast.instance().showToast(
//         type: ToastType.imageAndText02,
//         title: title,
//         subtitle: body,
//         extra: extra,
//         imagePath: avatar);
//   }
//
//   @override
//   void activated(ActivatedEvent event) {
//     WinToast.instance().showWindow();
//     Future.delayed(const Duration(milliseconds: 250),
//         () => _handlerNotification(event.extra));
//   }
//
//   @override
//   Future<bool> isWindowVisible() async {
//     final bool isVisible = await WinToast.instance().isWindowVisible();
//     return Future.value(isVisible);
//   }
// }
//
// class _MacosLocalNotification extends _LocalNotification {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   @override
//   Future<void> initialize() async {
//     const MacOSInitializationSettings initializationSettingsMacOS =
//         MacOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       macOS: initializationSettingsMacOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (payload) async {
//       if (payload != null) {
//         final Map<String, dynamic> extra = json.decode(payload);
//         _handlerNotification(extra);
//       }
//     });
//
//     //权限请求 应该在 initialize 之后
//     await _requestPermissions();
//   }
//
//   //请求权限
//   Future<void> _requestPermissions() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }
//
//   @override
//   Future<bool> isWindowVisible() async {
//     await windowManager.ensureInitialized();
//     final bool isFocused = await windowManager.isFocused();
//     if (isFocused) {
//       return Future.value(true);
//     }
//     final bool isMinimized = await windowManager.isMinimized();
//     if (isMinimized) {
//       return Future.value(false);
//     }
//     return windowManager.isVisible();
//   }
//
//   @override
//   Future push(String title, String body, Map<String, String> extra) async {
//     await _showNotification(title, body, extra);
//   }
//
// //-0x80000000 <= id <= 0x7FFFFFFF，demo中给ID=0 有问题：丢消息
//   static int id = 0;
//
//   Future<void> _showNotification(
//       String title, String body, Map<String, String> extra) async {
//     const MacOSNotificationDetails macOSNotificationDetails =
//         MacOSNotificationDetails();
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(macOS: macOSNotificationDetails);
//     id = (id % 0x7FFFFFFF) + 1;
//     await flutterLocalNotificationsPlugin.show(
//         id, title, body, platformChannelSpecifics,
//         payload: json.encode(extra));
//   }
// }
