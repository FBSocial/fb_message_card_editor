import '../../ast/all.dart';
import '../all.dart';

class ContentTextNode extends SingleChildWidgetNode<ContentTextData> {
  final ContentTextData contentTextData;
  final RootParam? rootParam;

  ContentTextNode(
    this.contentTextData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitContentTextNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.contentText;

  @override
  ContentTextData get data => contentTextData;

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
        '0为h1，1为h2',
      ]),
    ]);
  }
}

class ContentTextData extends WidgetNodeData {
  String? text;
  int? type;

  ContentTextData(this.text, {this.type = h1});

  @override
  Map<String, dynamic> toJson() => {JsonName.text: text, JsonName.type: type};

  ContentTextData.fromJson(Map json) {
    if (json.isEmpty) {
      type = h1;
      text = '';
      return;
    }
    type = handleNum(json[JsonName.type]) ?? h1;
    text = json[JsonName.text] ?? '';
  }

  static const int h1 = 0;
  static const int h2 = 1;
}
