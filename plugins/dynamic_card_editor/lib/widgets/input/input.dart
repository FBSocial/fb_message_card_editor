import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final InputData data;
  final TempWidgetConfig? config;
  final RootParam? rootParam;

  const InputWidget({
    Key? key,
    required this.data,
    this.config,
    this.rootParam,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  String? _text;
  String? _hint;
  late TextEditingController _controller;

  @override
  void initState() {
    _text = widget.data.text ?? '';
    _hint = widget.data.hint ?? InputData.hintText;
    _controller = TextEditingController(text: _text);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  NodeController? get nodeController => widget.config?.controller;

  String? get formId => widget.rootParam?.formId;

  bool get hasFormId => formId != null && formId!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: widget.config?.defaultWidth ?? defaultWidth,
      padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: SizedBox(
        height: 40,
        child: TextField(
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: color3.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: color3.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(20)),
            hintText: _hint,
            hintMaxLines: 1,
            hintStyle: textStyle1.copyWith(color: color3),
          ),
          onChanged: (text) {
            _text = text;
            widget.data.text = _text;
            changeNodeControllerStatus(text);
          },
          maxLines: 1,
        ),
      ),
    );
  }

  void changeNodeControllerStatus(String text) {
    if (nodeController == null || !hasFormId) return;
    if (text.isEmpty)
      nodeController!.changeButtonValue(formId, false);
    else if (nodeController!.getRealButtonNotifier(formId)?.value ?? false)
      nodeController!.changeButtonValue(formId, false);
  }
}
