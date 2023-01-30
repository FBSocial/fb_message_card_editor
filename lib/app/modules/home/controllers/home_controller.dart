import 'dart:convert';
import 'dart:math';

import 'package:fb_message_card_editor/app/modules/home/bean/input_bean.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_editor/json_editor.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  String updateDynamicWidget = 'updateDynamicWidget';
  String updateShowJsonMap = 'updateShowJsonMap';
  String updateItemList = 'updateItemList';

  Map<String, dynamic>? showMap;
  List<InputItem>? showItemList;

  DynamicWidgetContent? dynamicWidgetContent;

  void increment() => count.value++;
  static const String jsonPath = "assets/json";
  static const String childPath = "$jsonPath/child";

  @override
  void onInit() {
    super.onInit();
    _getShowJson();
    _getdata();
  }

  _getShowJson() async {
    String showString =
        await rootBundle.loadString("$jsonPath/vote_start.json");
    showMap = jsonDecode(showString);
    dynamicWidgetContent = DynamicWidgetContent.fromJson(showMap ?? {});
    update([updateDynamicWidget]);
  }

  _getdata() async {
    String data = await rootBundle.loadString("$jsonPath/data.json");
    print("....." + data);
    InputType inputType = InputType.fromJson(jsonDecode(data));
    showItemList = inputType.children;
    print("....." + showItemList.toString());
    update([updateItemList, updateShowJsonMap]);
  }

  addChildItem(InputChild child) async {
    String data = await rootBundle.loadString("$childPath/${child.file}");
    dynamicWidgetContent?.children?.add(data);
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  updateShowMap(JsonElement element) {
    Map<String, dynamic>? temp = jsonDecode(element.toString());
    if (temp.toString().length != showMap.toString().length) {
      showMap = temp;
      update([updateDynamicWidget, updateShowJsonMap]);
    }
  }
}

class DynamicWidgetContent {
  String? type;
  List<String>? children;

  DynamicWidgetContent({this.type, this.children});

  factory DynamicWidgetContent.fromJson(Map<String, dynamic> json) {
    List<String> result = [];
    if (json.containsKey('children')) {
      List temp = json["children"];
      for (var element in temp) {
        result.add(jsonEncode(element));
      }
    }

    return DynamicWidgetContent(
      type: json["type"],
      children: result,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> result = [];
    children?.forEach((element) {
      result.add(jsonDecode(element));
    });
    return {'type': this.type, 'children': result};
  }
}
