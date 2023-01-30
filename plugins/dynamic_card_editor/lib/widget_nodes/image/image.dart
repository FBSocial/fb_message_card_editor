import '../../ast/all.dart';
import '../all.dart';

class ImageNode extends SingleChildWidgetNode<ImageData> {
  final ImageData imageData;
  final RootParam? rootParam;

  ImageNode(
    this.imageData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitImageNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.image;

  @override
  ImageData get data => imageData;

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.first,
        '0为小图，1为中图，2为大图',
      ]),
      NodeDescriptionRow([
        JsonName.image + JsonLevel.first,
        '值为图片的网络地址',
      ]),
    ]);
  }
}

class ImageData extends WidgetNodeData {
  int? type;
  String? image;

  ImageData(this.image, {this.type = small});

  @override
  Map<String, dynamic> toJson() {
    return {
      JsonName.image: image,
      JsonName.type: type,
    };
  }

  ImageData.fromJson(Map json) {
    if (json.isEmpty) {
      image = '';
      type = small;
      return;
    }
    image = json[JsonName.image] ?? '';
    type = handleNum(json[JsonName.type]) ?? small;
  }

  static const int small = 0;
  static const int medium = 1;
  static const int large = 2;
}
