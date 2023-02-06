import 'package:flutter/material.dart';

extension WidgetExtension on StatelessWidget {
  MouseRegion clickable() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: this,
      );
}

extension CustomScrollViewExtension on CustomScrollView {
  CustomScrollView addWebPaddingBottom() =>
      this..slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 150)));
}
