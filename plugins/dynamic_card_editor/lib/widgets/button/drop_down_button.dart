import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  final DropdownData data;
  final TempWidgetConfig? config;

  const DropdownButtonWidget({Key? key, required this.data, this.config})
      : super(key: key);

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  int? _select;

  DropdownData get data => widget.data;

  @override
  Widget build(BuildContext context) {
    final hint = data.hint ?? DropdownData.hintText;
    final length = widget.data.list?.length ?? 0;

    return Container(
      color: Colors.white,
      width: widget.config?.defaultWidth ?? defaultWidth,
      padding: EdgeInsets.fromLTRB(12, 0, 12, 14),
      child: SizedBox(
        height: 40,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: color3.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(20)),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _select,
                isDense: true,
                isExpanded: true,
                hint: Text(hint, style: textStyle1.copyWith(color: color3)),
                items: List.generate(length, (index) {
                  final cur = widget.data.list![index];
                  return DropdownMenuItem(
                    child: Text(cur, style: textStyle1.copyWith(color: color2)),
                    value: index,
                  );
                }),
                onChanged: (newValue) {
                  if (newValue == _select) return;
                  widget.data.select = newValue;
                  _select = newValue;
                  refresh();
                },
                icon: config?.dropdownConfig?.dropdownIcon?.call() ??
                    Icon(Icons.arrow_drop_down_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonConfig? get config =>
      widget.config?.buttonConfig ?? WidgetConfig().buttonConfig;

  void refresh() {
    if (mounted) setState(() {});
  }
}
