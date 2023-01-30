import '../../dynamic_card.dart';
import 'package:flutter/material.dart';

class FormRadioItem extends StatelessWidget {
  final String? formId;
  final FormBuilder formBuilder;
  final NodeController? nodeController;

  const FormRadioItem(
      {Key? key, this.formId, required this.formBuilder, this.nodeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (formId == null || formId!.isEmpty || nodeController == null)
      return formBuilder.call(false);
    return ValueListenableBuilder<bool>(
        valueListenable: nodeController!.getItemEnableNotifier(formId!),
        builder: (ctx, value, child) {
          return AbsorbPointer(
              absorbing: !value, child: formBuilder.call(value));
        });
  }
}

typedef Widget FormBuilder(bool value);
