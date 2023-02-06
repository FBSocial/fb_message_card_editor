@JS()
library cookies;

import 'package:js/js.dart';

@JS('Cookies')
class CookieUtils {
  // Cookies.set('name', 'value', { domain: 'subdomain.site.com',path: '', secure: true, expires: 7  })
  external static String set(
      String name, String value, SetCookieOptions options);

  external static String get(String name);
}

@JS('SetCookieOptions')
@anonymous
class SetCookieOptions {
  external factory SetCookieOptions({
    String domain,
    String path,
    bool secure,
    int expires,
  });
  external String get domain;
  external String get path;
  external bool get secure;
  external int get expires;
}
