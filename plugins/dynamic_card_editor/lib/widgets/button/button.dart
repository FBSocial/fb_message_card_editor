import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';
import 'disable_button_item.dart';
import 'form_button_item.dart';
import 'normal_button_item.dart';
import 'text_button_item.dart';

class ButtonWidget extends StatelessWidget {
  final ButtonData data;
  final ButtonCallback? callback;
  final TempWidgetConfig? config;
  final RootParam? rootParam;

  const ButtonWidget(
      {Key? key,
      required this.data,
      this.callback,
      this.config,
      this.rootParam})
      : super(key: key);

  List<ButtonDetailData> get list => data.list ?? [];

  bool get isFormButton => formId?.isNotEmpty ?? false;

  String? get formId => rootParam?.formId;

  double get mw => config?.defaultWidth ?? defaultWidth;

  @override
  Widget build(BuildContext context) => getLayout();

  Widget getLayout() {
    return Container(
      color: Colors.white,
      width: mw,
      child: LayoutBuilder(builder: (context, constrains) {
        return Row(
          children: List.generate(list.length, (index) {
            final cur = list[index];
            final disable = cur.enable == ButtonDetailData.disableClick;
            if (!isFormButton || disable)
              return buildButtonItem(cur, index, constrains,
                  disableClick: disable);
            return FormButtonItem(
                formId: formId,
                formBuilder: (value) {
                  return buildButtonItem(cur, index, constrains,
                      disableClick: value);
                },
                nodeController: config?.controller);
          }),
        );
      }),
    );
  }

  Widget buildButtonItem(
      ButtonDetailData cur, int index, BoxConstraints constrains,
      {bool disableClick = false}) {
    Widget? button;
    switch (cur.type) {
      case ButtonDetailData.colorButton:
      case ButtonDetailData.normal:
        button = NormalButtonItem(
          index: index,
          list: list,
          callback: callback,
          // TODO: 2022/2/15 待确认
          maxWidth: constrains.maxWidth.isInfinite ? mw : constrains.maxWidth,
          disableClick: disableClick,
          formId: formId,
          nodeController: config?.controller,
        );
        break;
      case ButtonDetailData.textButton:
        button = TextButtonItem(
          index: index,
          list: list,
          callback: callback,
          disableClick: disableClick,
          formId: formId,
        );
        break;
      case ButtonDetailData.disableButton:
        button = DisableButtonItem(index: index, list: list);
        break;
    }
    if (button == null) {
      debugPrint('未知按钮类型:${cur.type}     json:${cur.toJson()}');
      button = NormalButtonItem(
        index: index,
        list: list,
        callback: callback,
        // TODO: 2022/2/15 待确认
        maxWidth: constrains.maxWidth.isInfinite ? mw : constrains.maxWidth,
        disableClick: disableClick,
        formId: formId,
        nodeController: config?.controller,
      );
    }
    return button;
  }
}

class ButtonConfig {
  final DropdownConfig? dropdownConfig;

  ButtonConfig({this.dropdownConfig});
}

class DropdownConfig {
  final DropdownIcon? dropdownIcon;

  DropdownConfig({this.dropdownIcon});
}

typedef Widget DropdownIcon();
