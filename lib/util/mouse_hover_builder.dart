import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MouseHoverBuilder extends StatelessWidget {
  final Widget Function(BuildContext, bool) builder;
  final SystemMouseCursor cursor;
  final bool opaque;

  MouseHoverBuilder({
    required this.builder,
    this.cursor = SystemMouseCursors.basic,
    this.opaque = true,
  });

  final ValueNotifier _value = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    // if (OrientationUtil.portrait) return builder(context, false);
    return MouseRegion(
      opaque: opaque,
      onEnter: (_) => _value.value = true,
      onExit: (_) => _value.value = false,
      cursor: cursor,
      child: ValueListenableBuilder(
        valueListenable: _value,
        builder: (context, value, child) {
          return builder(context, value);
        },
      ),
    );
  }
}

class MouseHoverStatefulBuilder extends StatefulWidget {
  final Widget Function(BuildContext, bool) builder;
  final SystemMouseCursor cursor;

  const MouseHoverStatefulBuilder({
    required this.builder,
    this.cursor = SystemMouseCursors.basic,
    Key? key,
  }) : super(key: key);

  @override
  State<MouseHoverStatefulBuilder> createState() =>
      _MouseHoverStatefulBuilderState();
}

class _MouseHoverStatefulBuilderState extends State<MouseHoverStatefulBuilder> {
  final ValueNotifier _value = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    // if (OrientationUtil.portrait) return widget.builder(context, false);
    return MouseRegion(
      onEnter: (_) => _value.value = true,
      onExit: (_) => _value.value = false,
      cursor: widget.cursor,
      child: ValueListenableBuilder(
        valueListenable: _value,
        builder: (context, value, child) {
          return widget.builder(context, value);
        },
      ),
    );
  }
}
