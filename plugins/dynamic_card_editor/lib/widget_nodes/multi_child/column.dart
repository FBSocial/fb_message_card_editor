import 'dart:collection';

import '../../ast/all.dart';
import '../all.dart';

class ColumnNode extends MultiChildWidgetNode<ColumnData?> {
  List<WidgetNode>? _children;
  RootParam? rootParam;

  ColumnNode(this._children, {this.rootParam, TempWidgetConfig? config})
      : super(config) {
    _children?.forEach((e) {
      becomeParentOf(e);
    });
  }

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitColumn(this);

  @override
  void visitChildren(AstVisitor visitor) {
    _children?.forEach((e) {
      e.accept(visitor);
    });
  }

  @override
  List<WidgetNode>? get children => _children;

  set children(List<WidgetNode>? children) {
    this._children = children;
    _children?.forEach((e) {
      becomeParentOf(e);
    });
  }

  @override
  String get widgetType => WidgetName.column;

  @override
  ColumnData get data {
    final List<WidgetNodeData?> dataList = [];
    _children?.forEach((e) {
      if (e.data != null) dataList.add(e.data);
    });
    return ColumnData(dataList);
  }

  @override
  Map<String, Map<String, dynamic>>? get idData {
    final LinkedHashMap<String, Map<String, dynamic>> result = LinkedHashMap();
    _children?.forEach((e) {
      if (e.hasIdData && e.rootParam != null)
        result[e.rootParam!.id!] = {
          JsonName.type: e.widgetType,
          JsonName.param: e.data?.toJson(),
          if (e.external != null) JsonName.external: e.external,
        };
    });
    return result;
  }

  Map<String?, dynamic> getFormIdData(String? formId) {
    final List<Map<String, dynamic>> result = [];
    _children?.forEach((e) {
      if (e.rootParam?.formId != null && e.rootParam?.formId == formId)
        result.add({
          JsonName.type: e.widgetType,
          JsonName.param: e.data?.toJson(),
          if (e.external != null) JsonName.external: e.external,
        });
    });
    return {
      formId: result,
    };
  }

  @override
  bool get isDataEmpty {
    for (final WidgetNode child in (children ?? [])) {
      if (child.isDataEmpty) return true;
    }
    return false;
  }
}

class ColumnData extends WidgetNodeData {
  final List<WidgetNodeData?> dataList;

  ColumnData(this.dataList);

  @override
  Map<String, dynamic> toJson() =>
      {JsonName.list: dataList.map((e) => e!.toJson()).toList()};
}
