import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../ast/all.dart';
import '../../widgets/all.dart';
import '../all.dart';

class RootParam {
  final String? id;
  final String? formId;

  const RootParam({this.id, this.formId});
}

class JsonToNodeParser {
  JsonToNodeParser._privateConstructor();

  static final JsonToNodeParser _instance =
      JsonToNodeParser._privateConstructor();

  static JsonToNodeParser get instance => _instance;

  WidgetNode toNode(
    Map json, {
    WidgetNode? parentNode,
    NodeCallback? nodeCallback,
    Function? buttonCallback,
    TempWidgetConfig? config,
    bool isRoot = false,
  }) {
    if (isRoot) config?.controller?.clearCallback();
    parentNode ??= ContainerNode(null);
    if (json.isEmpty) return ContainerNode(null);
    WidgetNode? node;
    final type = json[JsonName.type] ?? '';
    final param = json[JsonName.param] ?? {};
    final id = json[JsonName.id];
    final formId = json[JsonName.formId];
    final rootParam = RootParam(id: id, formId: formId);
    final external = json[JsonName.external];
    nodeCallback?.call(type, id, param);
    switch (type) {
      case WidgetName.column:
        node = toColumn(json, rootParam,
            config: config, buttonCallback: buttonCallback);
        break;
      case WidgetName.title:
        node = toTitle(param, rootParam, config: config);
        break;
      case WidgetName.voteTitle:
        node = toVoteTitle(param, rootParam, config: config);
        break;
      case WidgetName.iconTitle:
        node = toIconTitle(param, rootParam, config: config);
        break;
      case WidgetName.iconBgTitle:
        node = toIconBgTitle(param, rootParam, config: config);
        break;
      case WidgetName.text:
        node = toText(param, rootParam, config: config);
        break;
      case WidgetName.hintText:
        node = toHintText(param, rootParam, config: config);
        break;
      case WidgetName.titleText:
        node = toTitleText(param, rootParam, config: config);
        break;
      case WidgetName.multiText:
        node = toMultiText(param, rootParam, config: config);
        break;
      case WidgetName.contentText:
        node = toContentText(param, rootParam, config: config);
        break;
      case WidgetName.voteText:
        node = toVoteText(param, rootParam, config: config);
        break;
      case WidgetName.radio:
        node = toRadio(param, rootParam, config: config);
        break;
      case WidgetName.input:
        node = toInput(param, rootParam, config: config);
        break;
      case WidgetName.divider:
        node = toDivider(config: config);
        break;
      case WidgetName.gapDivider:
        node = toGapDivider(param, rootParam, config: config);
        break;
      case WidgetName.dropdown:
        node = toDropdown(param, rootParam, config: config);
        break;
      case WidgetName.button:
        node = toButton(param, rootParam,
            buttonCallback: buttonCallback, config: config);
        break;
      case WidgetName.image:
        node = toImage(param, rootParam, config: config);
        break;
    }
    if (external != null) node?.external = external;
    if (node == null) {
      if (!kReleaseMode)
        throw Exception('未知的Node类型:$type      json:$json');
      else
        print('未知的Node类型:$type      json:$json');
    }
    if (formId != null && type != WidgetName.button)
      config?.controller
          ?.setEmptyCallback(formId, () => node!.isDataEmpty, node.hashCode);
    if (isRoot) {
      config?.controller?.rootNode = node as ColumnNode?;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        config?.controller?.refreshAllButton();
      });
      // config?.controller.refreshAllButton();
    }
    return node ?? ContainerNode(null);
  }

  WidgetNode toColumn(
    Map json,
    RootParam rootParam, {
    NodeCallback? nodeCallback,
    Function? buttonCallback,
    TempWidgetConfig? config,
  }) {
    final List childrenJson = json[JsonName.children] ?? [];
    final List<WidgetNode> children = [];
    final columnNode = ColumnNode(null, rootParam: rootParam, config: config);
    childrenJson.forEach((element) {
      children.add(toNode(
        element,
        parentNode: columnNode,
        nodeCallback: nodeCallback,
        buttonCallback: buttonCallback,
        config: config,
      ));
    });
    columnNode.children = children;
    return columnNode;
  }

  ///--------------TITLE--------------///
  WidgetNode toTitle(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      TitleNode(TitleData.fromJson(json), config: config);

  WidgetNode toVoteTitle(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      VoteTitleNode(VoteTitleData.fromJson(json), config: config);

  WidgetNode toIconTitle(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) {
    final text = json[JsonName.text] ?? '';
    final icon = json[JsonName.icon] ?? '';
    final line = json[JsonName.line] ?? IconTitleData.multiLine;
    final status = json[JsonName.status] ?? IconTitleData.statusNull;
    return IconTitleNode(
      IconTitleData(text, icon, line: line, status: status),
      rootParam: rootParam,
      config: config,
    );
  }

  WidgetNode toIconBgTitle(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) {
    final text = json[JsonName.text] ?? '';
    final icon = json[JsonName.icon] ?? '';
    final bg = json[JsonName.bg] ?? IconTitleData.bgOne;
    final line = json[JsonName.line] ?? IconTitleData.multiLine;
    final textColorHex = json[JsonName.textColorHex];
    final bgColorHex = json[JsonName.bgColorHex];
    return IconTitleNode(
        IconTitleData(text, icon,
            type: WidgetName.iconBgTitle,
            bg: bg,
            line: line,
            textColorHex: textColorHex,
            bgColorHex: bgColorHex),
        config: config,
        rootParam: rootParam);
  }

  ///--------------TEXT--------------///
  WidgetNode toText(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      TextNode(
        TextData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  WidgetNode toHintText(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      HintTextNode(
        HintTextData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  WidgetNode toTitleText(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      TitleTextNode(
        TitleTextData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  WidgetNode toMultiText(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      MultiTextNode(
        MultiTextData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  WidgetNode toContentText(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      ContentTextNode(
        ContentTextData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  WidgetNode toVoteText(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      VoteTextNode(
        VoteTextData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  ///--------------RADIO--------------///
  WidgetNode toRadio(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      RadioNode(
        RadioData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  ///--------------INPUT--------------///
  WidgetNode toInput(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      InputNode(
        InputData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  ///--------------Divider--------------///
  WidgetNode toDivider({TempWidgetConfig? config}) =>
      DividerNode(config: config);

  WidgetNode toGapDivider(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      GapDividerNode(
        GapDividerData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  ///--------------Button--------------///
  WidgetNode toDropdown(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      DropdownButtonNode(
        DropdownData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );

  WidgetNode toButton(
    Map json,
    RootParam rootParam, {
    Function? buttonCallback,
    TempWidgetConfig? config,
  }) =>
      ButtonNode(
        ButtonData.fromJson(json),
        rootParam: rootParam,
        buttonCallback:
            buttonCallback as Future<dynamic> Function(ButtonCallbackParam)?,
        config: config,
      );

  ///--------------Image--------------///
  WidgetNode toImage(
    Map json,
    RootParam rootParam, {
    TempWidgetConfig? config,
  }) =>
      ImageNode(
        ImageData.fromJson(json),
        rootParam: rootParam,
        config: config,
      );
}

typedef Function NodeCallback(String type, String? id, Map param);
