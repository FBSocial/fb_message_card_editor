import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final TitleTextData data;
  final TempWidgetConfig? config;

  const TitleTextWidget({Key? key, required this.data, this.config}) : super(key: key);

  List<TitleTextDetail> get details => data.list ?? [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: config?.defaultWidth ?? defaultWidth,
      child: textConfig?.titleTextRep?.call(data) ??
          Column(
            children: List.generate(details.length, (index) {
              final cur = details[index];
              final title = cur.title;
              final text = cur.text;
              final type = cur.type;
              final isFirst = index == 0;
              final isLast = index == details.length - 1;
              return Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                    12, isFirst ? 6 : 0, 12, isLast ? 14 : 8),
                child: Row(
                  children: [
                    Text(
                      title ?? '',
                      style: textStyle1.copyWith(
                        color:
                            type == TitleTextDetail.diffColor ? color3 : color1,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Flexible(
                      child: Text(
                        text ?? '',
                        style: textStyle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
    );
  }

  TextConfig? get textConfig => config?.textConfig ?? WidgetConfig().textConfig;
}

typedef Widget TitleTextReplacer(TitleTextData? data);
