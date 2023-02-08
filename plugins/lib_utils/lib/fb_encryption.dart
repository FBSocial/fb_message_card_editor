import 'dart:convert';

final Map<String, String> _dictionary = {
  "A": "w",
  "B": "x",
  "C": "y",
  "D": "z",
  "E": "U",
  "F": "1",
  "G": "2",
  "H": "X",
  "I": "Y",
  "J": "5",
  "K": "a",
  "L": "b",
  "M": "8",
  "N": "d",
  "O": "+",
  "P": "f",
  "g": "Q",
  "h": "R",
  "i": "S",
  "j": "T",
  "k": "0",
  "l": "V",
  "m": "W",
  "n": "3",
  "o": "4",
  "p": "Z",
  "q": "6",
  "r": "7",
  "s": "c",
  "t": "9",
  "u": "e",
  "v": "/",
  "w": "A",
  "x": "B",
  "y": "C",
  "z": "D",
  "U": "E",
  "1": "F",
  "2": "G",
  "X": "H",
  "Y": "I",
  "5": "J",
  "a": "K",
  "b": "L",
  "8": "M",
  "d": "N",
  "+": "O",
  "f": "P",
  "Q": "g",
  "R": "h",
  "S": "i",
  "T": "j",
  "0": "k",
  "V": "l",
  "W": "m",
  "3": "n",
  "4": "o",
  "Z": "p",
  "6": "q",
  "7": "r",
  "c": "s",
  "9": "t",
  "e": "u",
  "/": "v",
};

String fbEncrypt(String origin) {
  final b64 = base64Encode(utf8.encode(origin));

  final encrypted = StringBuffer();
  for (var i = 0; i < b64.length; i++) {
    final c = b64[i];
    if (_dictionary.containsKey(c)) {
      encrypted.write(_dictionary[c]);
    } else {
      encrypted.write(c);
    }
  }

  return encrypted.toString();
}
