import '../../ast/all.dart';
import '../all.dart';

class IconTitleNode extends SingleChildWidgetNode<IconTitleData> {
  final IconTitleData iconTitleData;
  final RootParam? rootParam;

  IconTitleNode(
    this.iconTitleData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitIconTitleNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => data.type ?? WidgetName.iconTitle;

  @override
  IconTitleData get data => iconTitleData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.text,
        '标题',
      ]),
      NodeDescriptionRow([
        JsonName.icon,
        '图标地址',
      ]),
      NodeDescriptionRow([
        JsonName.type,
        '默认为"ic_title"时无背景，为"ic_bg_tt"时有背景',
      ]),
      NodeDescriptionRow([
        JsonName.bg,
        '0为渐变色一(主题渐变)，1为渐变色二，2为渐变色三，默认为0',
      ]),
      NodeDescriptionRow([
        JsonName.line + JsonLevel.first,
        '单行 - 1 / 多行 - 0',
      ]),
      NodeDescriptionRow([
        JsonName.status,
        '0 不显示，1 进行中，2结束',
      ]),
    ]);
  }
}

class IconTitleData extends WidgetNodeData {
  String? text;
  String? icon;
  String? type;
  int? bg;
  int? line;
  int? status;
  int? textColorHex;
  int? bgColorHex;

  IconTitleData(
    this.text,
    this.icon, {
    this.type = WidgetName.iconTitle,
    this.bg = bgOne,
    this.line = multiLine,
    this.status = statusNull,
    this.textColorHex,
    this.bgColorHex,
  });

  @override
  Map<String, dynamic> toJson() => {
        JsonName.text: text,
        JsonName.icon: icon,
        JsonName.bg: bg,
        JsonName.line: line,
        JsonName.status: status,
        if (textColorHex != null) JsonName.textColorHex: textColorHex,
        if (bgColorHex != null) JsonName.bgColorHex: bgColorHex,
      };

  IconTitleData.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      icon = '';
      type = WidgetName.iconTitle;
      bg = bgOne;
      line = multiLine;
      return;
    }
    text = json[JsonName.text] ?? '';
    icon = json[JsonName.icon] ?? '';
    type = json[JsonName.type] ?? WidgetName.iconTitle;
    bg = handleNum(json[JsonName.bg]) ?? bgOne;
    line = handleNum(json[JsonName.line]) ?? multiLine;
    status = handleNum(json[JsonName.status]) ?? statusNull;
    textColorHex = handleNum(json[JsonName.textColorHex]);
    bgColorHex = handleNum(json[JsonName.bgColorHex]);
  }

  static const bgOne = 0;
  static const bgTwo = 1;
  static const bgThree = 2;
  static const bgFour = 3;

  static const singleLine = 1;
  static const multiLine = 0;

  static const statusNull = 0;
  static const statusInProgress = 1;
  static const statusFinish = 2;
}
