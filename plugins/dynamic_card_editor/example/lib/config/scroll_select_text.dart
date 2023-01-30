import 'package:dynamic_card/dynamic_card.dart';
import 'package:flutter/material.dart';

class ScrollSelectText extends StatefulWidget {
  final String input;

  const ScrollSelectText({Key key, @required this.input}) : super(key: key);

  @override
  _ScrollSelectTextState createState() => _ScrollSelectTextState();
}

class _ScrollSelectTextState extends State<ScrollSelectText> {
  final _controller = ScrollController();
  // List<String> textList = [];
  //
  // @override
  // void initState() {
  //   updateText(widget.input);
  //   super.initState();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant ScrollSelectText oldWidget) {
  //   if (oldWidget.input != input) updateText(input);
  //   super.didUpdateWidget(oldWidget);
  // }
  //
  // void updateText(String text) {
  //   textList.clear();
  //   final list = LineSplitter().convert(text);
  //   textList.addAll(list);
  // }

  String get input => widget.input;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        child: SelectableText(
          input,
          style: textStyle1,
        ),
      ),
    );
  }
}
