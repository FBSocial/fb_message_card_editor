import 'dart:math';

class RandomString {
  static const str =
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static final Random rnd = Random();

  static String length(int length) {
    final StringBuffer sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(str[rnd.nextInt(str.length)]);
    }
    return sb.toString();
  }
}
