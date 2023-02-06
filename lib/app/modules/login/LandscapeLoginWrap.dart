import 'package:flutter/material.dart';

class LandscapeLoginWrap extends StatelessWidget {
  final Widget? child;

  const LandscapeLoginWrap({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5562F2).withOpacity(0.2),
      body: Center(
        child: Container(
          width: 400,
          height: 480,
          padding: EdgeInsets.all(20),
          decoration: webBorderDecoration,
          child: child,
        ),
      ),
    );
  }
}

final webBorderDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
    boxShadow: const [
      BoxShadow(
          blurRadius: 26,
          spreadRadius: 7,
          offset: Offset(0, 7),
          color: Color(0x1F717D8D))
    ]);
