import 'package:flutter/material.dart';

import '../main.dart';
import 'full_screen_dialog_util.dart';

class ToastWidget {
  factory ToastWidget() {
    _instance ??= ToastWidget._internal();
    return _instance;
  }

  ToastWidget._internal();

  static ToastWidget _instance;

  bool isShowing = false;

  void _showToast(BuildContext context, Widget widget, int second) {
    if (!isShowing) {
      isShowing = true;
      FullScreenDialog.getInstance().showDialog(
        context,
        widget,
      );
      Future.delayed(
          Duration(
            seconds: second,
          ), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          isShowing = false;
        } else {
          isShowing = false;
        }
      });
    }
  }

  void showToast(String text,
      {int second = 3, Color color = Colors.redAccent}) {
    final widget = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(
              4,
            )),
            color: color),
        width: 350,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Material(
          color: Colors.transparent,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
    _showToast(globalKey.currentContext, widget, second);
  }
}
