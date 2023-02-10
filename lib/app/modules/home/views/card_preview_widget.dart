import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dynamic_card/dynamic_card.dart';
import 'package:dynamic_card/widgets/title/vote_title.dart';
import 'package:fb_message_card_editor/app/modules/home/bindings/delete_notify.dart';
import 'package:fb_message_card_editor/theme/app_theme.dart';
import 'package:fb_message_card_editor/util/mouse_hover_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class DynamicWidget extends StatefulWidget {
  final Map? json;

  final DynamicController? controller;
  final TempWidgetConfig? config;
  final DynamicWidgetItemClick? itemClick;
  final bool onlyRead;
  final bool showMouse;
  final bool canDrag;
  final bool removeOverlay;

  const DynamicWidget({
    Key? key,
    required this.json,
    this.controller,
    this.config,
    this.canDrag = false,
    this.onlyRead = false,
    this.showMouse = false,
    this.removeOverlay = false,
    this.itemClick,
  }) : super(key: key);

  @override
  State createState() => _DynamicWidgetState();
}

typedef DynamicWidgetItemClick = void Function(
    OptType opt, int index, int newIndex);

class _DynamicWidgetState extends State<DynamicWidget> {
  WidgetNode? _node;
  late Map json;
  final nodeController = NodeController();

  @override
  void initState() {
    json = widget.json ?? {};
    initialNode(json);
    widget.controller?._nodeCallback = getNode;
    _remove();
    initListener();
    super.initState();
  }

  initListener(){
    RemoveOverlayNotifier.instance.listen((event) {
      _remove();
    });
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
    if (json != widget.json) {
      json = widget.json ?? {};
      initialNode(json);
    }
    return buildWidget();
  }

