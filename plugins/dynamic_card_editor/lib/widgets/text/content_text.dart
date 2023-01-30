import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class ContentTextWidget extends StatelessWidget {
  final ContentTextData? data;
  final TempWidgetConfig? config;

  const ContentTextWidget({Key? key, this.data, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = data?.text ?? '';
    final type = data?.type ?? ContentTextData.h1;
    final padding = type == ContentTextData.h1
        ? EdgeInsets.fromLTRB(12, 4, 12, 4)
        : EdgeInsets.fromLTRB(12, 8, 12, 4);
    final style = type == ContentTextData.h1
        ? textStyle1.copyWith(fontSize: 16, fontWeight: FontWeight.bold)
        : textStyle1.copyWith(fontWeight: FontWeight.bold);
    Widget? contenText = textConfig?.contentTextRep?.call(data);
    contenText = contenText == null || contenText is SizedBox
        ? Text(text, style: style)
        : contenText;
    return Container(
      color: Colors.white,
      width: config?.defaultWidth ?? defaultWidth,
      padding: padding,
      child: contenText,
    );
  }

  TextConfig? get textConfig => config?.textConfig ?? WidgetConfig().textConfig;
}

typedef Widget ContentTextReplacer(ContentTextData? data);
