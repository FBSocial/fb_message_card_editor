import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:cross_file/cross_file.dart';
import 'package:date_format/date_format.dart';
import 'package:fb_message_card_editor/app/modules/home/bean/input_bean.dart';
import 'package:fb_message_card_editor/app/modules/login/api/User_Api.dart';
import 'package:fb_message_card_editor/http/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:json_editor/json_editor.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/config/sp_service.dart';

import '../../../../http/upload/upload.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final count = 0.obs;
  String updateDynamicWidget = 'updateDynamicWidget';
  String updateShowJsonMap = 'updateShowJsonMap';
  String updateItemList = 'updateItemList';

  String updateImage = 'updateImage';
  String updateSaveWidget = 'updateSaveWidget';

  Map<String, dynamic>? showMap;
  String? mPreViewTitle;
  List<InputItem>? showItemList;
  String? uploadImageUrl;
  DynamicWidgetContent? dynamicWidgetContent;

  void increment() => count.value++;
  static const String jsonPath = "assets/json";
  static const String childPath = "$jsonPath/child";

  List spList = ["参考模版", "模版组件", "我的卡片"];
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController =
        TabController(initialIndex: 1, length: spList.length, vsync: this);
    _getShowJson();
    _getdata();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
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
    InputType inputType = InputType.fromJson(jsonDecode(data));
    showItemList = inputType.children;
    update([updateItemList, updateShowJsonMap]);
  }

  Future<List<InputChild>> getMasterPlate() async {
    String data = await rootBundle.loadString("$jsonPath/masterplate.json");
    Map json = jsonDecode(data);
    List<InputChild> result = [];
    if (json.containsKey('children')) {
      List temp = json["children"];
      for (var element in temp) {
        result.add(InputChild.fromJson(element));
      }
    }
    return result;
  }

  Future<List<InputChild>> getSave() async {
    final jsonStr = SpService.instance.getString(SP.userSaveMasterPlate);
    List<InputChild> result = [];
    if (jsonStr != null && jsonStr.isNotEmpty) {
      Map json = jsonDecode(jsonStr);
      if (json.containsKey('children')) {
        List temp = json["children"];
        for (var element in temp) {
          InputChild inputChild = InputChild.fromJson(element);
          result.add(inputChild);
        }
      }
    }
    return result;
  }

  int saveIndex = -1;

  save() async {
    List<InputChild> childList = await getSave();
    childList ??= [];
    InputChild inputChild;
    if (saveIndex >= 0) {
      inputChild = childList[saveIndex];
      inputChild.file = jsonEncode(showMap);
      childList.removeAt(saveIndex);
      childList.insert(saveIndex, inputChild);
    } else {
      inputChild = InputChild(
          file: jsonEncode(showMap),
          text: "创建于 ${formatDate(DateTime.now(), [
                yyyy,
                "年".tr,
                m,
                "月".tr,
                d,
                "日 ".tr,
                HH,
                ":",
                nn
              ])}");
      childList.add(inputChild);
    }
    Map<String, dynamic> result = {};
    result['children'] = childList;
    SpService.instance.setString(SP.userSaveMasterPlate, jsonEncode(result));

    update([updateSaveWidget]);
  }

  Future<Map<String, dynamic>?> getMasterPlateFile(String file) async {
    String data = await rootBundle.loadString("$jsonPath/$file");
    Map<String, dynamic>? temp = jsonDecode(data);
    return temp;
  }

  changgeRoot(Map<String, dynamic> root) {
    showMap = root;
    dynamicWidgetContent = DynamicWidgetContent.fromJson(showMap ?? {});
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  addChildItem(InputChild child) async {
    String data = await rootBundle.loadString("$childPath/${child.file}");
    dynamicWidgetContent?.children?.add(data);
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  removeAll() {
    dynamicWidgetContent?.children?.clear();
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  sendToMe() async {
    var chat = await UserApi.getChatId();
    print('chat:$chat');

    var result = await UserApi.sendPreView(chat['id'], showMap!);
    print('result:$result');

    EasyLoading.showSuccess('发送成功');
  }

  sendToGuild() async {
    var result = await UserApi.sendPreView(436889889649201152, showMap!);
    print('result:$result');
    EasyLoading.showSuccess('发送成功');
  }

  logout() async {
    Global.user = LocalUser();
    Config.token = '';
  }

  removeIndex(int index) {
    dynamicWidgetContent?.children?.removeAt(index);
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  updateShowMap(JsonElement element) {
    Map<String, dynamic>? temp = jsonDecode(element.toString());
    if (temp.toString().hashCode != showMap.toString().hashCode) {
      showMap = temp;
      dynamicWidgetContent = DynamicWidgetContent.fromJson(showMap ?? {});
      update([updateDynamicWidget]);
    }
  }

  copyValue() {
    FlutterClipboard.copy(jsonEncode(showMap))
        .then((value) => EasyLoading.showSuccess('已复制！'));
  }

  void upIndex(int index) {
    if (index == 0) {
      return;
    }
    String? up = dynamicWidgetContent?.children![index - 1];
    String? self = dynamicWidgetContent?.children![index];

    dynamicWidgetContent?.children![index - 1] = self ?? "";
    dynamicWidgetContent?.children![index] = up ?? "";
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  void downIndex(int index) {
    if (index == dynamicWidgetContent?.children!.length) {
      return;
    }
    String? down = dynamicWidgetContent?.children![index + 1];
    String? self = dynamicWidgetContent?.children![index];

    dynamicWidgetContent?.children![index + 1] = self ?? "";
    dynamicWidgetContent?.children![index] = down ?? "";
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
  }

  void modifyImage(int index) {}

  Future<void> uploadImage(XFile file, int index) async {
    EasyLoading.show(status: '上传中');
    try {
      Uint8List byte = await file.readAsBytes();
      String? avatar = await uploadFileIfNotExist(
          bytes: byte, fileType: "headImage", filename: file.name);
      if (avatar != null && avatar.isNotEmpty) {
        uploadImageUrl = avatar;
        print('avatar:$avatar');
        String? value = dynamicWidgetContent?.children![index];
        Map json = jsonDecode(value!);
        json['param']['image'] = avatar;
        dynamicWidgetContent?.children![index] = jsonEncode(json);
        showMap = dynamicWidgetContent?.toJson();
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
    update([updateDynamicWidget, updateShowJsonMap, updateImage]);
  }

  void replease(int oldIndex, int newIndex) {
    final topic = dynamicWidgetContent?.children!.removeAt(oldIndex);
    dynamicWidgetContent?.children!.insert(newIndex, topic!);
    showMap = dynamicWidgetContent?.toJson();
    update([updateDynamicWidget, updateShowJsonMap]);
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
