import '../../ast/all.dart';
import '../all.dart';

class VoteTextNode extends SingleChildWidgetNode<VoteTextData> {
  final VoteTextData textData;
  final RootParam? rootParam;

  VoteTextNode(
    this.textData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitVoteTextNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.voteText;

  @override
  VoteTextData get data => textData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.first,
        '0表示自己选择的，1表示非自己选择的其他选项。默认为0',
      ]),
      NodeDescriptionRow([
        JsonName.total + JsonLevel.first,
        '当前比例投票人数(int)',
      ]),
      NodeDescriptionRow([
        JsonName.ratio + JsonLevel.first,
        '当前比例(double)',
      ]),
      NodeDescriptionRow([
        JsonName.text + JsonLevel.first,
        '统计选项描述',
      ]),
    ]);
  }
}

class VoteTextData extends WidgetNodeData {
  int? total;
  double? ratio;
  int? type;
  String? pre;
  String? image;
  String? text;

  VoteTextData(this.total, this.ratio,
      {this.type = selected, this.pre = "", this.text = "", this.image = ""});

  @override
  Map<String, dynamic> toJson() => {
        JsonName.total: total,
        JsonName.ratio: ratio,
        JsonName.type: type,
        JsonName.pre: pre,
        JsonName.image: image,
        JsonName.text: text,
      };

  VoteTextData.fromJson(Map json) {
    if (json.isEmpty) {
      total = 0;
      ratio = 0.0;
      type = selected;
      text = "";
      return;
    }
    total = handleNum(json[JsonName.total]) ?? 0;
    ratio = handleNum(json[JsonName.ratio]) ?? 0.0;
    type = handleNum(json[JsonName.type]) ?? selected;
    pre = json[JsonName.pre] ?? "";
    image = json[JsonName.image] ?? "";
    text = json[JsonName.text] ?? "";
  }

  static const selected = 0;
  static const unSelected = 1;
}
