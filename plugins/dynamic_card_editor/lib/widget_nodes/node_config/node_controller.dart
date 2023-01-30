import 'package:dynamic_card/ast/all.dart';
import 'package:flutter/material.dart';

import '../all.dart';

class NodeController {
  ///用于存放FormButton的ValueNotifier, key为formId, value为ValueNotifier
  ///值为true表示不可以点击，为false表示可点击，默认为false
  final Map<String, ValueNotifier<bool>> _formButtonMap = {};

  final Map<String, ValueNotifier<bool>> _formItemEnablenMap = {};

  ColumnNode? rootNode;

  ValueNotifier<bool>? getButtonNotifier(String? id) {
    if (id == null || id.isEmpty) return null;
    ValueNotifier<bool>? result = _formButtonMap[id];
    if (result == null) result = ValueNotifier(false);
    _formButtonMap[id] = result;
    return result;
  }

  ValueNotifier<bool> getItemEnableNotifier(String id) {
    // if (id == null || id.isEmpty) return null;
    ValueNotifier<bool>? result = _formItemEnablenMap[id];
    if (result == null) result = ValueNotifier(true);
    _formItemEnablenMap[id] = result;
    return result;
  }

  ValueNotifier<bool>? getRealButtonNotifier(String? id) {
    if (id == null || id.isEmpty) return null;
    return _formButtonMap[id];
  }

  void changeButtonValue(String? id, bool value) {
    if (id == null || id.isEmpty) return;
    final result = _formButtonMap[id];
    if (result == null) return;
    result.value = value;
  }

  ///用于存放Form组件，当FormButton点击时来禁用这些组件的交互, key为formId, value为ValueNotifier
  ///值为true表示不可以交互，为false表示可交互，默认为false
  final Map<String, ValueNotifier<bool>> _formWidgetMap = {};

  ValueNotifier<bool>? getFormNotifier(String id) {
    if (id.isEmpty) return null;
    ValueNotifier<bool>? result = _formWidgetMap[id];
    if (result == null) result = ValueNotifier(false);
    _formWidgetMap[id] = result;
    return result;
  }

  void changeFormValue(String? id, bool value) {
    if (id == null || id.isEmpty) return;
    final result = _formWidgetMap[id];
    if (result == null) return;
    result.value = value;
  }

  ///用于存放formId对应的表单组件是否有数据
  ///值为true表示表单为空，为false表示不为空
  final Map<String, Map<int, FormEmptyCallback>> _formEmptyMap = {};

  void setEmptyCallback(
      String id, FormEmptyCallback callback, int callbackHashcode) {
    if (id.isEmpty) return;
    Map<int, FormEmptyCallback>? map = _formEmptyMap[id];
    if (map == null) map = {};
    map[callbackHashcode] = callback;
    _formEmptyMap[id] = map;
  }

  Map<int, FormEmptyCallback>? getEmptyCallback(String id) {
    if (id.isEmpty) return null;
    return _formEmptyMap[id];
  }

  void removeForm(String id, WidgetNode node) {
    _formButtonMap.remove(id);
    _formWidgetMap.remove(id);
    final formEmptyValueMap = _formEmptyMap[id] ?? {};
    formEmptyValueMap.remove(node.hashCode);
    refreshButtonValue(id);
  }

  void refreshButtonValue(String? id) {
    if (id == null || id.isEmpty) return;
    bool isFormEmpty = false;
    getEmptyCallback(id)?.forEach((key, value) {
      final callResult = value.call();
      if (callResult) isFormEmpty = true;
    });
    changeButtonValue(id, isFormEmpty);
  }

  void refreshAllButton() {
    _formEmptyMap.forEach((key, value) {
      refreshButtonValue(key);
    });
  }

  void dispose() {
    _formButtonMap.clear();
    _formWidgetMap.clear();
    _formEmptyMap.clear();
    _formItemEnablenMap.clear();
  }

  void clearCallback() => _formEmptyMap.clear();
}

typedef FormEmptyCallback = bool Function();
