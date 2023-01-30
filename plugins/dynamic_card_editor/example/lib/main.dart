import 'dart:convert';

import 'package:dynamic_card/dynamic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/all.dart';
import 'config/edit_formId_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '动态组件',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: globalKey,
      home: MyHomePage(title: '动态组件'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final nodeController = NodeController();

  ValueNotifier<List<WidgetNode>> outputNodes = ValueNotifier([]);

  ValueNotifier<Map> outputJson = ValueNotifier({});

  @override
  void dispose() {
    textController.dispose();
    nodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F8),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          buildCardInput(),
          buildCardOutput(),
          buildCardJson(),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildCardInput() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ...template(),
          ...texts(),
          ...titles(),
          ...selectors(),
          ...inputs(),
          ...dividers(),
          ...buttons(),
          ...images(),
        ],
      ),
    );
  }

  List<Widget> template() {
    return [
      buildBanner(icon: Icons.ten_mp, color: Color(0xff4285F4), text: '模板'),
      CusButton(
        onTap: () {
          addNode(VoteTitleNode(VoteTitleData('匿名投票', bg: 0)));
          addNode(RadioNode(RadioData(radioDetails: [
            RadioDetail(pre: 'A. ', radioTypeData: CommonRadioTypeData('哇哈哈')),
            RadioDetail(pre: 'B. ', radioTypeData: CommonRadioTypeData('奶茶')),
            RadioDetail(pre: 'C. ', radioTypeData: CommonRadioTypeData('快乐水')),
          ], maxEnableSelect: 1)));
          addNode(ButtonNode(ButtonData([ButtonDetailData('投票')])));
        },
        text: '发起投票',
      ),
      CusButton(
        onTap: () {
          addNode(IconTitleNode(IconTitleData('投票结果',
              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Video-Game-Controller-Icon-IDV-green.svg/249px-Video-Game-Controller-Icon-IDV-green.svg.png',
              type: WidgetName.iconBgTitle)));
          addNode(ContentTextNode(ContentTextData('你觉得哪家饮料好吃？')));
          addNode(
              VoteTextNode(VoteTextData(20, 0.3, type: 0, text: 'A.娃哈哈(已选)')));
          addNode(VoteTextNode(VoteTextData(20, 0.3, type: 1, text: 'B.奶茶')));
          addNode(VoteTextNode(VoteTextData(20, 0.3, type: 1, text: 'C.快乐水')));
        },
        text: '投票结果',
      ),
    ];
  }

  List<Widget> texts() {
    return [
      buildBanner(
          icon: Icons.text_fields, color: Color(0xff4285F4), text: '文本'),
      CusButton(
        onTap: () {
          addNode(TextNode(TextData('我是文本')));
        },
        text: '文本',
      ),
      CusButton(
          onTap: () {
            addNode(TitleTextNode(TitleTextData([
              TitleTextDetail('内容文字内容文字', '标题：'),
            ])));
          },
          text: '标题&内容文本'),
      CusButton(
          onTap: () {
            addNode(TitleTextNode(TitleTextData([
              TitleTextDetail(
                '内容文字内容文字',
                '标题：',
                type: TitleTextDetail.diffColor,
              ),
            ])));
          },
          text: '标题&内容文本(颜色区分)'),
      CusButton(
        onTap: () {
          addNode(TitleTextNode(TitleTextData([
            TitleTextDetail(
              '小明、小张、小李、叽叽歪歪歪歪歪歪歪歪歪',
              '一等奖：',
              type: TitleTextDetail.diffColor,
            ),
            TitleTextDetail(
              '小明、小张、小王',
              '二等奖：',
              type: TitleTextDetail.diffColor,
            ),
            TitleTextDetail(
              '6人',
              '中奖人数：',
              type: TitleTextDetail.diffColor,
            ),
            TitleTextDetail(
              '2月14日 03:00',
              '截止时间：',
              type: TitleTextDetail.diffColor,
            ),
          ])));
        },
        text: '标题&内容组合模块样式',
      ),
      CusButton(
          onTap: () {
            addNode(MultiTextNode(MultiTextData([
              MultiTextDetail([
                TextDetail('创建人', type: TextDetail.bold),
                TextDetail('jessica'),
              ]),
              MultiTextDetail([
                TextDetail('创建人', type: TextDetail.bold),
                TextDetail('杨杨杨杨杨'),
              ]),
              MultiTextDetail([
                TextDetail('创建人', type: TextDetail.bold),
                TextDetail('杨杨杨杨杨' * 3),
              ]),
            ])));
          },
          text: '多列文本'),
      CusButton(
        onTap: () {
          addNode(HintTextNode(HintTextData('288人参与', '@杨杨杨杨杨杨杨杨杨杨创建')));
        },
        text: '提示文本',
      ),
      CusButton(
        onTap: () {
          addNode(ContentTextNode(ContentTextData('你觉得哪家火锅好吃？')));
        },
        text: '内容一级标题',
      ),
      CusButton(
        onTap: () {
          addNode(
            ContentTextNode(
                ContentTextData('1.在玩的游戏', type: ContentTextData.h2)),
          );
        },
        text: '内容二级标题',
      ),
    ];
  }

  List<Widget> titles() {
    return [
      buildBanner(icon: Icons.title, color: Color(0xff6666CC), text: '标题'),
      CusButton(
        onTap: () {
          addNode(TitleNode(TitleData('我是标题')));
        },
        text: '普通标题',
      ),
      CusButton(
          onTap: () {
            addNode(IconTitleNode(IconTitleData('我是标题与Icon',
                'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Video-Game-Controller-Icon-IDV-green.svg/249px-Video-Game-Controller-Icon-IDV-green.svg.png',
                status: 2)));
          },
          text: '图标&文字'),
      CusButton(
        onTap: () {
          addNode(IconTitleNode(IconTitleData(
            '我是标题与Icon',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Video-Game-Controller-Icon-IDV-green.svg/249px-Video-Game-Controller-Icon-IDV-green.svg.png',
            type: WidgetName.iconBgTitle,
          )));
        },
        text: '图标&文字&色块',
      ),
      CusButton(
        onTap: () {
          addNode(VoteTitleNode(VoteTitleData('匿名投票', bg: 0)));
        },
        text: '投票标题',
      ),
    ];
  }

  List<Widget> selectors() {
    return [
      buildBanner(
          icon: Icons.radio_button_on, color: Color(0xff66CCCC), text: '选择'),
      CusButton(
        onTap: () {
          addNode(RadioNode(RadioData(radioDetails: [
            RadioDetail(pre: 'A. ', radioTypeData: CommonRadioTypeData('哇哈哈')),
            RadioDetail(pre: 'B. ', radioTypeData: CommonRadioTypeData('奶茶')),
            RadioDetail(pre: 'C. ', radioTypeData: CommonRadioTypeData('快乐水')),
          ], maxEnableSelect: 1)));
        },
        text: '单选',
      ),
      CusButton(
          onTap: () {
            addNode(RadioNode(RadioData(radioDetails: [
              RadioDetail(
                pre: 'A',
                type: RadioDetail.IMAGE_TEXT,
                radioTypeData: ImageRadioTypeData('哇哈哈',
                    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg2.tbcdn.cn%2Ftfscom%2Fi1%2F3370659731%2FTB2EzTKeuEJL1JjSZFGXXa6OXXa_%21%213370659731.jpg&refer=http%3A%2F%2Fimg2.tbcdn.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625908836&t=95fcaee906714f9787ac70ddc19b2207'),
              ),
              RadioDetail(
                pre: 'B',
                type: RadioDetail.IMAGE_TEXT,
                radioTypeData: ImageRadioTypeData('奶茶',
                    'https://pics0.baidu.com/feed/79f0f736afc37931f2e2e66bfdf8214342a911a8.jpeg?token=85622e75e4a18492ab9199d6afe268e8'),
              ),
              RadioDetail(
                pre: 'C',
                type: RadioDetail.IMAGE_TEXT,
                radioTypeData: ImageRadioTypeData('快乐水',
                    'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2204647049,3508223872&fm=224&gp=0.jpg'),
              ),
            ], maxEnableSelect: 3)));
          },
          text: '多选'),
      CusButton(
          onTap: () {
            addNode(RadioNode(
              RadioData(
                radioDetails: [
                  RadioDetail(
                    type: RadioDetail.PK_TEXT,
                    radioTypeData: PkRadioTypeData('郭德纲'),
                  ),
                  RadioDetail(
                    type: RadioDetail.PK_TEXT,
                    radioTypeData: PkRadioTypeData('郭麒麟'),
                  ),
                ],
                layout: RadioData.GRID_LAYOUT,
              ),
            ));
          },
          text: 'PK/文字样式'),
      CusButton(
          onTap: () {
            addNode(RadioNode(
              RadioData(
                radioDetails: [
                  RadioDetail(
                    type: RadioDetail.PK_IMAGE,
                    radioTypeData: PkImageRadioTypeData('凑凑火锅',
                        'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnews.winshang.com%2Fmember%2FFCK%2F2018%2F10%2F22%2F20181022105412663943x.jpg&refer=http%3A%2F%2Fnews.winshang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626422889&t=72f87125e9094726caf2ac1cf009e2b0'),
                  ),
                  RadioDetail(
                    type: RadioDetail.PK_IMAGE,
                    radioTypeData: PkImageRadioTypeData('四季椰林',
                        'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.dianzhangzhipin.com%2Fblueapp%2Fcommon%2Fimages%2Fimage%2F20191213%2F6b57438cbdb8cdfdafb85aa102a4bd19.jpg&refer=http%3A%2F%2Fimg.dianzhangzhipin.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626422919&t=95cb9550bb10bce05f388c39ade14df2'),
                  ),
                ],
                layout: RadioData.GRID_LAYOUT,
              ),
            ));
          },
          text: 'PK/图文样式'),
      CusButton(
        onTap: () {
          addNode(VoteTextNode(VoteTextData(20, 0.3, type: 1, text: 'A')));
        },
        text: '投票按钮展示页',
      ),
      CusButton(
        onTap: () {
          addNode(VoteTextNode(VoteTextData(20, 0.3,
              type: 1,
              pre: 'A',
              image:
                  'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.dianzhangzhipin.com%2Fblueapp%2Fcommon%2Fimages%2Fimage%2F20191213%2F6b57438cbdb8cdfdafb85aa102a4bd19.jpg&refer=http%3A%2F%2Fimg.dianzhangzhipin.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626422919&t=95cb9550bb10bce05f388c39ade14df2',
              text: '四季椰林')));
        },
        text: '投票按钮展示页-带图片',
      ),
    ];
  }

  List<Widget> inputs() {
    return [
      buildBanner(icon: Icons.keyboard, color: Color(0xff34A853), text: '输入框'),
      CusButton(
        onTap: () {
          addNode(InputNode(InputData('')));
        },
        text: '输入框',
      ),
    ];
  }

  List<Widget> dividers() {
    return [
      buildBanner(icon: Icons.linear_scale, color: Colors.black, text: '分割线'),
      CusButton(
        onTap: () {
          addNode(DividerNode());
        },
        text: '分割线',
      ),
    ];
  }

  List<Widget> buttons() {
    return [
      buildBanner(icon: Icons.mouse, color: Color(0xffFF9901), text: '按钮'),
      CusButton(
        onTap: () {
          addNode(DropdownButtonNode(
              DropdownData(['刘玄德', '关云长', '张翼德', '诸葛孔明', '赵子龙'])));
        },
        text: '下拉选择框',
      ),
      CusButton(
        onTap: () {
          addNode(ButtonNode(ButtonData([ButtonDetailData('按钮一')])));
        },
        text: '普通按钮',
      ),
      CusButton(
        onTap: () {
          addNode(ButtonNode(ButtonData([
            ButtonDetailData('按钮一',
                event: ClickEvent('request', {'url': 'aaaa'})),
            ButtonDetailData('按钮二', event: ClickEvent('request', null)),
          ])));
        },
        text: '横向双按钮',
      ),
      CusButton(
        onTap: () {
          addNode(ButtonNode(ButtonData(
              [ButtonDetailData('按钮一', type: ButtonDetailData.textButton)])));
        },
        text: '文字按钮',
      ),
      CusButton(
        onTap: () {
          addNode(ButtonNode(ButtonData([
            ButtonDetailData('按钮一', type: ButtonDetailData.textButton),
            ButtonDetailData('按钮二', type: ButtonDetailData.textButton),
          ])));
        },
        text: '文字横向双按钮',
      ),
      CusButton(
        onTap: () {
          addNode(ButtonNode(ButtonData([
            ButtonDetailData('你已同意该申请', type: ButtonDetailData.disableButton)
          ])));
        },
        text: '文字按钮不可点击',
      ),
    ];
  }

  List<Widget> images() {
    return [
      buildBanner(icon: Icons.image, color: Color(0xffEA4435), text: '图片'),
      CusButton(
        onTap: () {
          addNode(ImageNode(ImageData(
              'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201303%2F16%2F173710lvx470i4348z6i6z.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626853639&t=e1f7c3f4e743f660ee81ad562b18984c')));
        },
        text: 'S号图片',
      ),
      CusButton(
        onTap: () {
          addNode(ImageNode(
            ImageData(
              'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201303%2F16%2F173710lvx470i4348z6i6z.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626853639&t=e1f7c3f4e743f660ee81ad562b18984c',
              type: ImageData.medium,
            ),
          ));
        },
        text: 'M号图片',
      ),
      CusButton(
        onTap: () {
          addNode(ImageNode(
            ImageData(
              'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201303%2F16%2F173710lvx470i4348z6i6z.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626853639&t=e1f7c3f4e743f660ee81ad562b18984c',
              type: ImageData.large,
            ),
          ));
        },
        text: 'L号图片',
      ),
    ];
  }

  Widget buildBanner({IconData icon, Color color, String text}) {
    return Container(
      child: Row(
        children: [
          Icon(
            icon ?? Icons.details,
            color: color ?? Colors.black,
            size: 24,
          ),
          SizedBox(width: 2),
          Text(
            text ?? '',
            style: TextStyle(color: Color(0xff686A6D), fontSize: 15),
          )
        ],
      ),
    );
  }

  Widget buildCardOutput() {
    return Container(
      width: 304,
      child: ValueListenableBuilder<List<WidgetNode>>(
          valueListenable: outputNodes,
          builder: (ctx, value, _) {
            if (value.length == 0) return SizedBox();
            // return ReorderableListView(
            //   children: List.generate(value.length, (index){
            //     final widget = widgetVisitor.visitNode(value[index]);
            //     return HoverEditWidget(
            //       key: ValueKey(index),
            //       child: widget,
            //       onDelete: () => removeIndex(index),
            //       onEdit: () {},
            //     );
            //   }),
            //   onReorder: (oldIndex, newIndex) => changeNode(oldIndex, newIndex),
            // );
            return ReorderableListView.builder(
              buildDefaultDragHandles: false,
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) {
                final node = value[index];
                final widget = widgetVisitor.visitNode(node);
                return HoverEditWidget(
                  key: ValueKey(index),
                  index: index,
                  child: widget,
                  onDelete: () => removeIndex(index),
                  onEditFormId: () async {
                    final String value =
                        await FullScreenDialog.getInstance().showDialog(
                            context,
                            EditFormIdDialog(
                              formId: node.rootParam?.formId,
                            ));
                    final json = jsonVisitor.visitNode(node);
                    if (value != null && value.isNotEmpty) {
                      json['formId'] = value;
                    } else {
                      json['formId'] = null;
                    }
                    final newNode = JsonToNodeParser.instance.toNode(
                      json,
                      config: TempWidgetConfig(controller: nodeController),
                    );
                    updateNode(index, newNode);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (value != null && value.isNotEmpty)
                        nodeController.refreshButtonValue(value);
                      else
                        nodeController.removeForm(
                            node.rootParam?.formId, newNode);
                    });
                  },
                  onEdit: () async {
                    final value =
                        await FullScreenDialog.getInstance().showDialog(
                            context,
                            EditDialog(
                              json: jsonVisitor.visitNode(node),
                              node: node,
                            ));
                    if (value != null && value is WidgetNode) {
                      updateNode(index, value);
                    }
                  },
                );
              },
              itemCount: value.length,
              onReorder: (oldIndex, newIndex) => changeNode(oldIndex, newIndex),
            );
          }),
    );
  }

  Widget buildCardJson() {
    return ValueListenableBuilder(
        valueListenable: outputJson,
        builder: (ctx, value, _) {
          return Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  color: Color(0xffF7F7F8),
                  child: ScrollSelectText(input: getPrettyJSONString(value)),
                ),
                if ((value as Map).isNotEmpty)
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: jsonEncode(value)));
                        ToastWidget()
                            .showToast('复制成功', second: 1, color: Colors.blue);
                      },
                    ),
                    top: 10,
                    right: 10,
                  )
              ],
            ),
          );
        });
  }

  void removeIndex(int index) {
    final value = List.of(nodes);
    final node = value.removeAt(index);
    nodeController.removeForm(node.rootParam?.formId, node);
    outputNodes.value = value;
    updateJson();
  }

  void addNode(WidgetNode node) {
    final value = List.of(nodes);
    value.add(node);
    outputNodes.value = value;
    updateJson();
  }

  void updateJson() {
    final text = jsonVisitor.visitColumn(ColumnNode(nodes));
    outputJson.value = text;
  }

  void changeNode(int oldIndex, int newIndex) {
    final value = List.of(nodes);
    final old = value.removeAt(oldIndex);
    if (newIndex > value.length)
      value.add(old);
    else
      value.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, old);
    outputNodes.value = value;
    updateJson();
  }

  void updateNode(int index, WidgetNode node) {
    final value = List.of(nodes);
    value[index] = node;
    outputNodes.value = value;
    updateJson();
  }

  List<WidgetNode> get nodes => outputNodes.value;
}

final widgetVisitor = DynaWidgetVisitor();

final jsonVisitor = JsonWidgetVisitor();

final globalKey = GlobalKey<NavigatorState>();
