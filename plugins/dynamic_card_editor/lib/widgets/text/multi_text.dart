import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class MultiTextWidget extends StatelessWidget {
  final MultiTextData data;
  final TempWidgetConfig? config;

  const MultiTextWidget({Key? key, required this.data, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: config?.defaultWidth ?? defaultWidth,
      child: textConfig?.multiTextRep?.call(data) ??
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(data.details?.length ?? 0, (index) {
              final MultiTextDetail cur = data.details![index];
              final dataList = cur.textDataList ?? [];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(dataList.length, (i) {
                      final curData = dataList[i];
                      final text = curData.text ?? '';
                      final type = curData.type ?? TextDetail.normal;
                      return Container(
                        margin: EdgeInsets.only(bottom: 2),
                        child: Text(
                          text,
                          style: textStyle1.copyWith(
                              fontWeight: type == TextDetail.normal
                                  ? FontWeight.normal
                                  : FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
          ),
    );
  }

  TextConfig? get textConfig => config?.textConfig ?? WidgetConfig().textConfig;
}

typedef Widget MultiTextReplacer(MultiTextData? data);
