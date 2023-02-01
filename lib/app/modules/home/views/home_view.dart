import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dynamic_card/dynamic_card.dart';
import 'package:fb_message_card_editor/app/modules/home/bean/input_bean.dart';
import 'package:fb_message_card_editor/app/modules/home/views/card_preview_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  static const double leftWidth = 330;
  static const double centerWidth = 400;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Scaffold(
        body: Row(
          children: [
            _leftView(),
            _centerView(_centerDynamicWidget(context, constrains)),
            _rightView(_rightJsonWidget())
          ],
        ),
      );
    });
  }

  _dynamicWidget(BuildContext context, Map<String, dynamic>? map) {
    return DynamicWidget(
        json: map,
        config: TempWidgetConfig(
            radioConfig: RadioConfig(
              singleSelected: Icon(
                Icons.radio_button_on,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              groupSelected: Icon(
                Icons.radio_button_on_sharp,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            buttonConfig: ButtonConfig(
              dropdownConfig: DropdownConfig(
                dropdownIcon: () =>
                    const Icon(Icons.arrow_drop_down, color: color3),
              ),
            ),
            commonConfig: CommonConfig(
                widgetWith: Platform.isMacOS || kIsWeb ? 300 : 100)));
  }

  _centerView(Widget child) => Container(
        padding: const EdgeInsets.all(20),
        width: centerWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _deleteBtn(),
              Row(
                children: [
                  _sendToMeBtn(),
                  const SizedBox(width: 10),
                  _sendToGuildBtn(),
                ],
              )
            ]),
            const SizedBox(height: 10),
            const Text('卡片预览'),
            _dividerW(),
            Expanded(child: child)
          ],
        ),
      );

  _deleteBtn() => buildMaterialButton('清空', controller.removeAll);

  _sendToMeBtn() => buildMaterialButton('向我发送预览', controller.sendToMe);

  _sendToGuildBtn() => buildMaterialButton('发送到服务器', controller.sendToGuild,
      bgColor: const Color(0xFF198CFE), txtColor: Colors.white);

  MaterialButton buildMaterialButton(String text, VoidCallback onPress,
          {Color bgColor = Colors.white,
          Color txtColor = const Color(0xFF1A2033)}) =>
      MaterialButton(
        color: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: const Color(0xFF1A2033).withOpacity(0.2),
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        height: 38,
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: txtColor),
        ),
      );

  _dividerW() => Container(
        color: Colors.grey.withOpacity(0.5),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        width: 400,
        height: 0.5,
      );

  _divider() => Container(
        color: Colors.grey.withOpacity(0.5),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        height: 0.5,
      );

  _centerDynamicWidget(BuildContext context, constrains) =>
      GetBuilder<HomeController>(
        id: controller.updateDynamicWidget,
        builder: (c) {
          Widget result = SingleChildScrollView(
            child: DynamicWidget(
                showMouse: true,
                json: controller.showMap,
                config: TempWidgetConfig(
                    radioConfig: RadioConfig(
                      singleSelected: Icon(
                        Icons.radio_button_on,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      groupSelected: Icon(
                        Icons.radio_button_on_sharp,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    buttonConfig: ButtonConfig(
                      dropdownConfig: DropdownConfig(
                        dropdownIcon: () =>
                            const Icon(Icons.arrow_drop_down, color: color3),
                      ),
                    ),
                    commonConfig: CommonConfig(
                        widgetWith: Platform.isMacOS || kIsWeb
                            ? centerWidth
                            : constrains.maxWidth))),
          );
          return NotificationListener(
            child: result,
            onNotification: (n) {
              if (n is CardOnTapNotification) {
                if (n.opt == OptType.remove) {
                  controller.removeIndex(n.index);
                } else if (n.opt == OptType.up) {
                  controller.upIndex(n.index);
                } else if (n.opt == OptType.down) {
                  controller.downIndex(n.index);
                }
                return true;
              }
              return false;
            },
          );
        },
      );

  _rightView(Widget child) => Expanded(
          child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('卡片编辑'),
                IconButton(
                  icon: const Icon(Icons.copy_all_outlined,
                      color: Colors.cyanAccent),
                  tooltip: '复制Json',
                  onPressed: () {
                    controller.copyValue();
                  },
                )
              ],
            ),
            _divider(),
            child
          ],
        ),
      ));

  _rightJsonWidget() => GetBuilder<HomeController>(
      id: controller.updateShowJsonMap,
      builder: (c) {
        return Expanded(
            child: JsonEditorTheme(
                themeData: JsonEditorThemeData.defaultTheme(),
                child: JsonEditor.object(
                  object: controller.showMap,
                  onValueChanged: (value) {
                    if (kDebugMode) {
                      print(value);
                    }
                    controller.updateShowMap(value);
                  },
                )));
      });

  _leftView() {
    final tabs = Container(
      height: 48,
      width: leftWidth,
      color: Colors.white,
      child: SizedBox(
        height: 32,
        child: TabBar(
          indicatorWeight: 0,
          tabs: controller.spList
              .map((e) =>
                  Tab(child: Text(e, style: const TextStyle(fontSize: 14))))
              .toList(),
          labelColor: Colors.blueAccent,
          unselectedLabelColor: const Color(0xFF5C6273).withOpacity(0.8),
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: Colors.blueAccent),
          ),
          indicatorPadding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        ),
      ),
    );
    final tabBarView = Container(
      width: leftWidth,
      color: Colors.white,
      child: TabBarView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _materWidget(),
          _leftWidget(),
          Row(),
        ],
      ),
    );

    return Column(children: [tabs, Expanded(child: tabBarView)]);
  }

  _materWidget() => SingleChildScrollView(
        child: FutureBuilder(
          future: controller.getMasterPlate(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return SizedBox();
            return Wrap(
              children: snapshot.data!
                  .map((e) => FutureBuilder(
                      future: controller.getMasterPlateFile(e.file ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return SizedBox();
                        return GestureDetector(
                          onTap: () {
                            controller.changgeRoot(snapshot.data!);
                          },
                          child: Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.text ?? ""),
                                SizedBox(
                                  height: 10,
                                ),
                                _dynamicWidget(context, snapshot.data),
                                _divider()
                              ],
                            ),
                          ),
                        );
                      }))
                  .toList(),
            );
          },
        ),
      );

  _leftWidget() => GetBuilder<HomeController>(
      id: controller.updateDynamicWidget,
      builder: (c) {
        return SizedBox(
          width: Platform.isMacOS || kIsWeb ? 280 : 200,
          child: ListView.builder(
              itemCount: controller.showItemList?.length,
              itemBuilder: (context, index) {
                InputItem? item = controller.showItemList?[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          getIconData(item?.type ?? ""),
                          color: getRandColor(index),
                          size: 55,
                        ),
                        Text(item?.text ?? "",
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                    if (item != null && item.children != null) ...[
                      Column(
                        children: item.children!
                            .map((child) => Container(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        controller.addChildItem(child);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            getIconData(child.type ?? ""),
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                          Text(child.text ?? "",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87))
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    ]
                  ],
                );
              }),
        );
      });

  IconData getIconData(String type) {
    switch (type) {
      case "text":
        return Icons.text_fields;
      case "image":
        return Icons.image;
      case "title":
        return Icons.title;
      case "radio":
        return Icons.radio_button_on;
      case "input":
        return Icons.picture_in_picture;
      case "divider":
        return Icons.safety_divider;
      case "button":
        return Icons.smart_button;
    }
    return Icons.add;
  }

  Color getRandColor(int index) {
    List colors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.tealAccent,
      Colors.purple,
      Colors.cyanAccent,
      Colors.teal,
      Colors.deepOrange,
      Colors.lightBlueAccent,
      Colors.limeAccent,
      Colors.deepPurple,
      Colors.amberAccent,
      Colors.amber
    ];
    if (index >= colors.length) index = 0;

    // index = Random().nextInt(colors.length);
    return colors[index];
  }
}
