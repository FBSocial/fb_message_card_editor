import 'dart:convert';

import 'package:dynamic_card/dynamic_card.dart';
import 'package:dynamic_card/widgets/widget_config/widget_config.dart';
import 'package:fb_message_card_editor/app/modules/home/views/card_preview_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  final String jsonString =
      "{\"type\":\"column\",\"children\": [{\"param\": {\"image\": \"https://fanbook-gamescluster-1251001060.file.myqcloud.com/tetris-game/5e2a1029-8770-485d-84cd-0f52cbaac027.png\",\"type\": 2},\"type\":\"image\"}, {\"type\": \"button\",\"param\": {\"list\": [{\"type\": 3,\"text\":\"我要挑战\",\"event\": {\"method\":\"mini_program\",\"param\": {\"appId\": \"https://open.fanbook.mobi/mp/138519745866498048/273383374205222914/v1?a=1669969724423\"}}}]}}]}";

  @override
  Widget build(BuildContext context) {
    Map? tempMap = jsonDecode(jsonString);
    return LayoutBuilder(builder: (context, constrains) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: Center(
          child: DynamicWidget(
              json: tempMap,
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
                      widgetWith: kIsWeb ? 400 : constrains.maxWidth))),
        ),
      );
    });
  }
}
