import '../../ast/all.dart';
import '../all.dart';

class MultiTextNode extends SingleChildWidgetNode<MultiTextData> {
  final MultiTextData multiTextData;
  final RootParam? rootParam;

  MultiTextNode(
    this.multiTextData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitMultiTextNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.multiText;

  @override
  MultiTextData get data => multiTextData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.list + JsonLevel.first,
        '每一行的内容',
      ]),
      NodeDescriptionRow([
        JsonName.list + JsonLevel.second,
        '每一列中又多少个文字，默认控制list长度为1',
      ]),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.third,
        '0为默认字体，1为加粗字体',
      ]),
      NodeDescriptionRow([
        JsonName.text + JsonLevel.third,
        '传入的内容',
      ]),
    ]);
  }
}

class MultiTextData extends WidgetNodeData {
  List<MultiTextDetail>? details;

  MultiTextData(this.details);

  MultiTextData.fromJson(Map json) {
    if (json.isEmpty) {
      details = [];
      return;
    }
    details = MultiTextDetail.fromJsonList(json[JsonName.list]);
  }

  @override
  Map<String, dynamic> toJson() => {
        JsonName.list: details?.map((e) => e.toJson()).toList(),
      };
}

class MultiTextDetail {
  List<TextDetail>? textDataList;

  MultiTextDetail(this.textDataList);

  Map toJson() => {
        JsonName.list: textDataList?.map((e) => e.toJson()).toList(),
      };

  MultiTextDetail.fromJson(Map json) {
    if (json.isEmpty) {
      textDataList = [];
      return;
    }
    textDataList = TextDetail.fromJsonList(json[JsonName.list] ?? []);
  }

  static List<MultiTextDetail> fromJsonList(List<dynamic>? map) {
    final List<MultiTextDetail> result = [];
    map?.forEach((element) {
      result.add(MultiTextDetail.fromJson(element));
    });
    return result;
  }
}

class TextDetail {
  int? type;
  String? text;

  static const int normal = 0;
  static const int bold = 1;

  TextDetail(this.text, {this.type = normal});

  Map toJson() => {
        JsonName.text: text,
        JsonName.type: type,
      };

  TextDetail.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      type = normal;
      return;
    }
    text = json[JsonName.text] ?? '';
    type = handleNum(json[JsonName.type]) ?? normal;
  }

  static List<TextDetail> fromJsonList(List<dynamic> map) {
    final List<TextDetail> result = [];
    map.forEach((element) {
      result.add(TextDetail.fromJson(element));
    });
    return result;
  }
}
