class InputType {
  String? type;
  String? text;
  List<InputItem>? children;

  InputType({this.type, this.text, this.children});

  factory InputType.fromJson(Map<String, dynamic> json) {
    List<InputItem> result = [];
    if (json.containsKey('children')) {
      List temp = json["children"];
      for (var element in temp) {
        result.add(InputItem.fromJson(element));
      }
    }
    return InputType(
      type: json["type"],
      text: json["text"],
      children: result,
    );
  }
}

class InputItem {
  String? type;
  String? text;
  List<InputChild>? children;

  InputItem({this.type, this.text, this.children});

  factory InputItem.fromJson(Map<String, dynamic> json) {
    List<InputChild> result = [];
    if (json.containsKey('children')) {
      List temp = json["children"];
      for (var element in temp) {
        result.add(InputChild.fromJson(element));
      }
    }
    return InputItem(
      type: json["type"],
      text: json["text"],
      children: result,
    );
  }
}

class InputChild {
  String? type;
  String? text;
  String? file;

  InputChild({this.type, this.text, this.file});

  factory InputChild.fromJson(Map<String, dynamic> json) => InputChild(
        type: json["type"],
        text: json["text"],
        file: json["file"],
      );
}
