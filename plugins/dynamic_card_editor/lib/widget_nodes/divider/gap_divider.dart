import '../../ast/all.dart';
import '../all.dart';

class GapDividerNode extends SingleChildWidgetNode<GapDividerData> {
  final GapDividerData gapDividerData;
  final RootParam? rootParam;

  GapDividerNode(
    this.gapDividerData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitGapDividerNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.gapDivider;

  @override
  GapDividerData get data => gapDividerData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.height + JsonLevel.first,
        '空白分割线的高度，默认为8.5',
      ]),
    ]);
  }
}

class GapDividerData extends WidgetNodeData {
  double? height;

  GapDividerData({this.height = 8.5});

  @override
  Map<String, dynamic> toJson() {
    return {
      JsonName.height: height,
    };
  }

  GapDividerData.fromJson(Map json) {
    if (json.isEmpty) {
      height = 8.5;
      return;
    }
    height = double.tryParse((json[JsonName.height] ?? 8.5).toString());
  }
}
