import '../../ast/all.dart';
import '../all.dart';

class InputNode extends SingleChildWidgetNode<InputData> {
  final InputData inputData;
  final RootParam? rootParam;

  InputNode(
    this.inputData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitInputNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.input;

  @override
  InputData get data => inputData;

  @override
  bool get isDataEmpty => (data.text ?? '').isEmpty;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.id,
        '如需对该输入框获取数据回调，则需传入自定义的id字符串',
      ]),
      NodeDescriptionRow([
        JsonName.text + JsonLevel.second,
        '可以给输入框一个默认内容',
      ]),
      NodeDescriptionRow([
        JsonName.hint + JsonLevel.second,
        '在没有默认内容的情况下，给输入框一个提示输入',
      ]),
    ]);
  }
}

class InputData extends WidgetNodeData {
  String? text;
  String? hint;

  InputData(this.text, {this.hint = hintText});

  @override
  Map<String, dynamic> toJson() => {
        JsonName.text: text,
        JsonName.hint: hint,
      };

  InputData.fromJson(Map json) {
    if (json.isEmpty) {
      text = '';
      hint = hintText;
      return;
    }
    text = json[JsonName.text] ?? '';
    hint = json[JsonName.hint] ?? hintText;
  }

  static const String hintText = '请输入...';
}
