import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final Widget? child;

  const ContainerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child ?? Container();
  }
}
