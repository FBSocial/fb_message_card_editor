import 'package:dynamic_card/dynamic_card.dart';
import 'package:dynamic_card/widgets/title/vote_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DynamicWidget extends StatefulWidget {
  final Map? json;

  final DynamicController? controller;
  final TempWidgetConfig? config;
  final bool onlyRead;

  const DynamicWidget({
    Key? key,
    required this.json,
    this.controller,
    this.config,
    this.onlyRead = false,
  }) : super(key: key);

  @override
  State createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  WidgetNode? _node;

  final nodeController = NodeController();

  @override
  void initState() {
    final json = widget.json ?? {};
    initialNode(json);
    widget.controller?._nodeCallback = getNode;

    super.initState();
  }

  void initialNode(Map json) {
    final config = widget.config?.copy(controller: nodeController);
    try {
      _node = JsonToNodeParser.instance.toNode(
        json,
        buttonCallback: (event) {
          MessageOnTapNotification().dispatch(context);
          onClick(event);
          return Future.value(null);
        },
        config: config,
        isRoot: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('动态卡片转换错误:$e');
      }
    }
  }

  @override
  void dispose() {
    nodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  @override
  void didUpdateWidget(DynamicWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget buildWidget() {
    try {
      if (_node == null) return Container();
      final resultWidget = widgetVisitor.visitNode(_node!);
      if (resultWidget is ColumnWidget) {
        final columnChildren = resultWidget.children ?? [];
        if (columnChildren.isEmpty) return resultWidget;
        final List<Widget> children = [];
        final first = columnChildren.first;
        final needPadding = !isTitle(first);
        if (widget.onlyRead) {
          for (var child in columnChildren) {
            children.add(canTap(child) ? child : AbsorbPointer(child: child));
          }
          resultWidget.children!.clear();
          resultWidget.children!.addAll(children);
        }
        if (needPadding) {
          resultWidget.children?.insert(0, const SizedBox(height: 8));
        }
      } else if (resultWidget is! ButtonWidget && widget.onlyRead) {
        return AbsorbPointer(child: resultWidget);
      }
      return resultWidget;
    } catch (e) {
      if (kDebugMode) {
        print('动态卡片解析错误:$e');
      }
      return Container(
        width: 100,
        height: 100,
        color: Colors.red,
      );
    }
  }

  WidgetNode? getNode() => _node;

  bool canTap(Widget widget) =>
      widget is ButtonWidget ||
      widget is TextWidget ||
      widget is ContentTextWidget;

  bool isTitle(Widget widget) =>
      widget is TitleWidget ||
      widget is IconTitleWidget ||
      widget is VoteTitleWidget;
}

class DynamicController {
  WidgetNode? Function()? _nodeCallback;

  void dispose() {
    _nodeCallback = null;
  }

  WidgetNode? getNode() {
    return _nodeCallback?.call();
  }
}

final widgetVisitor = DynaWidgetVisitor();

class FunctionName {
  static const String openMiniProgram = 'mini_program';
  static const String openHtmlPage = 'html_page';
  static const String requestBotApi = 'bot_api';
  static const String detailPage = 'detail_page';
  static const String request = 'request';
}

class MessageOnTapNotification extends Notification {
  MessageOnTapNotification();
}

class ParamName {
  static const String url = 'url';
  static const String appId = 'appId';
  static const String callbackData = 'callback_data';
  static const String data = 'data';
  static const String title = 'title';
  static const String extParam = 'ext_param';
  static const String fbParam = 'fb_param';
  static const String messageId = 'message_id';
  static const String userId = 'user_id';
  static const String clientId = 'client_user_id';
  static const String formId = 'form_id';
  static const String nickname = 'nickname';
  static const String avatar = 'avatar';
}

void onClick(ButtonCallbackParam btnParam) {
  if (btnParam.event == null || btnParam.event!.method == null) return;
  // final param = btnParam.event!.param ?? {};
  switch (btnParam.event!.method) {
    case FunctionName.openMiniProgram:
      break;
    case FunctionName.openHtmlPage:
      break;
    case FunctionName.requestBotApi:
      break;
    case FunctionName.detailPage:
      break;
    case FunctionName.request:
      break;
  }
}
