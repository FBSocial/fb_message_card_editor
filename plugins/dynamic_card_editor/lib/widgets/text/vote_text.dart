import '../../widget_nodes/all.dart';
import '../all.dart';
import '../../ast/string_extension.dart';
import 'package:flutter/material.dart';

class VoteTextWidget extends StatelessWidget {
  final VoteTextData data;
  final TempWidgetConfig? config;

  const VoteTextWidget({Key? key, required this.data, this.config})
      : super(key: key);

  bool get showHeader =>
      (data.pre ?? "").isNotEmpty ||
      (data.image ?? "").isNotEmpty ||
      (data.text ?? "").isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).devicePixelRatio;
    return Container(
        color: Colors.white,
        width: config?.defaultWidth ?? defaultWidth,
        padding: EdgeInsets.fromLTRB(12, 0, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    if (data.pre != null && data.pre!.isNotEmpty)
                      Container(
                        width: 18,
                        alignment: Alignment.centerRight,
                        child: Text(
                          data.pre!,
                          style: textStyle1.copyWith(
                              color: isSelect ? color4 : color3),
                          maxLines: 1,
                        ),
                      ),
                    if (data.image != null && data.image!.isNotEmpty)
                      Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.only(
                            left: (data.pre ?? '').isNotEmpty ? 5 : 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ResizeImage(
                              NetworkImage(data.image!),
                              width: 48 * pixel.toInt(),
                              allowUpscaling: true,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    if (data.text != null && data.text!.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: (data.image ?? '').isNotEmpty ? 12 : 0),
                          child: Text(
                            data.text!.breakWord,
                            style: textStyle1.copyWith(
                                color: isSelect ? color4 : color3),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Text('${data.total ?? 0 }票  ${getRatio()}',
                style: textStyle2.copyWith(
                    fontSize: 11, color: isSelect ? color4 : color3)),
            SizedBox(height: 3),
            SizedBox(
              height: 4,
              child: LayoutBuilder(
                builder: (ctx, constrains) {
                  final width = constrains.maxWidth;
                  return Stack(
                    children: [
                      Container(
                        height: 4,
                        width: width,
                        decoration: BoxDecoration(
                            color: color3.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      Container(
                        height: 4,
                        width: width * (data.ratio ?? 0.0),
                        decoration: BoxDecoration(
                            color: isSelect ? color4 : color3,
                            borderRadius: BorderRadius.circular(4)),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }

  String getRatio() {
    final ratio = data.ratio ?? 0.0;
    return '${(ratio * 100).toStringAsFixed(1)}%';
  }

  int get type => data.type ?? VoteTextData.selected;

  bool get isSelect => type == VoteTextData.selected;
}
