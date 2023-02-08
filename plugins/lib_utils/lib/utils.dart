import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lib_utils/universal_platform.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakelock/wakelock.dart';

import 'config/config.dart';
import 'locale/message_keys.dart';
import 'orientation_util.dart';

// ignore: avoid_annotating_with_dynamic
bool safeBoolFromJson(dynamic jsonValue, bool defaultValue) {
  if (jsonValue == null) return defaultValue;
  if (jsonValue is bool) return jsonValue;
  if (jsonValue is int) return jsonValue == 1;
  if (jsonValue is String) return jsonValue == "1";
  return defaultValue;
}

List<String> safeStringListFromJson(
  // ignore: avoid_annotating_with_dynamic
  dynamic jsonValue,
  List<String> defaultValue,
) {
  if (jsonValue == null) return defaultValue;
  if (jsonValue is List) {
    return jsonValue.map((e) => e.toString()).toList();
  }
  if (jsonValue is String) {
    try {
      final data = jsonDecode(jsonValue);
      return safeStringListFromJson(data, defaultValue);
    } catch (_) {}
  }
  return defaultValue;
}

bool isNotNullAndEmpty(String? str) {
  return str != null && str.isNotEmpty;
}

/// - list集合不为null并且不为空
bool listIsNotNullAndEmpty(List? list) {
  return list != null && list.isNotEmpty;
}

TextPainter calculateTextHeight(BuildContext context, String value,
    TextStyle style, double maxWidth, int maxLines) {
  ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
  final TextPainter painter = TextPainter(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,

      /// master 分支注释 nullok
      locale: Localizations.localeOf(context),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(text: value, style: style));
  painter.layout(maxWidth: max(0, maxWidth));
  return painter;
}

/// 这是有赞商品详情图片获取缩略图的方式
/// 可以通过指定最小边最大值[maxShortEdge]
/// 有赞使用的规范参考(有赞提供)：
/// https://developer.qiniu.com/dora/1279/basic-processing-images-imageview2
String fetchYzCdnThumbUrl(String? rawUrl, int maxShortEdge) {
  final suffix = "?imageView2/0/h/$maxShortEdge";
  if (rawUrl == null || rawUrl.isEmpty) {
    return "";
  } else if (rawUrl.endsWith("gif") || rawUrl.endsWith(suffix)) {
    return rawUrl;
  } else {
    return "$rawUrl$suffix";
  }
}

bool isNumeric(String? s) {
  if (s == null) return false;
  return double.tryParse(s) != null;
}

/// 格式化数量（万，亿）保持内容不操过4位
String formatNum(int value) {
  if (value > 100000000) {
    // ignore: prefer_interpolation_to_compose_strings
    return (value / 100000000).toStringAsFixed(1) + " 亿".tr;
  } else if (value > 10000000) {
    // ignore: prefer_interpolation_to_compose_strings
    return (value / 100000000).toStringAsFixed(2) + " 亿".tr;
  } else if (value > 1000000) {
    // ignore: prefer_interpolation_to_compose_strings
    return (value / 10000).toStringAsFixed(0) + " 万".tr;
  } else if (value > 10000) {
    // ignore: prefer_interpolation_to_compose_strings
    return (value / 10000).toStringAsFixed(1) + " 万".tr;
  } else {
    return value.toString();
  }
}

/// 格式化秒
String formatSecond(int value) {
  int _value = value;
  String ret = '';
  if (_value >= 24 * 60 * 60) {
    final tmp = (_value / (24 * 60 * 60)).floor();
    ret += '%s天'.trArgs([tmp.toString()]);
    _value -= tmp * 24 * 60 * 60;
    return ret;
  }

  if (_value >= 60 * 60) {
    final tmp = (_value / (60 * 60)).floor();
    ret += '${twoDigits(tmp)}:';
    _value -= tmp * 60 * 60;
  } else {
    ret += '00:';
  }

  if (_value >= 60) {
    final tmp = (_value / 60).floor();
    ret += '${twoDigits(tmp)} ';
    _value -= tmp * 24 * 60 * 60;
  } else {
    ret += '00';
  }
  return ret;
}

