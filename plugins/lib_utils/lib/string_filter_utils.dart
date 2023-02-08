import 'package:lpinyin/lpinyin.dart';

var _pinyinSeparator = String.fromCharCode(0);

String _getShortPinyin(String str, {String defPinyin = '#'}) {
  final sb = StringBuffer();
  final pinyin = PinyinHelper.getPinyinE(str,
      separator: _pinyinSeparator, defPinyin: defPinyin);
  final list = pinyin.split(_pinyinSeparator);
  for (var value in list) {
    if (value.isEmpty) continue;
    sb.write(value[0]);
  }
  return sb.toString();
}

/// 用来匹配过滤字符串的工具
/// 例如使用在：
/// 1. 「@ 列表」的过滤
/// 2. 「#频道」列表的过滤
class StringFilterUtils {
  static final Map<String, String> _pinYinDictionary = <String, String>{};

  /// 在 [src] 中检查是否匹配 [check] 字符串
  /// - 支持 [src] 中文首字母
  /// - 支持 [src] 忽略大小写
  static bool checkMatch(String src, String check) {
    if (!_pinYinDictionary.containsKey(src)) {
      _pinYinDictionary[src] =
          "$src ${_getShortPinyin(src)} ${PinyinHelper.getPinyin(src, separator: '')}"
              .toLowerCase();
    }

    /// replaceAll 里面的字符是 iPhone 输入法的分词字符，不是空格
    return _pinYinDictionary[src]!
        .contains(check.replaceAll(" ", '').toLowerCase());
  }
}
