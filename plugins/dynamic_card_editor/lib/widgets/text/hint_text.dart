import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class HintTextWidget extends StatelessWidget {
  final HintTextData? data;
  final TempWidgetConfig? config;

  const HintTextWidget({Key? key, this.data, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = data?.title ?? '';
    final text = data?.text ?? '';
    return Container(
      color: Colors.white,
      width: config?.defaultWidth ?? defaultWidth,
      padding: EdgeInsets.fromLTRB(12, 8, 12, 14),
      child: textConfig?.hintTextRep?.call(data) ??
          Row(
            children: [
              Text(
                title,
                style: textStyle1.copyWith(color: color6, fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    text,
                    style: textStyle1.copyWith(color: color6, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
    );
  }

  TextConfig? get textConfig => config?.textConfig ?? WidgetConfig().textConfig;
}

typedef Widget HintTextReplacer(HintTextData? data);
