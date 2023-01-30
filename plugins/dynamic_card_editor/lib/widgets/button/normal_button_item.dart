import 'package:flutter/material.dart';

import '../../widget_nodes/all.dart';
import '../all.dart';

class NormalButtonItem extends StatefulWidget {
  final int index;
  final List<ButtonDetailData> list;
  final ButtonCallback? callback;
  final NodeController? nodeController;
  final double maxWidth;
  final bool disableClick;
  final String? formId;

  const NormalButtonItem({
    Key? key,
    required this.index,
    required this.list,
    required this.maxWidth,
    this.disableClick = false,
    this.callback,
    this.nodeController,
    this.formId,
  }) : super(key: key);

  @override
  _NormalButtonItemState createState() => _NormalButtonItemState();
}

class _NormalButtonItemState extends State<NormalButtonItem> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final length = widget.list.length;
    final singleWidth = (widget.maxWidth - 12 - length * 12) / length;
    final realSingleWith = singleWidth > 0 ? singleWidth : 0;
    final isLast = widget.index == widget.list.length - 1;
    final cur = widget.list[widget.index];
    final hasColor = cur.type == ButtonDetailData.colorButton;
    final color = hasColor ? color4 : color3.withOpacity(0.2);
    final style = hasColor ? textStyle2 : textStyle1;

    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, isLast ? 12 : 0, 14),
      width: realSingleWith.toDouble(),
      child: InkWell(
        onTap: (widget.disableClick || _loading)
            ? null
            : () async {
                setState(() {
                  _loading = true;
                });
                try {
                  if (widget.formId != null && widget.formId!.isNotEmpty) {
                    widget.nodeController?.changeFormValue(widget.formId, true);
                    widget.nodeController
                        ?.getItemEnableNotifier(widget.formId!)
                        .value = false;
                  }
                  await (widget.callback ?? cur.callback)
                      ?.call(ButtonCallbackParam(
                    event: cur.event,
                    formParam: widget.formId != null
                        ? widget.nodeController?.rootNode
                            ?.getFormIdData(widget.formId)
                        : {},
                  ));
                } catch (e) {
                  print('Button:$cur click error:$e');
                } finally {
                  setState(() {
                    _loading = false;
                  });
                  if (widget.formId != null && widget.formId!.isNotEmpty) {
                    widget.nodeController
                        ?.changeFormValue(widget.formId, false);
                    widget.nodeController
                        ?.getItemEnableNotifier(widget.formId!)
                        .value = true;
                  }
                }
              },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.disableClick ? color3.withOpacity(0.2) : color,
                  width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 14,
                  width: 14,
                  child: Visibility(
                    visible: _loading,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  )),
              const SizedBox(
                width: 4,
              ),
              Flexible(
                child: Text(
                  cur.text ?? '',
                  style: style.copyWith(
                      fontWeight: FontWeight.normal,
                      color: widget.disableClick ? color3 : style.color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
