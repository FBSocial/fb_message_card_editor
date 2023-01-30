import '../../widget_nodes/all.dart';
import '../all.dart';
import 'form_radio_item.dart';
import 'package:flutter/material.dart';

class RadioWidget extends StatefulWidget {
  final RadioData radioData;
  final TempWidgetConfig? config;
  final RootParam? rootParam;

  const RadioWidget({
    Key? key,
    required this.radioData,
    this.config,
    this.rootParam,
  }) : super(key: key);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  RadioData get data => widget.radioData;

  bool get enableSelectMore => selectSet.length < data.maxSelect;

  bool get disableChangeValue => !data.isSingleRadio && !enableSelectMore;

  List<RadioDetail>? get details => data.radioDetails;

  NodeController? get nodeController => widget.config?.controller;

  String? get formId => widget.rootParam?.formId;

  bool get isFormItem => formId?.isNotEmpty ?? false;

  bool get hasFormId => formId?.isNotEmpty ?? false;

  int? get layout => data.layout;
  Set<int> selectSet = {};

  @override
  void initState() {
    updateSelectSet();
    super.initState();
  }

  void updateSelectSet() {
    if (details != null) {
      for (var i = 0; i < details!.length; ++i) {
        final detail = details![i];
        if (detail.value == RadioData.SELECTED_VALUE)
          selectSet.add(i);
        else
          selectSet.remove(i);
      }
    }
  }

  @override
  void didUpdateWidget(covariant RadioWidget oldWidget) {
    if (oldWidget.radioData.radioDetails != details) {
      selectSet.clear();
      updateSelectSet();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!data.hasDetail) return SizedBox();

    final disable = data.enable == RadioData.disableClick;
    if (disable) {
      return AbsorbPointer(
        child: buildRadio(),
      );
    }
    if (!isFormItem) {
      return buildRadio();
    }
    return FormRadioItem(
        formId: formId,
        formBuilder: (value) {
          return buildRadio();
        },
        nodeController: widget.config?.controller);
  }

  void onValueChange(int index) {
    if (data.isSingleRadio) {
      onValueChangeForSingle(index);
    } else {
      onValueChangeForGroup(index);
    }

    changeNodeControllerStatus();
  }

  void changeNodeControllerStatus() {
    if (nodeController == null || !hasFormId) return;
    nodeController!.refreshButtonValue(formId);
    List<int> arr = [];
    if (details != null) {
      for (int i = 0; i < details!.length; i++) {
        if (isSelected(details![i].value)) arr.add(i);
      }
    }

    widget.config?.radioConfig?.valueChangeCallback?.call(arr);
  }

  void onValueChangeForSingle(int index) {
    final cur = details![index];
    final v = isSelected(cur.value)
        ? RadioData.UNSELECTED_VALUE
        : RadioData.SELECTED_VALUE;
    bool isSelect = isSelected(v);
    if (selectSet.isNotEmpty && isSelect) {
      final i = selectSet.first;
      selectSet.clear();
      details![i].value = RadioData.UNSELECTED_VALUE;
    }
    if (isSelect)
      selectSet.add(index);
    else
      selectSet.remove(index);
    cur.value = v;
    refresh();
  }

  void onValueChangeForGroup(int index) {
    final cur = details![index];
    final v = isSelected(cur.value)
        ? RadioData.UNSELECTED_VALUE
        : RadioData.SELECTED_VALUE;
    bool isSelect = isSelected(v);
    if (disableChangeValue && isSelect) return;
    if (isSelect)
      selectSet.add(index);
    else
      selectSet.remove(index);
    cur.value = v;
    refresh();
  }

  Widget buildRadioItem(int index) {
    final cur = details![index];
    final itemType = cur.type;
    Widget? item;
    switch (itemType) {
      case RadioDetail.COMMON:
        item = CommonRadioItem(
          data: data,
          index: index,
          onChanged: onValueChange,
          absorbing: disableChangeValue,
          config: widget.config,
        );
        break;
      case RadioDetail.IMAGE_TEXT:
        item = ImageRadioItem(
          data: data,
          index: index,
          onChanged: onValueChange,
          absorbing: disableChangeValue,
          config: widget.config,
        );
        break;
      case RadioDetail.PK_TEXT:
        item = PkRadioItem(
            data: data,
            index: index,
            onChanged: onValueChange,
            absorbing: (cur.radioTypeData as PkRadioTypeData).hasResult,
            color: !index.isOdd ? color4 : color5);
        break;
      case RadioDetail.PK_IMAGE:
        item = PkImageRadioItem(
            data: data,
            index: index,
            onChanged: onValueChange,
            absorbing: (cur.radioTypeData as PkImageRadioTypeData).hasResult,
            color: !index.isOdd ? color4 : color5);
        break;
    }
    return item ?? SizedBox();
  }

  Widget buildRadio() {
    if (layout == RadioData.GRID_LAYOUT)
      return Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details != null
              ? List.generate(details!.length, (index) {
                  final isFirst = index == 0;
                  final isLast = index == details!.length - 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          isFirst ? 12 : 6, 8, isLast ? 12 : 6, 8),
                      child: buildRadioItem(index),
                    ),
                  );
                })
              : [],
        ),
      );
    return Container(
      width: widget.config?.defaultWidth ?? defaultWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: details != null
            ? List.generate(details!.length, (index) => buildRadioItem(index))
            : [],
      ),
    );
  }

  void refresh() {
    if (mounted) setState(() {});
  }
}

bool isSelected(int? value) => value == RadioData.SELECTED_VALUE;
