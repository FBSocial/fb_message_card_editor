import '../../ast/all.dart';
import '../all.dart';

class VoteTitleNode extends SingleChildWidgetNode<VoteTitleData> {
  final VoteTitleData titleData;
  final RootParam? rootParam;

  VoteTitleNode(
    this.titleData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitVoteTitle(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.voteTitle;

  @override
  VoteTitleData get data => titleData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.text,
        '标题',
      ]),
      NodeDescriptionRow([
        JsonName.type,
        '0表示单选，1表示多选，默认为0',
      ]),
      NodeDescriptionRow([
        JsonName.bg,
        '0为渐变色一(主题渐变)，1为渐变色二，2为渐变色3，默认为0',
      ]),
    ]);
  }
}

class VoteTitleData extends WidgetNodeData {
  String? text;
  int? type;
  int? bg;

  VoteTitleData(
    this.text, {
    this.type = single,
    this.bg = bgOne,
  });

  @override
  Map<String, dynamic> toJson() => {
        JsonName.text: text,
        JsonName.type: type,
        JsonName.bg: bg,
      };

  VoteTitleData.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      type = single;
      bg = bgOne;
      return;
    }
    text = json[JsonName.text] ?? '';
    type = handleNum(json[JsonName.type]) ?? single;
    bg = handleNum(json[JsonName.bg]) ?? bgOne;
  }

  static const single = 0;
  static const multi = 1;

  static const bgOne = 0;
  static const bgTwo = 1;
  static const bgThree = 2;
  static const bgFour = 3;
}
