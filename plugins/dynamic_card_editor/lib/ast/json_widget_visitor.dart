import '../widget_nodes/all.dart';
import 'ast.dart';

class JsonWidgetVisitor extends AstVisitor<Map<String, dynamic>> {
  @override
  Map<String, dynamic> visitNode(AstNode node) => node.accept(this);

  @override
  Map<String, dynamic> visitColumn(ColumnNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        children: node.children?.map((e) => visitNode(e)).toList(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitTitleNode(TitleNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitIconTitleNode(IconTitleNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitTextNode(TextNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitTitleTextNode(TitleTextNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitMultiTextNode(MultiTextNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitHintTextNode(HintTextNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitRadioNode(RadioNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitContainer(ContainerNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        child: node.child == null ? null : visitNode(node.child!),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitContentTextNode(ContentTextNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitInputNode(InputNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitDropdownNode(DropdownButtonNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitButtonNode(ButtonNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitImageNode(ImageNode node) => commonMap(
        type: node.widgetType,
        id: node.rootParam?.id,
        formId: node.rootParam?.formId,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitDividerNode(DividerNode node) => commonMap(
        type: node.widgetType,
        external: node.external,
      );

  @override
  Map<String, dynamic> visitVoteTitle(VoteTitleNode node) => commonMap(
        type: node.widgetType,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitVoteTextNode(VoteTextNode node) => commonMap(
        type: node.widgetType,
        param: node.data.toJson(),
        external: node.external,
      );

  @override
  Map<String, dynamic> visitGapDividerNode(GapDividerNode node) => commonMap(
        type: node.widgetType,
        param: node.data.toJson(),
        external: node.external,
      );
}

Map<String, dynamic> commonMap({
  String? type,
  String? id,
  String? formId,
  dynamic external,
  Map<String, dynamic>? param,
  List<Map<String, dynamic>>? children,
  Map<String, dynamic>? child,
}) {
  return {
    if (id != null) JsonName.id: id,
    if (formId != null) JsonName.formId: formId,
    if (type != null) JsonName.type: type,
    if (param != null) JsonName.param: param,
    if (children != null) JsonName.children: children,
    if (child != null) JsonName.child: child,
    if (external != null) JsonName.external: external,
  };
}
