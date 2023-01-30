import '../../ast/all.dart';
import '../all.dart';

class ContainerNode extends SingleChildWidgetNode {
  final WidgetNode? _child;
  final RootParam? rootParam;

  ContainerNode(
    this._child, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitContainer(this);

  @override
  WidgetNode? get child => _child;

  @override
  String get widgetType => WidgetName.container;

  @override
  WidgetNodeData? get data => _child?.data;
}