//将视频文件的总秒数转换为 分钟：秒
String timeFormatted(int totalSeconds) {
  final int sec = totalSeconds % 60;
  final int min = ((totalSeconds / 60) % 60).toInt();
  final int hours = totalSeconds ~/ 3600;

  final String seconds = (sec >= 10) ? sec.toString() : '0$sec';
  final String minutes = (min >= 10) ? min.toString() : '0$min';

  if (hours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}

String lastMsgFormatDate2Str(DateTime date) {
  List<String> args;
  final now = DateTime.now();
  if (date.year == now.year) {
    if (date.month == now.month) {
      if (date.day == now.day) {
        args = const [HH, ":", nn];
      } else if (date.add(const Duration(days: 1)).day == now.day) {
        // 如果是昨天，显示为 昨天 10:00
        args = ["昨天".tr];
      } else {
        args = [m, "月", d, "日 "];
      }
    } else {
      // 如果���同���年，显示为 11-11 02-02 10:00
      args = [m, "月", d, "日 "];
    }
  } else {
    // 如果不是同一年，显示为 1999-11-11 02-02 10:00
    args = [yyyy, "年", m, "月", d, "日 "];
  }
  return formatDate(date, args);
}

/// 把日期格式化为 MM-DD HH:MM
// String formatDate(int time) {
//   DateTime date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
//   Duration diff = DateTime.now().difference(date);
// if (diff.inSeconds < 60) {
//   return "刚刚";
// } else if (diff.inHours < 1) {
//   return "${diff.inMinutes}分钟前";
// } else if (diff.inDays < 1) {
//   return "今天 ${twoDigits(date.hour)}:${twoDigits(date.minute)}";
// } else if (diff.inDays < 2) {
//   return "昨天 ${twoDigits(date.hour)}:${twoDigits(date.minute)}";
// } else

//   if (diff.inDays < 365) {
//     return "${date.month}-${date.day} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}";
//   } else {
//     return "${date.year}-${date.month}-${date.day} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}";
//   }
// }
String formatDate2Str(DateTime date, {bool showToday = false}) {
  List<String> args;
  final now = DateTime.now();
  if (date.year == now.year) {
    if (date.month == now.month) {
      if (date.day == now.day) {
        // 如果是同一天，显示为 10:00
        if (showToday) {
          args = ["今天 ".tr, HH, ":", nn];
        } else {
          args = const [HH, ":", nn];
        }
      } else if (date.add(const Duration(days: 1)).day == now.day) {
        // 如果是昨天，显示为 昨天 10:00
        args = ["昨天 ".tr, HH, ":", nn];
//      } else if (now.difference(date).inDays < 7 &&
//          date.weekday < now.weekday) {
//        // 如果在同一个自然周内，显示为 星期一 10:00
//        const weekDayString = {
//          1: "一",
//          2: "二",
//          3: "三",
//          4: "四",
//          5: "五",
//          6: "六",
//          7: "日".tr
//        };
//        args = ["星期${weekDayString[date.weekday]} ", HH, ":", nn];
      } else {
        if (Get.locale!.languageCode != MessageKeys.zh) {
          return intl.DateFormat.MMMd().add_Hm().format(date);
        }

        args = [m, "月".tr, d, "日 ".tr, HH, ":", nn];
      }
    } else {
      if (Get.locale!.languageCode != MessageKeys.zh) {
        return intl.DateFormat.MMMd().add_Hm().format(date);
      }
      // 如果���同���年，显示为 11-11 02-02 10:00
      args = [m, "月".tr, d, "日 ".tr, HH, ":", nn];
    }
  } else {
    if (Get.locale!.languageCode != MessageKeys.zh) {
      return intl.DateFormat.yMMMd().add_Hm().format(date);
    }
    // 如果不是同一年，显示为 1999-11-11 02-02 10:00
    args = [yyyy, "年".tr, m, "月".tr, d, "日 ".tr, HH, ":", nn];
  }
  return formatDate(date, args);
}

/// 格式化日期
/// @param time: milliseconds since epoch
/// @return 返回格式：xxxx年xx月xx日 hh:mm:ss
String formatDetailDate(int time) {
  final date = DateTime.fromMillisecondsSinceEpoch(time);
  if (Get.locale!.languageCode != MessageKeys.zh) {
    return intl.DateFormat.yMMMd().add_Hms().format(date);
  }
  return formatDate(
    date,
    [yyyy, "年".tr, mm, "月".tr, dd, "日 ".tr, hh, ":", nn, ":", ss],
  );
}

Scaffold popWrap(
    {double width = 440,
    double? height,
    Widget? child,
    double horizontal = 24}) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Center(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        decoration: BoxDecoration(
            color: Get.theme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: child,
      ),
    ),
  );
}

