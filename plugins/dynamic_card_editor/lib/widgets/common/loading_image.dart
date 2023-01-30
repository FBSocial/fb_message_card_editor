import 'package:flutter/material.dart';

class LoadingImage extends StatelessWidget {
  final double? width;

  final double? height;

  final BoxFit? fit;

  final ImageProvider? image;

  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final bool matchTextDirection;

  final Widget? loadingWidget;

  final Widget? errorWidget;

  const LoadingImage({
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.image,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _image(
      image: image!,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null)
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        return child;
      },
      errorBuilder: (ctx, error, trace) => errorWidget ?? Container(),
    );
  }

  Image _image({
    required ImageProvider image,
    ImageErrorWidgetBuilder? errorBuilder,
    ImageFrameBuilder? frameBuilder,
  }) {
    return Image(
      image: image,
      errorBuilder: errorBuilder,
      frameBuilder: frameBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: true,
      excludeFromSemantics: true,
    );
  }
}
