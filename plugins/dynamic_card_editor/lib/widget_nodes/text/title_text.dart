import '../../ast/all.dart';
import '../all.dart';

class TitleTextNode extends SingleChildWidgetNode<TitleTextData> {
  final TitleTextData titleTextData;
  final RootParam? rootParam;

  TitleTextNode(
    this.titleTextData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitTitleTextNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.titleText;

  @override
  TitleTextData get data => titleTextData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.list + JsonLevel.second,
        '用于表示这个组件的各行数据',
      ]),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.second,
        '0为默认字体，1为颜色更淡的字体',
      ]),
      NodeDescriptionRow([
        JsonName.title + JsonLevel.second,
        '左边的文字',
      ]),
      NodeDescriptionRow([
        JsonName.text + JsonLevel.second,
        '右边的文字',
      ]),
    ]);
  }
}

class TitleTextData extends WidgetNodeData {
  List<TitleTextDetail>? list;

  TitleTextData(this.list);

  @override
  Map<String, dynamic> toJson() =>
      {JsonName.list: list?.map((e) => e.toJson()).toList()};

  TitleTextData.fromJson(Map json) {
    if (json.isEmpty) {
      list = [];
      return;
    }
    list = fromJsonList(json[JsonName.list] ?? []);
  }

  List<TitleTextDetail> fromJsonList(List<dynamic> map) {
    final List<TitleTextDetail> result = [];
    map.forEach((element) {
      result.add(TitleTextDetail.fromJson(element));
    });
    return result;
  }
}

class TitleTextDetail {
  String? text;
  String? title;
  int? type;

  TitleTextDetail(this.text, this.title, {this.type = normal});

  static const int normal = 0;
  static const int diffColor = 1;

  Map toJson() => {
        JsonName.text: text,
        JsonName.title: title,
        JsonName.type: type,
      };

  TitleTextDetail.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      title = '';
      type = normal;
      return;
    }
    text = json[JsonName.text] ?? '';
    title = json[JsonName.title] ?? '';
    type = handleNum(json[JsonName.type]) ?? normal;
  }
}
