import 'dart:math';

import '../../ast/all.dart';
import '../../widgets/all.dart';
import '../all.dart';

class RadioNode extends SingleChildWidgetNode<RadioData> {
  final RadioData radioData;
  final RootParam? rootParam;

  RadioNode(
    this.radioData, {
    this.rootParam,
    TempWidgetConfig? config,
  }) : super(config);

  @override
  E accept<E>(AstVisitor<E> visitor) => visitor.visitRadioNode(this);

  @override
  WidgetNode? get child => null;

  @override
  String get widgetType => WidgetName.radio;

  @override
  RadioData get data => radioData;

  @override
  bool get isDataEmpty {
    bool result = true;
    radioData.details?.forEach((element) {
      // TODO: 2022/2/15 此处需要确认是否需要添加跳出循环
      if (element.value == RadioData.SELECTED_VALUE) result = false;
    });
    return result;
  }

  @override
  NodeDescription getDescription() {
    return NodeDescription([
      NodeDescriptionRow(['字段', '说明']),
      NodeDescriptionRow([
        JsonName.id,
        '如需对该选择框获取数据回调，则需传入自定义的id字符串',
      ]),
      NodeDescriptionRow([
        JsonName.max + JsonLevel.first,
        '最大能选择的数量，为1表示单选，超过1表示多选',
      ]),
      NodeDescriptionRow([
        JsonName.layout + JsonLevel.first,
        '0表示默认的选择框，1表示PK选择框(请勿直接修改此属性值)',
      ]),
      NodeDescriptionRow([
        JsonName.pre + JsonLevel.second,
        '前缀的名字，可自定义，比如[A.]、[B.]、[1.]、[2.]',
      ]),
      NodeDescriptionRow([
        JsonName.type + JsonLevel.second,
        '0为默认格式，1为图文格式',
      ]),
      NodeDescriptionRow([
        JsonName.value + JsonLevel.second,
        '0为不选中，1为选中',
      ]),
    ]);
  }
}

class RadioData extends WidgetNodeData {
  int? maxEnableSelect;
  int? layout;
  int? enable;
  List<RadioDetail>? radioDetails;

  RadioData(
      {this.maxEnableSelect = 1,
      this.radioDetails,
      this.layout = LIST_LAYOUT,
      this.enable = enableClick});

  @override
  Map<String, dynamic> toJson() => {
        JsonName.max: maxEnableSelect,
        JsonName.layout: layout,
        JsonName.enable: enable,
        JsonName.list: radioDetails?.map((e) => e.toJson()).toList(),
      };

  RadioData.fromJson(Map json) {
    if (json.isEmpty) {
      maxEnableSelect = 1;
      radioDetails = [];
      layout = LIST_LAYOUT;
      enable = enableClick;
      return;
    }
    maxEnableSelect = handleNum(json[JsonName.max]) ?? 1;
    layout = json[JsonName.layout] ?? LIST_LAYOUT;
    enable = handleNum(json[JsonName.enable]) ?? enableClick;
    final detailJsonList = json[JsonName.list] ?? [];
    radioDetails = RadioDetail.fromJsonList(detailJsonList);
  }

  bool get hasDetail => details?.isNotEmpty ?? false;

  int get maxSelect => min(maxEnableSelect!, details?.length ?? 0);

  RadioType get type => maxSelect == 1 ? RadioType.single : RadioType.group;

  bool get isSingleRadio => type == RadioType.single;

  List<RadioDetail>? get details => radioDetails;

  static const SELECTED_VALUE = 1;
  static const UNSELECTED_VALUE = 0;

  static const LIST_LAYOUT = 0;
  static const GRID_LAYOUT = 1;

  static const disableClick = 0;
  static const enableClick = 1;
}

class RadioDetail {
  ///前缀的名字，可自定义，比如[A.]、[B.]、[1.]、[2.]
  String? pre;

  ///0为不选中，1为选中
  int? value;

  ///0为默认格式，1为图文格式
  int? type;

  /// 透传参数
  Map? external;

  RadioTypeData? radioTypeData;

