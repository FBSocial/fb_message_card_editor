import 'dart:convert';

import '../../ast/all.dart';
import '../all.dart';

class DropdownButtonNode extends SingleChildWidgetNode<DropdownData> {
  final DropdownData dropdownData;
  final RootParam? rootParam;

  DropdownButtonNode(
    this.dropdownData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitDropdownNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.dropdown;

  @override
  DropdownData get data => dropdownData;

  @override
  bool get isDataEmpty => data.select == null;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.id,
        '获取回调数据需要传入的自定义id字符串',
      ]),
      NodeDescriptionRow([
        JsonName.list + JsonLevel.first,
        '提供选择的文案列表',
      ]),
      NodeDescriptionRow([
        JsonName.select + JsonLevel.first,
        '默认选中的index，默认为null则表示无选中',
      ]),
      NodeDescriptionRow([
        JsonName.hint + JsonLevel.first,
        '无默认选中时的提示文案',
      ]),
    ]);
  }
}

class DropdownData extends WidgetNodeData {
  String? hint;
  List<String>? list;
  int? select;

  DropdownData(this.list, {this.hint = hintText, this.select = 0});

  Map<String, dynamic> toJson() {
    return {
      JsonName.hint: hint,
      JsonName.list: list,
      JsonName.select: select,
    };
  }

  DropdownData.fromJson(Map json) {
    if (json.isEmpty) {
      hint = hintText;
      list = [];
      select = 0;
      return;
    }
    hint = json[JsonName.hint] ?? hintText;
    final List dataList = json[JsonName.list] ?? [];
    list = dataList.map((e) => (e is String) ? e : jsonEncode(e)).toList();
    select = handleNum(json[JsonName.select]) ?? 0;
  }

  static const String hintText = '请选择';
}
