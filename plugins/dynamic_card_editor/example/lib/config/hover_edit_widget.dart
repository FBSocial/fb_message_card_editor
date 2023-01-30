import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HoverEditWidget extends StatefulWidget {
  const HoverEditWidget({
    Key key,
    @required this.index,
    @required this.child,
    this.duration,
    this.onDelete,
    this.onEdit,
    this.onEditFormId,
  }) : super(key: key);

  final Widget child;
  final int index;
  final Duration duration;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onEditFormId;

  @override
  _HoverEditWidgetState createState() => _HoverEditWidgetState();
}

class _HoverEditWidgetState extends State<HoverEditWidget>
    with SingleTickerProviderStateMixin {
  // bool isHovering = false;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _controller.forward();
      },
      onExit: (event) {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _animation,
        child: widget.child,
        builder: (ctx, child) {
          final value = _animation.value;
          return LayoutBuilder(builder: (context, constrains) {
            return Stack(
              children: [
                Container(
                  child: child,
                  width: constrains.maxWidth,
                ),
                if (value > 0)
                  Transform.translate(
                    offset: Offset(0, 20 * (value - 1)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildIconButton(
                            icon: Icons.delete_outline, onTap: widget.onDelete),
                        SizedBox(width: 4),
                        ReorderableDragStartListener(
                          index: widget.index,
                          key: ValueKey(widget.index),
                          child: buildIconButton(
                            icon: Icons.menu,
                            onTap: () {},
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 4),
                        buildIconButton(
                            icon: Icons.subdirectory_arrow_left_sharp,
                            onTap: widget.onEditFormId,
                            color: Colors.orange),
                        SizedBox(width: 4),
                        buildIconButton(
                            icon: Icons.edit_outlined,
                            onTap: widget.onEdit,
                            color: Colors.blue),
                      ],
                    ),
                  ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget buildIconButton({IconData icon, VoidCallback onTap, Color color}) {
    return InkWell(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color ?? Colors.redAccent),
        child: Icon(
          icon ?? Icons.delete_outlined,
          color: Colors.white,
          size: 10,
        ),
      ),
      onTap: onTap,
    );
  }
}
