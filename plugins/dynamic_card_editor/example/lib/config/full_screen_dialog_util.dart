import 'package:flutter/material.dart';

class FullScreenDialog {
  FullScreenDialog._internal();

  static FullScreenDialog _instance;

  static FullScreenDialog getInstance() {
    _instance ??= FullScreenDialog._internal();
    return _instance;
  }

  Future showDialog(BuildContext context, Widget child) {
    return Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (ctx, anm1, anm2) {
          return child;
        }));
  }
}