  @override
  void didUpdateWidget(DynamicWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  List<GlobalKey> itenGlobalKeyList = [];
  OverlayEntry? mOverlayEntry;
  int currentIndex = -1;
  bool currentIsImageWidget = false;

  Widget buildWidget() {
    try {
      itenGlobalKeyList.clear();
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

        if (widget.showMouse) {
          final List<Widget> mouseChildren = [];
          for (int index = 0; index < columnChildren.length; index++) {
            GlobalKey itemKey = GlobalKey();
            itenGlobalKeyList.add(itemKey);

            Widget child = columnChildren[index];
            bool isImageWidget = child is ImageWidget;

            Widget childContainer = Listener(
                onPointerDown: (event) {
                  currentIsImageWidget = isImageWidget;
                  _showOverlayEntry(index, isImageWidget);
                },
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: AbsorbPointer(
                    absorbing: false,
                    child: columnChildren[index],
                  ),
                ));

            Widget onItem = currentIndex == index
                ? _dotted(childContainer)
                : childContainer;

            if (currentIndex == index && isImageWidget) {
              onItem = Stack(
                children: [
                  onItem,
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: TextButton(
                        child: Container(
                          height: 30,
                          color: Colors.black12.withOpacity(0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text(
                                '更换图片',
                                style: appThemeData.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          _remove();
                          CardOnTapNotification(OptType.modifyImage, index)
                              .dispatch(context);
                        },
                      ))
                ],
              );
            }

            Widget mouse = Container(
              color: Colors.white,
              child: MouseHoverStatefulBuilder(
                  key: itemKey,
                  builder: (BuildContext context, bool hover) {
                    return Stack(
                      children: <Widget>[
                        hover ? _dotted(onItem) : onItem,
                      ],
                    );
                  }),
            );

            Widget ikey = Container(
              padding: const EdgeInsets.only(right: 40),
              key: ValueKey(columnChildren[index].hashCode),
              child: mouse,
            );
            mouseChildren.add(ikey);
          }
          resultWidget.children!.clear();
          resultWidget.children!.addAll(mouseChildren);
          if (widget.canDrag) {
            return ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: _scroll(ReorderableListView(
                  buildDefaultDragHandles: true,
                  children: resultWidget.children!,
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    currentIndex = -1;
                    _remove();
                    if (widget.itemClick != null) {
                      widget.itemClick!(OptType.replase, oldIndex, newIndex);
                    }
                    setState(() {});
                  },
                )));
          }
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

  _dotted(Widget childContainer) {
    return Container(
      decoration: DottedDecoration(
        color: Colors.blue,
        shape: Shape.box,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: childContainer,
    );
  }

  _scroll(Widget child) {
    return NotificationListener(
        onNotification: (ScrollNotification notification) {
          //开始滚动
          if (notification is ScrollStartNotification) {
            print("开始滚动");
            _remove();
          } else if (notification is ScrollUpdateNotification) {
            // 更新滚动
          } else if (notification is ScrollEndNotification) {
            //结束滚动
            print("结束滚动");
            if (currentIndex > -1) {
              _showOverlayEntry(currentIndex, currentIsImageWidget);
            }
          }
          // 返回值是防止冒泡， false是可以冒泡
          return true;
        },
        child: child);
  }

  _remove() {
    if (mOverlayEntry != null) {
      currentIndex = -1;
      try {
        mOverlayEntry?.remove();
      } catch (e) {
        print(e);
      }
    }
  }

  _showOverlayEntry(int index, bool isImageWidget) {
    _remove();
    setState(() {
      currentIndex = index;
    });
    GlobalKey item = itenGlobalKeyList[index];
    if (item.currentContext != null) {
      final RenderBox renderBox =
          item.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      Offset position = renderBox.localToGlobal(Offset.zero);
      mOverlayEntry = OverlayEntry(builder: (context) {
        return Stack(children: <Widget>[
          Positioned(
              top: position.dy - 40,
              left: position.dx,
              child: _deleteItem(index)),
          // if (isImageWidget)
          //   Positioned(
          //       top: position.dy - 40,
          //       left: position.dx + size.width - 40,
          //       child: _changeItem(index)),
        ]);
      });
      Overlay.of(Get.context!)?.insert(mOverlayEntry!);
    }
  }

  _deleteItem(int index) => Container(
        width: 40,
        height: 40,
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          tooltip: '删除',
          onPressed: () {
            // CardOnTapNotification(
            //         OptType.remove, index)
            //     .dispatch(context);
            _remove();
            if (widget.itemClick != null) {
              widget.itemClick!(OptType.remove, index, 0);
            }
          },
        ),
      );

  _changeItem(int index) => Container(
        width: 40,
        height: 40,
        child: IconButton(
          icon: const Icon(Icons.edit_note, color: Colors.amberAccent),
          tooltip: '更换',
          onPressed: () {
            _remove();
            CardOnTapNotification(OptType.modifyImage, index).dispatch(context);
          },
        ),
      );

  // _upItem(int index) => Container(
  //       width: 40,
  //       height: 40,
  //       child: IconButton(
  //         icon: const Icon(Icons.upload_sharp, color: Colors.greenAccent),
  //         tooltip: '删除',
  //         onPressed: () {
  //           // CardOnTapNotification(
  //           //         OptType.remove, index)
  //           //     .dispatch(context);
  //           if (widget.itemClick != null) {
  //             widget.itemClick!(OptType.up, index);
  //           }
  //         },
  //       ),
  //     );

  // _downItem(int index) => Container(
  //       width: 40,
  //       height: 40,
  //       child: IconButton(
  //         icon: const Icon(Icons.download, color: Colors.greenAccent),
  //         tooltip: '删除',
  //         onPressed: () {
  //           // CardOnTapNotification(
  //           //         OptType.remove, index)
  //           //     .dispatch(context);
  //           if (widget.itemClick != null) {
  //             widget.itemClick!(OptType.down, index);
  //           }
  //         },
  //       ),
  //     );

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

enum OptType {
  remove, // 移除
  up, // 上移
  down, // 下移动
  modifyImage, // 下移动
  replase, // 下移动
}

class CardOnTapNotification extends Notification {
  OptType opt;
  int index;

  CardOnTapNotification(this.opt, this.index);
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
      EasyLoading.showInfo("打开小程序");
      break;
    case FunctionName.openHtmlPage:
      EasyLoading.showInfo("打开html");

      break;
    case FunctionName.requestBotApi:
      EasyLoading.showInfo("打开机器人");
      break;
    case FunctionName.detailPage:
      EasyLoading.showInfo("打开详情页");
      break;
    case FunctionName.request:
      EasyLoading.showInfo("发送请求");
      break;
  }
}
