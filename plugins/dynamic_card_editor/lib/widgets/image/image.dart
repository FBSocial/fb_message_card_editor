import '../../widget_nodes/all.dart';
import '../all.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final ImageData data;
  final TempWidgetConfig? config;

  const ImageWidget({
    Key? key,
    required this.data,
    this.config,
  }) : super(key: key);

  int get type => data.type ?? ImageData.small;

  String get image => data.image ?? '';

  @override
  Widget build(BuildContext context) {
    return getLayout(context);
  }

  Widget getLayout(BuildContext context) {
    Widget? layout;
    switch (type) {
      case ImageData.small:
        return buildImage(84, context);
      case ImageData.medium:
        return buildImage(154, context);
      case ImageData.large:
        return buildImage(171, context);
    }

    if (layout == null) debugPrint('未知图片类型:$type    json:${data.toJson()}');
    return layout ?? buildImage(84, context);
  }

  Widget buildImage(double height, BuildContext context) {
    final padding = EdgeInsets.fromLTRB(12, 0, 12, 14);
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final resizeImage = ResizeImage(NetworkImage(image),
        width: (defaultWidth * (pixelRatio > 1.5 ? pixelRatio : 1.5)).toInt(),
        allowUpscaling: true);
    final imgConfig = config?.imgConfig ?? WidgetConfig().imgConfig;

    return Container(
      height: height,
      width: config?.defaultWidth ?? defaultWidth,
      padding: padding,
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LoadingImage(
          image: resizeImage,
          fit: BoxFit.cover,
          height: height,
          width: config?.defaultWidth ?? defaultWidth,
          loadingWidget: imgConfig?.imgLoading?.call(image),
        ),
      ),
    );
  }
}

class ImgConfig {
  final ImgLoading? imgLoading;

  ImgConfig({this.imgLoading});
}

typedef Widget ImgLoading(String url);