  RadioDetail({
    this.pre = '',
    this.value = 0,
    this.radioTypeData,
    this.type = 0,
    this.external,
  });

  Map toJson() => {
        JsonName.pre: pre,
        JsonName.value: value,
        JsonName.type: type,
        JsonName.data: radioTypeData?.toJson(),
        if (external != null) JsonName.external: external,
      };

  static List<RadioDetail> fromJsonList(List<dynamic> map) {
    final List<RadioDetail> result = [];
    map.forEach((element) {
      result.add(RadioDetail.fromJson(element));
    });
    return result;
  }

  RadioDetail.fromJson(Map json) {
    if (json.isEmpty) {
      pre = '';
      value = 0;
      type = RadioDetail.COMMON;
      return;
    }
    pre = json[JsonName.pre] ?? '';
    value = handleNum(json[JsonName.value]) ?? 0;
    type = handleNum(json[JsonName.type]) ?? RadioDetail.COMMON;
    radioTypeData = RadioTypeData.fromJson(type, json[JsonName.data]);
    external = json[JsonName.external];
  }

  static const COMMON = 0;
  static const IMAGE_TEXT = 1;
  static const PK_TEXT = 2;
  static const PK_IMAGE = 3;
}

abstract class RadioTypeData {
  Map toJson();

  static RadioTypeData? fromJson(int? type, Map? json) {
    RadioTypeData? result;
    switch (type) {
      case RadioDetail.COMMON:
        result = CommonRadioTypeData.fromJson(json);
        break;
      case RadioDetail.IMAGE_TEXT:
        result = ImageRadioTypeData.fromJson(json);
        break;
      case RadioDetail.PK_TEXT:
        result = PkRadioTypeData.fromJson(json);
        break;
      case RadioDetail.PK_IMAGE:
        result = PkImageRadioTypeData.fromJson(json);
        break;
    }
    if (result == null) print('Radio type:$type    can not find');
    return result;
  }
}

class CommonRadioTypeData extends RadioTypeData {
  String? text;

  CommonRadioTypeData(this.text);

  CommonRadioTypeData.fromJson(Map? json) {
    if (json == null) {
      this.text = '';
      return;
    }
    this.text = json[JsonName.text] ?? '';
  }

  @override
  Map toJson() => {JsonName.text: text};
}

class ImageRadioTypeData extends RadioTypeData {
  String? text;
  String? image;

  ImageRadioTypeData(this.text, this.image);

  ImageRadioTypeData.fromJson(Map? json) {
    if (json == null) {
      this.text = '';
      this.image = '';
      return;
    }
    this.text = json[JsonName.text] ?? '';
    this.image = json[JsonName.image] ?? '';
  }

  @override
  Map toJson() => {JsonName.text: text, JsonName.image: image};
}

class PkRadioTypeData extends RadioTypeData {
  String? text;
  int? select;
  int? total;

  PkRadioTypeData(this.text, {this.select, this.total});

  PkRadioTypeData.fromJson(Map? json) {
    if (json == null) {
      text = '';
      return;
    }
    text = json[JsonName.text] ?? '';
    select = handleNum(json[JsonName.select]);
    total = handleNum(json[JsonName.total]);
  }

  @override
  Map toJson() => {
        JsonName.text: text,
        JsonName.select: select,
        JsonName.total: total,
      };

  bool get hasResult => total != null && select != null && total != 0;
}

class PkImageRadioTypeData extends RadioTypeData {
  String? text;
  String? image;
  int? select;
  int? total;

  PkImageRadioTypeData(this.text, this.image, {this.select, this.total});

  PkImageRadioTypeData.fromJson(Map? json) {
    if (json == null) {
      text = '';
      image = '';
      return;
    }
    text = json[JsonName.text] ?? '';
    image = json[JsonName.image] ?? '';
    select = handleNum(json[JsonName.select]);
    total = handleNum(json[JsonName.total]);
  }

  @override
  Map toJson() => {
        JsonName.text: text,
        JsonName.select: select,
        JsonName.total: total,
        JsonName.image: image,
      };

  bool get hasResult => total != null && select != null && total != 0;
}
