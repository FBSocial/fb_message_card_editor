import 'package:flutter/foundation.dart';

import '../widget_nodes/all.dart';

///--------------Node--------------///

abstract class AstNode {
  AstNode? get parent;

  AstNode get root;

  E accept<E>(AstVisitor<E> visitor);

  void visitChildren(AstVisitor visitor);
}

abstract class AstNodeImpl implements AstNode {
  AstNode? _parent;

  @override
  AstNode? get parent => _parent;

  @override
  AstNode get root {
    AstNode root = this;
    var parent = this.parent;
    while (parent != null) {
      root = parent;
      parent = root.parent;
    }
    return root;
  }

  T becomeParentOf<T extends AstNodeImpl>(T child) {
    child._parent = this;
    return child;
  }

  void visitChildren(AstVisitor visitor) {}
}

abstract class WidgetNode<T extends WidgetNodeData?> extends AstNodeImpl {
  TempWidgetConfig? config;

  dynamic external;

  String get widgetType;

  T get data;

  RootParam? get rootParam;

  bool get isDataEmpty => false;

  Map<String, Map<String, dynamic>>? get idData {
    if (!hasIdData) return null;
    final result = data?.toJson();
    if (result != null) {
      if (external != null) result[JsonName.external] = external;
      return {rootParam!.id!: result};
    }

    return null;
  }

  bool get hasIdData => rootParam?.id != null && data != null;

  bool get hasFormIdData => rootParam?.formId != null && data != null;

  NodeDescription getDescription() => NodeDescription([
        NodeDescriptionRow([describeIdentity(this)])
      ]);

  WidgetNode(this.config);
}

class NodeDescription {
  final List<NodeDescriptionRow> children;

  NodeDescription(this.children);
}

class NodeDescriptionRow {
  final List<String> children;

  NodeDescriptionRow(this.children);
}

abstract class MultiChildWidgetNode<T extends WidgetNodeData?>
    extends WidgetNode<T> {
  MultiChildWidgetNode(TempWidgetConfig? config) : super(config);

  Iterable<WidgetNode>? get children;
}

abstract class SingleChildWidgetNode<T extends WidgetNodeData?>
    extends WidgetNode<T> {
  SingleChildWidgetNode(TempWidgetConfig? config) : super(config);

  WidgetNode? get child;
}

abstract class WidgetNodeData {
  Map<String, dynamic> toJson();
}

///--------------Visitor--------------///

abstract class AstVisitor<R> {
  R? visitNode(AstNode node) {
    node.visitChildren(this);
    return null;
  }

  R visitColumn(ColumnNode node);

  R visitContainer(ContainerNode node);

  ///--------------TITLE--------------///

  R visitTitleNode(TitleNode node);

  R visitIconTitleNode(IconTitleNode node);

  R visitVoteTitle(VoteTitleNode node);

  ///--------------TEXT--------------///

  R visitTextNode(TextNode node);

  R visitTitleTextNode(TitleTextNode node);

  R visitMultiTextNode(MultiTextNode node);

  R visitHintTextNode(HintTextNode node);

  R visitContentTextNode(ContentTextNode node);

  R visitVoteTextNode(VoteTextNode node);

  ///--------------RADIO--------------///

  R visitRadioNode(RadioNode node);

  ///--------------INPUT--------------///

  R visitInputNode(InputNode node);

  ///--------------Divider--------------///

  R visitDividerNode(DividerNode node);

  R visitGapDividerNode(GapDividerNode node);

  ///--------------Button--------------///

  R visitDropdownNode(DropdownButtonNode node);

  R visitButtonNode(ButtonNode node);

  ///--------------Image--------------///

  R visitImageNode(ImageNode node);
}

///--------------Factory--------------///
//
// abstract class AstFactory {
//   TitleNode createTitleNode(String text);
//
//   ColumnNode createColumnNode(List<WidgetNode> children);
// }
//
// class AstFactoryImpl implements AstFactory {
//   @override
//   TitleNode createTitleNode(String text) => TitleNode(text);
//
//   @override
//   ColumnNode createColumnNode(List<WidgetNode> children) =>
//       ColumnNode(children);
// }
