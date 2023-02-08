import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lib_utils/utils.dart';

class Language {
  static Map<String, dynamic> _words = {};

  /// 获取当前语言，支持参数，类似"abc{0}test{2}{1}xyz{0}"
  static String? get(String key, [List? params]) {
    assert(isNotNullAndEmpty(key));
    var word = _words[key];
    if (word != null) {
      if (params == null || params.isEmpty) {
        return word;
      } else {
        for (var i = params.length - 1; i > -1; i--) {
          word = word.replaceAll("{$i}", "${params[i]}");
        }
        return word;
      }
    }
    return key;
  }

  /// 切换语言包
  static Future<void> change(String langPath) async {
    if (isNotNullAndEmpty(langPath)) {
      final res = await rootBundle.loadString(langPath);
      try {
        final data = json.decode(res.toString());
        if (data != null) {
          _words = data;
          // App.refresh();
        }
      } catch (e) {
        throw "can not load path:$langPath";
      }
    } else {
      _words = {};
      // App.refresh();
    }
  }
}
