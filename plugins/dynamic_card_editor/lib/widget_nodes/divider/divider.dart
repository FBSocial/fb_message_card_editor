import '../../ast/all.dart';
import '../all.dart';

class DividerNode extends SingleChildWidgetNode {
  DividerNode({
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitDividerNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.divider;

  @override
  WidgetNodeData? get data => null;

  @override
  RootParam? get rootParam => null;
}
