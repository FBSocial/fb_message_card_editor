import '../../ast/all.dart';
import '../all.dart';

class ButtonNode extends SingleChildWidgetNode<ButtonData> {
  final ButtonData buttonData;
  final RootParam? rootParam;
  final ButtonCallback? buttonCallback;

  ButtonNode(
    this.buttonData, {
    this.rootParam,
    this.buttonCallback,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitButtonNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.button;

  @override
  ButtonData get data => buttonData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.second,
        '0为默认按钮，1为文字按钮，2为不可点击按钮，3为特定颜色的按钮',
      ]),
      NodeDescriptionRow([
        JsonName.formId + JsonLevel.second,
        '当这个',
      ]),
      NodeDescriptionRow([
        JsonName.event + JsonLevel.second,
        '按钮点击事件，需要添加"event"的json，由"method"和 "param"组成。目前支持的参数如下\n'
            '- 打开小程序："method"为"mini_program"，"param"为{"appId":"xxxxx"}\n'
            '- 打开网页："method"为"html_page"，"param"为{"url":"xxxx"}\n'
            '- 调用机器人接口："method"为"bot_api"，"param"为{"callback_data":"xxxx"}',
      ]),
    ]);
  }
}

class ButtonData extends WidgetNodeData {
  List<ButtonDetailData>? list;

  ButtonData(this.list);

  ButtonData.fromJson(Map json) {
    if (json.isEmpty) {
      list = [];
      return;
    }
    list = ButtonDetailData.fromJsonList(json[JsonName.list] ?? []);
  }

  @override
  Map<String, dynamic> toJson() {
    return {JsonName.list: list?.map((e) => e.toJson()).toList()};
  }
}

class ButtonDetailData {
  int? type;
  String? text;
  ClickEvent? event;
  int? enable;
  ButtonCallback? callback;

  ButtonDetailData(
    this.text, {
    this.type = normal,
    this.event,
    this.enable = enableClick,
    this.callback,
  });

  Map toJson() {
    return {
      JsonName.type: type,
      JsonName.text: text,
      JsonName.enable: enable,
      if (event != null) JsonName.event: event!.toJson(),
    };
  }

  ButtonDetailData.fromJson(Map json) {
    if (json.isEmpty) {
      type = normal;
      text = '';
      enable = enableClick;
      return;
    }
    type = handleNum(json[JsonName.type]) ?? normal;
    text = json[JsonName.text] ?? '';
    event = ClickEvent.fromJson(json[JsonName.event] ?? {});
    enable = handleNum(json[JsonName.enable]) ?? enableClick;
  }

  static List<ButtonDetailData> fromJsonList(List<dynamic> map) {
    final List<ButtonDetailData> result = [];
    map.forEach((element) {
      result.add(ButtonDetailData.fromJson(element));
    });
    return result;
  }

  static const int enableClick = 1;
  static const int disableClick = 0;

  static const int normal = 0;
  static const int textButton = 1;
  static const int disableButton = 2;
  static const int colorButton = 3;
}

class ButtonCallbackParam {
  final ClickEvent? event;
  final Map? formParam;
  const ButtonCallbackParam({this.event, this.formParam});
}

typedef ButtonCallback = Future Function(ButtonCallbackParam);