Future<bool> hasInstallWeChat() {
  return canLaunchUrlString("weixin://");
}

Future<bool> hasInstallQQ() {
  return canLaunchUrlString("mqq://");
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

TextStyle copyWithFs12(TextStyle ts) {
  return ts.copyWith(fontSize: 12);
}

String subRichString(String str, int len) {
  // 删除emoji表情
  final sRunes = str.runes;
  return sRunes.length > len ? String.fromCharCodes(sRunes, 0, len) : str;
}

/// 获取图片的宽高的等信息
Future<ImageInfo> getImageInfo(String filePath) {
  return getImageInfoByProvider(NetworkImage(filePath));
}

Future<ImageInfo> getImageInfoByProvider(ImageProvider provider) {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  bool flag = false;
  provider
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((info, _) {
    if (!flag) {
      completer.complete(info);
      flag = true;
    }
  }));
  return completer.future;
}

/// - 保留几位double小数
String formatDouble(double num, int position) {
  if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
      position) {
    //小数点后有几位小数
    return num.toStringAsFixed(position)
        .substring(0, num.toString().lastIndexOf(".") + position + 1)
        .toString();
  } else {
    return num.toString()
        .substring(0, num.toString().lastIndexOf(".") + position + 1)
        .toString();
  }
}

String generateMd5(String data) {
  final content = const Utf8Encoder().convert(data);
  const md5 = crypto.md5;
  final digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

String getPlatform() {
  if (UniversalPlatform.isAndroid) return 'android';
  if (UniversalPlatform.isIOS) return 'ios';
  return 'web';
}

/// 屏幕常亮
void setAwake(bool value) {
  if (!UniversalPlatform.isMobileDevice) return;
  Wakelock.toggle(enable: value);

  /// FIXME(jp@jin.dev): 2022/11/2 开启亮度会设置为light模式 https://github.com/creativecreatorormaybenot/wakelock/issues/161
  /// 临时解决方案
  if (!value && UniversalPlatform.isAndroid) {
    final systemUiOverlayStyle =
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

/// 判断是否中国手机号码
bool isChineseMobile(String? mobile) {
  if (!isNotNullAndEmpty(mobile)) return false;
  return RegExp(r"^1\d{10}$").hasMatch(mobile!);
}

// todo delete it
Widget bottomViewInset({Color? color}) {
  return Container(
    height: Config.mediaInfo!.padding.bottom,
    color: color,
  );
}

double getTopViewInset() {
  return Config.mediaInfo!.padding.top;
}

double getBottomViewInset() {
  double padding = Config.mediaInfo?.padding.bottom ?? 0;
  if (Config.mediaInfo?.padding.bottom == 0.0 &&
      Config.mediaInfo?.viewInsets.bottom != 0.0) {
    padding = Config.mediaInfo!.viewPadding.bottom;
  }
  if (UniversalPlatform.isAndroid && padding == 0) {
    padding = Config.mediaInfo!.systemGestureInsets.bottom;
  }
  return padding;
}

///cdnUrl 图片原始地址
///thumbWidth 图片需要被压缩成的宽度
String fetchCdnThumbUrl(String? cdnUrl, double thumbWidth) {
  final suffix = "?imageMogr2${Config.webpPath}/thumbnail/${thumbWidth}x";
  if (cdnUrl == null || cdnUrl.isEmpty) {
    return "";
  } else if (cdnUrl.endsWith("gif") || cdnUrl.endsWith(suffix)) {
    return cdnUrl;
  } else {
    return "$cdnUrl$suffix";
  }
}

/// 显示倒计时
String formatCountdownTime(int seconds) {
  final hour = (seconds / 3600).floor();
  final minute = ((seconds - hour * 3600) / 60).floor();
  final second = seconds % 60;
  if (hour < 1) return "${twoDigits(minute)}:${twoDigits(second)}";
  return "${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}";
}

/// 显示倒计时
List<String> formatCountdownTimeToList(int seconds) {
  List<String> list = [];
  final hour = (seconds / 3600).floor();
  final minute = ((seconds - hour * 3600) / 60).floor();
  final second = seconds % 60;
  list.add(twoDigits(hour));
  list.add(twoDigits(minute));
  list.add(twoDigits(second));
  return list;
}

/// 显示倒计时 xx天 xx:xx:xx
String formatCountdownTimeWithDay(int seconds) {
  if (seconds == 0) return '';

  final day = seconds ~/ 86400;
  if (day == 0) {
    return formatCountdownTime(seconds);
  }

  final hour = (seconds % 86400) ~/ 3600;
  final minute = (seconds % 3600) ~/ 60;
  final second = seconds % 60;
  if (hour < 1) return "$day天${twoDigits(minute)}:${twoDigits(second)}";
  return "$day天${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}";
}

String twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

Future delay(void Function()? func, [int milliseconds = 300]) {
  return Future.delayed(Duration(milliseconds: milliseconds), func?.call);
}

const minSizeConstraint = 64.0;
const maxSizeConstraint = 279.0;

double get maxMediaWidth => OrientationUtil.landscape ? 400 : maxSizeConstraint;

Tuple3<num, num, BoxFit> getImageSize(num? _width, num? _height,
    {BoxFit? defaultFit, double? maxSizeConstraint}) {
  maxSizeConstraint ??= maxMediaWidth;
  // todo 120 or minSizeConstraint?
  var width = _width ?? 120;
  width = width > 0 ? width : 120;
  var height = _height ?? maxSizeConstraint;
  height = height > 0 ? height : maxSizeConstraint;
  BoxFit fit = defaultFit ?? BoxFit.contain;
  if (width / height > (maxSizeConstraint / minSizeConstraint)) {
    // 横线长图
    width = maxSizeConstraint;
    height = minSizeConstraint;
    fit = BoxFit.fitHeight;
  } else if (height / width > (maxSizeConstraint / minSizeConstraint)) {
    // 纵向长图
    width = minSizeConstraint;
    height = maxSizeConstraint;
    fit = BoxFit.fitWidth;
  } else if (width > maxSizeConstraint || height > maxSizeConstraint) {
    final s = min(maxSizeConstraint / width, maxSizeConstraint / height);
    width = _width! * s;
    height = _height! * s;
  } else if (width < minSizeConstraint || height < minSizeConstraint) {
    final s = max(minSizeConstraint / width, minSizeConstraint / height);
    width = _width! * s;
    height = _height! * s;
  }
  return Tuple3(width, height, fit);
}

///圈子图片(分享卡片,分享海报)的展示比例范围:
double circleImageMinRatio = 3 / 4;
double circleImageMaxRatio = 4 / 3;

/// * 按照宽高比范围，计算图片显示的高度
/// * imageWidth imageHeight：图片的宽高，单位是像素
/// * widgetWidth：图片显示的宽度，单位是dp
double? getImageHeightByRatio(
    double? imageWidth, double imageHeight, double widgetWidth) {
  if (imageWidth == 0 || imageHeight == 0) {
    return widgetWidth / circleImageMinRatio;
  }
  double? widgetHeight;
  final itemRatio = imageWidth! / imageHeight;
  if (itemRatio >= circleImageMinRatio && itemRatio <= circleImageMaxRatio) {
    final itemWidth = imageWidth / Get.pixelRatio;
    final itemHeight = imageHeight / Get.pixelRatio;
    // 宽高比: 在最小和最大之间，等比缩放
    widgetHeight = itemHeight * (widgetWidth / itemWidth);
  } else if (itemRatio < circleImageMinRatio) {
    // 宽高比: 小于最小，按最小比计算高度
    widgetHeight = widgetWidth / circleImageMinRatio;
  } else if (itemRatio > circleImageMaxRatio) {
    // 宽高比: 大于最小，按最大比计算高度
    widgetHeight = widgetWidth / circleImageMaxRatio;
  }
  return widgetHeight;
}
