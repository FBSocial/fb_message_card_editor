import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter_cipher/flutter_cipher.dart';
// ignore: leading_newlines_in_multiline_strings
const _publicKey = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDF8yMzDqMl5MpMvfqfo30rnEqF
KtutVKswyURpJD3O94ECE8vC1xtcwYBtCGcppgAvnzjtKJTiZYnLT/KOYlg1yShb
nu0MAtVKASvSbDGgkUGcuBnDsDu2jo40CV9kEcbc5QID5uCXjrr+J1nGoaIMdix8
md+vUFTIZbt+NnxrnQIDAQAB
-----END PUBLIC KEY-----''';

String decodeString(String content) {
  const publicKeyStr = _publicKey;
  final publicKey =  RSAKeyParser().parse(publicKeyStr);
  final Asymmetric rsa = Cipher.getAsymmetricInstance(RSA(publicKey: publicKey as RSAPublicKey));

  final Uint8List sourceBytes = base64.decode(content);
  final int inputLen = sourceBytes.length;
  const int maxLen = 128;
  final StringBuffer totalBytes = StringBuffer();
  for (var i = 0; i < inputLen; i += maxLen) {
    final int endLen = inputLen - i;
    Uint8List item;
    if (endLen > maxLen) {
      item = sourceBytes.sublist(i, i + maxLen);
    } else {
      item = sourceBytes.sublist(i, i + endLen);
    }
    final Encrypted en = Encrypted(item);
    final String s =  rsa.decryptPublic(en);
    totalBytes.write(s);
  }
  return  totalBytes.toString();
}