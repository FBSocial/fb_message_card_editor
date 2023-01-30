import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final RadioType radioType;
  final TempWidgetConfig? config;

  const CustomRadio(
      {Key? key,
      this.value = false,
      this.onChanged,
      this.radioType = RadioType.single,
      this.config})
      : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  bool _isCheck = false;

  @override
  void initState() {
    _isCheck = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomRadio oldWidget) {
    if (oldWidget.value != widget.value) _isCheck = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isCheck = !_isCheck;
        widget.onChanged?.call(_isCheck);
        setState(() {});
      },
      child: _isCheck ? buildSelected() : buildUnselected(),
    );
  }

  Widget buildUnselected() {
    if (type == RadioType.single) return singleUnselected();
    return groupUnselected();
  }

  Widget singleUnselected() {
    return SizedBox(
      width: 20,
      height: 20,
      child: config?.singleUnselected ??
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: color3)),
          ),
    );
  }

  Widget groupUnselected() {
    return SizedBox(
      width: 20,
      height: 20,
      child: config?.groupUnselected ??
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: color3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
    );
  }

  Widget buildSelected() {
    if (type == RadioType.single) return singleSelected();
    return groupSelected();
  }

  Widget singleSelected() {
    return SizedBox(
      width: 20,
      height: 20,
      child: config?.singleSelected ??
          Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color4, width: 4),
            ),
          ),
    );
  }

  Widget groupSelected() {
    return SizedBox(
      width: 20,
      height: 20,
      child: config?.groupSelected ??
          Container(
            margin: EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2), color: color4),
            child: Container(
              alignment: Alignment.center,
              child: Icon(Icons.check, size: 9, color: Colors.white),
            ),
          ),
    );
  }

  RadioConfig? get config =>
      widget.config?.radioConfig ?? WidgetConfig().radioConfig;

  RadioType get type => widget.radioType;
}

enum RadioType { single, group }

class RadioConfig {
  final Widget? singleSelected;
  final Widget? groupSelected;
  final Widget? singleUnselected;
  final Widget? groupUnselected;
  final Function(List<int>)? valueChangeCallback;

  RadioConfig({
    this.singleSelected,
    this.groupSelected,
    this.singleUnselected,
    this.groupUnselected,
    this.valueChangeCallback,
  });

  RadioConfig copy({
    Widget? singleSelected,
    Widget? groupSelected,
    Widget? singleUnselected,
    Widget? groupUnselected,
    Function(List<int>)? valueChangeCallback,
  }) {
    return RadioConfig(
      singleSelected: singleSelected ?? this.singleSelected,
      groupSelected: groupSelected ?? this.groupSelected,
      singleUnselected: singleUnselected ?? this.singleUnselected,
      groupUnselected: groupUnselected ?? this.groupUnselected,
      valueChangeCallback: valueChangeCallback ?? this.valueChangeCallback,
    );
  }
}
