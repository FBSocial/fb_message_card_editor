import '../../ast/all.dart';
import '../all.dart';

class TextNode extends SingleChildWidgetNode<TextData> {
  final TextData textData;
  final RootParam? rootParam;

  TextNode(
    this.textData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitTextNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.text;

  @override
  TextData get data => textData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.text + JsonLevel.first,
        '传入的内容',
      ]),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.first,
        '黑色 - 0 / 灰色 - 1',
      ]),
      NodeDescriptionRow([
        JsonName.line + JsonLevel.first,
        '单行 - 1 / 多行 - 0',
      ]),
    ]);
  }
}

class TextData extends WidgetNodeData {
  String? text;
  int? line;
  int? type;

  TextData(this.text, {this.line = 1, this.type = 0});

  @override
  Map<String, dynamic> toJson() =>
      {JsonName.text: text, JsonName.type: type, JsonName.line: line};

  TextData.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      line = multiLine;
      type = blackType;
      return;
    }
    text = json[JsonName.text] ?? '';
    line = handleNum(json[JsonName.line]) ?? multiLine;
    type = handleNum(json[JsonName.type]) ?? blackType;
  }

  static const singleLine = 1;
  static const multiLine = 0;

  static const blackType = 0;
  static const descType = 1;
}
