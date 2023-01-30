import '../../ast/all.dart';
import '../all.dart';

class HintTextNode extends SingleChildWidgetNode<HintTextData> {
  final HintTextData hintTextData;
  final RootParam? rootParam;

  HintTextNode(
    this.hintTextData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitHintTextNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.hintText;

  @override
  HintTextData get data => hintTextData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.title + JsonLevel.first,
        '左边传入的内容',
      ]),
      NodeDescriptionRow([
        JsonName.text + JsonLevel.first,
        '右边传入的内容',
      ]),
    ]);
  }
}

class HintTextData extends WidgetNodeData {
  String? title;
  String? text;

  HintTextData(this.title, this.text);

  @override
  Map<String, dynamic> toJson() => {JsonName.title: title, JsonName.text: text};

  HintTextData.fromJson(Map json) {
    if (json.isEmpty) {
      title = '';
      text = '';
      return;
    }
    title = json[JsonName.title] ?? '';
    text = json[JsonName.text] ?? '';
  }
}
