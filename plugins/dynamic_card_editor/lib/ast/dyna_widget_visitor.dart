import 'package:dynamic_card/widgets/title/vote_title.dart';

import '../widget_nodes/all.dart';
import '../widgets/all.dart';
import 'ast.dart';
import 'package:flutter/material.dart';

class DynaWidgetVisitor extends AstVisitor<Widget> {
  @override
  Widget visitNode(AstNode node) => node.accept(this);

  @override
  Widget visitContainer(ContainerNode node) =>
      ContainerWidget(child: node.child == null ? null : visitNode(node.child!));

  @override
  Widget visitColumn(ColumnNode node) => ColumnWidget(
        children: node.children?.map((e) {
          if (e is WidgetNode) e.config = node.config;
          return visitNode(e);
        }).toList(),
        config: node.config,
      );

  @override
  Widget visitTitleNode(TitleNode node) =>
      TitleWidget(data: node.data, config: node.config);

  @override
  Widget visitIconTitleNode(IconTitleNode node) =>
      IconTitleWidget(data: node.data, config: node.config);

  @override
  Widget visitTextNode(TextNode node) =>
      TextWidget(data: node.data, config: node.config);

  @override
  Widget visitTitleTextNode(TitleTextNode node) =>
      TitleTextWidget(data: node.data, config: node.config);

  @override
  Widget visitMultiTextNode(MultiTextNode node) =>
      MultiTextWidget(data: node.data, config: node.config);

  @override
  Widget visitHintTextNode(HintTextNode node) =>
      HintTextWidget(data: node.data, config: node.config);

  @override
  Widget visitContentTextNode(ContentTextNode node) =>
      ContentTextWidget(data: node.data, config: node.config);

  @override
  Widget visitRadioNode(RadioNode node) => RadioWidget(
      radioData: node.data, config: node.config, rootParam: node.rootParam);

  @override
  Widget visitInputNode(InputNode node) => InputWidget(
      data: node.data, config: node.config, rootParam: node.rootParam);

  @override
  Widget visitDropdownNode(DropdownButtonNode node) =>
      DropdownButtonWidget(data: node.data, config: node.config);

  @override
  Widget visitButtonNode(ButtonNode node) => ButtonWidget(
      data: node.data,
      callback: node.buttonCallback,
      config: node.config,
      rootParam: node.rootParam);

  @override
  Widget visitImageNode(ImageNode node) =>
      ImageWidget(data: node.data, config: node.config);

  @override
  Widget visitDividerNode(DividerNode node) =>
      DividerWidget(config: node.config);

  @override
  Widget visitVoteTitle(VoteTitleNode node) =>
      VoteTitleWidget(data: node.data, config: node.config);

  @override
  Widget visitVoteTextNode(VoteTextNode node) =>
      VoteTextWidget(data: node.data, config: node.config);

  @override
  Widget visitGapDividerNode(GapDividerNode node) =>
      GapDividerWidget(data: node.data, config: node.config);
}
