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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _leftWidget(),
              const SizedBox(width: 20),
              _centerDynamicWidget(context, constrains),
              const SizedBox(width: 20),
              _rightJsonWidget()
            ],
          ),
        ),
      );
    });
  }

  _centerDynamicWidget(BuildContext context, constrains) =>
      GetBuilder<HomeController>(
        id: controller.updateDynamicWidget,
        builder: (c) {
          return SingleChildScrollView(
            child: DynamicWidget(
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
                            ? 400
                            : constrains.maxWidth))),
          );
        },
      );

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
