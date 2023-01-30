import '../../dynamic_card.dart';

class WidgetConfig {
  WidgetConfig._internal();

  static WidgetConfig? _obj;

  factory WidgetConfig({
    ImgConfig? imgConfig,
    RadioConfig? radioConfig,
    ButtonConfig? buttonConfig,
    CommonConfig? commonConfig,
    TextConfig? textConfig,
  }) {
    _obj ??= WidgetConfig._internal();
    _obj!.imgConfig = imgConfig ?? _obj!.imgConfig;
    _obj!.radioConfig = radioConfig ?? _obj!.radioConfig;
    _obj!.buttonConfig = buttonConfig ?? _obj!.buttonConfig;
    _obj!.commonConfig = commonConfig ?? _obj!.commonConfig;
    _obj!.textConfig = textConfig ?? _obj!.textConfig;
    return _obj!;
  }

  ImgConfig? imgConfig;

  RadioConfig? radioConfig;

  ButtonConfig? buttonConfig;

  CommonConfig? commonConfig;

  TextConfig? textConfig;
}

class TempWidgetConfig {
  final ImgConfig? imgConfig;
  final RadioConfig? radioConfig;
  final ButtonConfig? buttonConfig;
  final CommonConfig? commonConfig;
  final TextConfig? textConfig;
  final NodeController? controller;

  TempWidgetConfig({
    this.imgConfig,
    this.radioConfig,
    this.buttonConfig,
    this.commonConfig,
    this.textConfig,
    this.controller,
  });

  TempWidgetConfig copy({
    ImgConfig? imgConfig,
    RadioConfig? radioConfig,
    ButtonConfig? buttonConfig,
    CommonConfig? commonConfig,
    TextConfig? textConfig,
    NodeController? controller,
  }) =>
      TempWidgetConfig(
        imgConfig: imgConfig ?? this.imgConfig,
        radioConfig: radioConfig ?? this.radioConfig,
        buttonConfig: buttonConfig ?? this.buttonConfig,
        commonConfig: commonConfig ?? this.commonConfig,
        textConfig: textConfig ?? this.textConfig,
        controller: controller ?? this.controller,
      );

  double? get defaultWidth => commonConfig?.widgetWith;
}

class CommonConfig {
  final double? widgetWith;

  CommonConfig({this.widgetWith});
}

class TextConfig {
  final ContentTextReplacer? contentTextRep;
  final HintTextReplacer? hintTextRep;
  final MultiTextReplacer? multiTextRep;
  final TitleTextReplacer? titleTextRep;
  final TextReplacer? textRep;

  TextConfig(
      {this.contentTextRep,
      this.hintTextRep,
      this.multiTextRep,
      this.titleTextRep,
      this.textRep});
}

double get defaultWidth => WidgetConfig().commonConfig?.widgetWith ?? 304;
