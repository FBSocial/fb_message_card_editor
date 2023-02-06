// import 'package:dio/dio.dart';
// import 'package:im/api/check_api.dart';
// import 'package:lib_utils/loggers.dart';
// import 'package:im/utils/content_checker.dart';
//
// class TextCheckerInterceptor extends Interceptor {
//   @override
//   Future<void> onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final url = options.uri.toString();
//     if (url == checkTextUrl || url.contains('/api/role/save'))
//       return handler.next(options);
//     if (options.uri.toString() == checkTextUrl) return handler.next(options);
//     final data = options.data;
//     if (data == null) return handler.next(options);
//
//     final Map<String, TextWithChanel> checkList = {};
//
//     ///从请求中筛选服务器名字、频道名字、频道分类名字
//     final name = data[nameT]?.toString() ?? '';
//
//     ///从请求中筛选类型：0=文字;1=语音;2=视频;4=频道分类
//     final type = data[typeT]?.toString() ?? '';
//
//     ///筛选频道主题
//     final topic = data[topicT]?.toString();
//
//     ///筛选用户名称
//     final nickname = data[nicknameT]?.toString() ?? '';
//
//     ///频道id
//     final channelId = data[channelIdT]?.toString() ?? '';
//
//     ///备注名的好友id
//     final friendId = data[friendUserIdT]?.toString() ?? '';
//
//     ///服务器昵称
//     final nick = data[nickT]?.toString() ?? '';
//
//     final bool isNameNotEmpty = isNotEmpty(name);
//     final bool isTypeNotEmpty = isNotEmpty(type);
//     final bool isTopicNotNull = isNotNull(topic);
//     final bool isTopicNotEmpty = isNotEmpty(topic);
//     final bool isChannelIdNotEmpty = isNotEmpty(channelId);
//     final bool isNicknameNotEmpty = isNotEmpty(nickname);
//     final bool isFriendIdNotEmpty = isNotEmpty(friendId);
//     final bool isNickNotEmpty = isNotEmpty(nick);
//     final bool isNotGuildApplication = !url.contains('guildApplication');
//
//     checkCircleText(url, data, checkList);
//     checkCircleTopic(url, data, checkList);
//     checkCircleTopicList(url, data, checkList);
//     checkCirclePost(url, data, checkList);
//
//     final isCreateService = isNameNotEmpty &&
//         !isTopicNotNull &&
//         !isTypeNotEmpty &&
//         !isChannelIdNotEmpty &&
//         !isFriendIdNotEmpty &&
//         isNotGuildApplication;
//     final isChangeChannelOrTopic = isNameNotEmpty &&
//         isTopicNotNull &&
//         isTopicNotNull &&
//         isChannelIdNotEmpty;
//     final isCreateChannel = url.contains(createChannel);
//     final isCreateChannelType = isNameNotEmpty &&
//         isTypeNotEmpty &&
//         type == '4' &&
//         url.contains(createChannel);
//     final isChangeChannelType = isNameNotEmpty &&
//         !isTypeNotEmpty &&
//         isChannelIdNotEmpty &&
//         !isChangeChannelOrTopic &&
//         url.contains(updateChannel);
//     final isSetGuildNick = url.contains(setGuildNick) && isNickNotEmpty;
//     if (isSetGuildNick) {
//       checkList[nickT] ??= TextWithChanel(nick, TextChannelType.NICKNAME);
//     }
//     if (isCreateService) {
//       checkList[nameT] ??= TextWithChanel(name, TextChannelType.SERVICE_NAME);
//     }
//     if (isChangeChannelOrTopic || isCreateChannel) {
//       checkList[nameT] ??= TextWithChanel(name, TextChannelType.CHANNEL_NAME);
//       if (isTopicNotEmpty)
//         checkList[topicT] ??=
//             TextWithChanel(topic!, TextChannelType.CHANNEL_TITLE);
//     }
//     if (isCreateChannelType || isChangeChannelType) {
//       checkList[nameT] ??=
//           TextWithChanel(name, TextChannelType.CHANNEL_CLASSIFICATION_NAME);
//     }
//     if (isNicknameNotEmpty) {
//       checkList[nicknameT] ??=
//           TextWithChanel(nickname, TextChannelType.NICKNAME);
//     }
//
//     for (final item in checkList.values) {
//       if (item.text.isEmpty) continue;
//       try {
//         final checkPassed = await CheckUtil.startCheck(
//             TextCheckItem(item.text, item.channel, checkType: item.checkType));
//         if (!checkPassed) {
//           return handler.reject(CheckTypeException(defaultErrorMessage));
//         }
//       } on Exception catch (e) {
//         logger.severe('审核请求出错:$e');
//         handler.reject(e as DioError);
//       }
//     }
//     handler.next(options);
//   }
//
//   bool isNotEmpty(String? text) => text != null && text.toString().isNotEmpty;
//
//   bool isNotNull(String? text) => text != null;
//
//   ///检测圈子信息编辑相关内容
//   void checkCircleText(
//       String url, Map data, Map<String, TextWithChanel> checkList) {
//     if (!url.contains(circleManagerUrl)) return;
//     final name = data[nameT]?.toString() ?? '';
//     final description = data[descriptionT]?.toString() ?? '';
//
//     final bool isNameNotEmpty = isNotEmpty(name);
//     final bool isDesNotEmpty = isNotEmpty(description);
//
//     if (isNameNotEmpty) {
//       checkList[nameT] ??= TextWithChanel(name, TextChannelType.FB_CIRCLE_TITLE,
//           checkType: CheckType.circle);
//     }
//     if (isDesNotEmpty) {
//       checkList[descriptionT] ??= TextWithChanel(
//           description, TextChannelType.FB_CIRCLE_DESC,
//           checkType: CheckType.circle);
//     }
//   }
//
//   ///检测圈子的圈子频道添加
//   void checkCircleTopic(
//       String url, Map data, Map<String, TextWithChanel> checkList) {
//     if (!url.contains(addTopicUrl)) return;
//     final name = data[nameT]?.toString() ?? '';
//     final bool isNameNotEmpty = isNotEmpty(name);
//     if (isNameNotEmpty) {
//       checkList[nameT] ??= TextWithChanel(name, TextChannelType.FB_CIRCLE_TOPIC,
//           checkType: CheckType.circle);
//     }
//   }
//
//   ///检测Web圈子的圈子频道添加、修改
//   void checkCircleTopicList(
//       String url, Map data, Map<String, TextWithChanel> checkList) {
//     if (!url.contains(topicUpdateUrl)) return;
//     final List<dynamic> topics = data[topicT] ?? [];
//     if (topics.isEmpty) return;
//     String topicNames = '';
//     topics.forEach((element) {
//       final topic = element[nameT] ?? '';
//       topicNames += '$topic,';
//     });
//     if (topicNames.isNotEmpty) {
//       checkList[nameT] ??= TextWithChanel(
//           topicNames, TextChannelType.FB_CIRCLE_TOPIC,
//           checkType: CheckType.circle);
//     }
//   }
//
//   ///检测圈子的创建
//   void checkCirclePost(
//       String url, Map data, Map<String, TextWithChanel> checkList) {
//     if (!url.contains(createTopicUrl)) return;
//     final title = data[titleT]?.toString() ?? '';
//     final bool isTitleNotEmpty = isNotEmpty(title);
//     if (isTitleNotEmpty) {
//       checkList[titleT] ??= TextWithChanel(
//           title, TextChannelType.FB_CIRCLE_POST_TEXT,
//           checkType: CheckType.circle);
//     }
//   }
//
//   ///检测圈子的评论
//   void checkCircleComment(
//       String url, Map data, Map<String, TextWithChanel> checkList) {
//     if (!url.contains(createTopicUrl)) return;
//     final title = data[titleT]?.toString() ?? '';
//     final bool isTitleNotEmpty = isNotEmpty(title);
//     if (isTitleNotEmpty) {
//       checkList[titleT] ??= TextWithChanel(
//           title, TextChannelType.FB_CIRCLE_POST_COMMENT,
//           checkType: CheckType.circle);
//     }
//   }
// }
//
// ///需要检查的字段，T是Type
// const nameT = 'name';
// const typeT = 'type';
// const topicT = 'topic';
// const titleT = 'title';
// const nicknameT = 'nickname';
// const channelIdT = 'channel_id';
// const friendUserIdT = 'friend_user_id';
// const descriptionT = 'description';
// const nickT = 'nick';
//
// ///指定URL的检测
// const circleManagerUrl = '/api/channel/manage';
// const addTopicUrl = '/api/circle/topicAdd';
// const topicUpdateUrl = '/api/circle/topicUpdate';
// const createTopicUrl = '/api/circle/postUpdate';
// const setGuildNick = '/api/guild/nick';
// const createChannel = '/api/channel/create';
// const updateChannel = '/api/channel/up';
//
// class TextWithChanel {
//   String text;
//   String channel;
//   CheckType checkType;
//
//   TextWithChanel(this.text, this.channel,
//       {this.checkType = CheckType.defaultType});
//
//   @override
//   String toString() {
//     return 'TextWithChanel{text: $text, channel: $channel, checkType: $checkType}';
//   }
// }
