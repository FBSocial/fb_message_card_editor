import '../all.dart';

class ClickEvent {
  String? method;
  Map<String, dynamic>? param;

  ClickEvent(this.method, this.param);

  Map toJson() => {JsonName.method: method, JsonName.param: param};

  ClickEvent.fromJson(Map json) {
    if (json.isEmpty) {
      method = '';
      param = {};
      return;
    }
    method = json[JsonName.method] ?? '';
    param = json[JsonName.param] ?? {};
  }
}
