import '../../ast/all.dart';
import '../all.dart';

class TitleNode extends SingleChildWidgetNode<TitleData> {
  final TitleData titleData;
  final RootParam? rootParam;

  TitleNode(
    this.titleData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitTitleNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.title;

  @override
  TitleData get data => titleData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.text,
        '标题',
      ]),
    ]);
  }
}

class TitleData extends WidgetNodeData {
  String? text;

  TitleData(this.text);

  @override
  Map<String, dynamic> toJson() => {JsonName.text: text};

  TitleData.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      return;
    }
    text = json[JsonName.text] ?? '';
  }
}
