import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dynamic_card/dynamic_card.dart';
import 'package:fb_message_card_editor/app/modules/home/bean/input_bean.dart';
import 'package:fb_message_card_editor/app/modules/home/bindings/delete_notify.dart';
import 'package:fb_message_card_editor/app/modules/home/views/card_preview_widget.dart';
import 'package:fb_message_card_editor/app/routes/app_pages.dart';
import 'package:fb_message_card_editor/theme/app_theme.dart';
import 'package:fb_message_card_editor/theme/const.dart';
import 'package:fb_message_card_editor/util/config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_editor/json_editor.dart';
import 'package:lib_utils/universal_platform.dart';
import 'package:x_picker/x_picker.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  static const double leftWidth = 330;
  static const double centerWidth = 500;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Scaffold(
        body: Row(
          children: [
            _leftView(),
            _centerView(_centerDynamicWidget(context, constrains)),
            _rightView(_rightJsonWidget())
          ],
        ),
      );
    });
  }

  XFile? xfile;
  String? imagesUrl;

  _showImagePikerDialog(BuildContext context, int index) {
    xfile = null;
    controller.uploadImageUrl == null;
    showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('更换图片', style: appThemeData.textTheme.titleMedium),
              content: Container(
                color: Colors.white,
                width: 440,
                height: 260,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('上传图片', style: appThemeData.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      GetBuilder<HomeController>(
                          id: controller.updateImage,
                          builder: (c) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropTarget(
                                  onDragDone: (detail) {
                                    _dragDone(detail, index);
                                  },
                                  child: UniversalPlatform.isWeb &&
                                          controller.uploadImageUrl != null
                                      ? viewNetImage(controller.uploadImageUrl!)
                                      : xfile == null
                                          ? Center(
                                              child: uploadImage(index),
                                            )
                                          : viewImage(xfile!),
                                ),
                                if (xfile != null ||
                                    controller.uploadImageUrl != null) ...[
                                  sizeHeight8,
                                  GestureDetector(
                                    child: Text(
                                      '重新上传',
                                      style: appThemeData.textTheme.titleMedium
                                          ?.copyWith(
                                              fontSize: 14, color: Colors.blue),
                                    ),
                                    onTap: () async {
                                      xfile = null;
                                      controller.uploadImageUrl = null;
                                      controller
                                          .update([controller.updateImage]);
                                      _choiceFilepick(index);
                                    },
                                  ),
                                ]
                              ],
                            );
                          }),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildMaterialButton('取消', () {
                            Navigator.pop(Get.context!);
                          }),
                          const SizedBox(width: 10),
                          buildMaterialButton('确定', () {
                            if (xfile != null) {
                              if (UniversalPlatform.isWeb) {
                                controller.uploadImageUrl = null;
                              } else {
                                controller.uploadImage(xfile!, index);
                              }
                              Navigator.pop(Get.context!);
                            }
                          },
                              bgColor: const Color(0xFF198CFE),
                              txtColor: Colors.white)
                        ],
                      )
                    ],
                  ),
                ),
              ));
        }).then((val) {
      print(val);
    });
  }

  static final imageType = ["gif", "jpg", "jpeg", "png", "bmp", "webp"];

  Widget uploadImage(int index) => Container(
        width: 400,
        height: 160,
        // 虚线框使用的是一个第三方插件dotted_decoration
        decoration: DottedDecoration(
          color: Colors.blue,
          shape: Shape.box,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 60, color: Colors.blue),
            sizeHeight8,
            GestureDetector(
              onTap: () async {
                _choiceFilepick(index);
              },
              child: Text(
                '拖拽文件至此，或 选择文件上传',
                style: appThemeData.textTheme.titleMedium
                    ?.copyWith(fontSize: 14, color: Colors.blue),
              ),
            ),
            sizeHeight8,
            Text(
              '支持 JPEG/PNG/GIF 格式，大小不超过 10 MB',
              style: appThemeData.textTheme.titleMedium
                  ?.copyWith(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );

  _choiceFilepick(int index) async {
    List<XFile> picks = await XPicker.instance.pickFiles(
        dialogTitle: "打开",
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: imageType,
        withData: true);
    if (picks != null && picks.isNotEmpty) {
      xfile = picks[0];
      controller.update([controller.updateImage]);
      if (UniversalPlatform.isWeb) {
        controller.uploadImage(xfile!, index);
        Navigator.pop(Get.context!);
      }
    }
  }

  void _dragDone(DropDoneDetails detail, int index) {
    xfile = detail.files.last;
    controller.update([controller.updateImage]);
    print('file:${xfile?.path}');
    if (UniversalPlatform.isWeb) {
      controller.uploadImage(xfile!, index);
      Navigator.pop(Get.context!);
    }
  }

  Widget viewNetImage(String file) => Container(
        width: 400,
        height: 160,
        // 虚线框使用的是一个第三方插件dotted_decoration
        decoration: DottedDecoration(
          color: Colors.blue,
          shape: Shape.box,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Image.network(
          file,
          width: 400,
          height: 160,
        ),
      );

  Widget viewImage(XFile file) => Container(
        width: 400,
        height: 160,
        // 虚线框使用的是一个第三方插件dotted_decoration
        decoration: DottedDecoration(
          color: Colors.blue,
          shape: Shape.box,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: kIsWeb
            ? Container()
            : Image.file(
                File(file.path),
                width: 400,
                height: 160,
              ),
      );

  _dynamicWidget(BuildContext context, Map<String, dynamic>? map) {
    return DynamicWidget(
        json: map,
        config: TempWidgetConfig(
            radioConfig: RadioConfig(
              singleSelected: Icon(
                Icons.radio_button_on,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              groupSelected: Icon(
                Icons.radio_button_on_sharp,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            buttonConfig: ButtonConfig(
              dropdownConfig: DropdownConfig(
                dropdownIcon: () =>
                    const Icon(Icons.arrow_drop_down, color: color3),
              ),
            ),
            commonConfig: CommonConfig(
                widgetWith: UniversalPlatform.isMacOS || kIsWeb ? 300 : 100)));
  }

  _centerView(Widget child) => Container(
        padding: const EdgeInsets.all(20),
        width: centerWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _deleteBtn(),
              Row(
                children: [
                  _sendToMeBtn(),
                  sizeWidth8,
                  _sendToGuildBtn(),
                  sizeWidth8,
                  _saveBtn(),
                ],
              )
            ]),
            const SizedBox(height: 10),
            Text('卡片预览', style: appThemeData.textTheme.titleMedium),
            buildChinaText(),
            _dividerW(),
            Expanded(child: child)
          ],
        ),
      );

  _deleteBtn() => buildMaterialButton('清空', controller.removeAll);

  _sendToMeBtn() => buildMaterialButton('向我发送预览', _sendToMeDialog);

  _saveBtn() => buildMaterialButton('保存', controller.save);

  _sendToGuildBtn() => buildMaterialButton('发送到服务器', _sendToGuildDialog,
      bgColor: const Color(0xFF198CFE), txtColor: Colors.white);

  _sendToGuildDialog() => showDialog<Null>(
          context: Get.context!,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title:
                    Text('发送到服务器', style: appThemeData.textTheme.titleMedium),
                content: Container(
                  color: Colors.white,
                  width: 300,
                  height: 440,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('发送到，1926服务器，卡片编辑器频道',
                          style: appThemeData.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Image.asset(
                        "${Config.ASSETS_IMG}invite.jpg",
                        width: 240,
                        height: 360,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildMaterialButton('取消', () {
                            Navigator.pop(Get.context!);
                          }),
                          Expanded(child: Container()),
                          buildMaterialButton('立即发送', () async {
                            await controller.sendToGuild();
                            Navigator.pop(context);
                          },
                              bgColor: const Color(0xFF198CFE),
                              txtColor: Colors.white)
                        ],
                      )
                    ],
                  ),
                ));
          }).then((val) {
        print(val);
      });

  _sendToMeDialog() => showDialog<Null>(
          context: Get.context!,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title:
                    Text('向我发送预览', style: appThemeData.textTheme.titleMedium),
                content: Container(
                  color: Colors.white,
                  width: 300,
                  height: 440,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('请先加入服务器',
                          style: appThemeData.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Image.asset(
                        "${Config.ASSETS_IMG}invite.jpg",
                        width: 240,
                        height: 360,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildMaterialButton('取消', () {
                            Navigator.pop(Get.context!);
                          }),
                          Expanded(child: Container()),
                          buildMaterialButton('已经加入，立即发送', () async {
                            await controller.sendToMe();
                            Navigator.pop(context);
                          },
                              bgColor: const Color(0xFF198CFE),
                              txtColor: Colors.white)
                        ],
                      )
                    ],
                  ),
                ));
          }).then((val) {
        print(val);
      });

  _logout() => buildMaterialButton('退出登录', () async {
        showDialog<Null>(
            context: Get.context!,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                  title:
                      Text('退出登录', style: appThemeData.textTheme.titleMedium),
                  actions: [],
                  content: Container(
                    color: Colors.white,
                    width: 340,
                    height: 100,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('是否退出登录',
                              style: appThemeData.textTheme.titleMedium),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildMaterialButton('取消', () {
                                Navigator.pop(Get.context!);
                              }),
                              const SizedBox(width: 10),
                              buildMaterialButton('确定', () {
                                controller.logout();
                                Get.offAndToNamed(Routes.LOGIN);
                              },
                                  bgColor: const Color(0xFF198CFE),
                                  txtColor: Colors.white)
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            }).then((val) {
          print(val);
        });
      }, bgColor: const Color(0xFF198CFE), txtColor: Colors.white);

  MaterialButton buildMaterialButton(String text, VoidCallback onPress,
          {Color bgColor = Colors.white,
          Color txtColor = const Color(0xFF1A2033)}) =>
      MaterialButton(
        color: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: const Color(0xFF1A2033).withOpacity(0.2),
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        height: 38,
        onPressed: onPress,
        child: Text(
          text,
          style: appThemeData.textTheme.titleMedium
              ?.copyWith(fontSize: 14, color: txtColor),
        ),
      );

  _dividerW() => Container(
        color: Colors.grey.withOpacity(0.5),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        width: 400,
        height: 0.5,
      );

  _divider() => Container(
        color: Colors.grey.withOpacity(0.5),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        height: 0.5,
      );

  _centerDynamicWidget(BuildContext context, constrains) =>
      GetBuilder<HomeController>(
        id: controller.updateDynamicWidget,
        builder: (c) {
          Widget dy = DynamicWidget(
            canDrag: true,
            showMouse: true,
            json: controller.showMap,
            itemClick: (type, index, newIndex) {
              _dealClick(type, index, newIndex);
            },
            config: TempWidgetConfig(
                radioConfig: RadioConfig(
                  singleSelected: Icon(
                    Icons.radio_button_on,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  groupSelected: Icon(
                    Icons.radio_button_on_sharp,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                buttonConfig: ButtonConfig(
                  dropdownConfig: DropdownConfig(
                    dropdownIcon: () =>
                        const Icon(Icons.arrow_drop_down, color: color3),
                  ),
                ),
                commonConfig: CommonConfig(
                    widgetWith: UniversalPlatform.isMacOS || kIsWeb
                        ? centerWidth
                        : constrains.maxWidth)),
          );
          Widget result = Column(
            children: [const Text(''), dy],
          );
          return NotificationListener(
            child: dy,
            onNotification: (n) {
              if (n is CardOnTapNotification) {
                _dealClick(n.opt, n.index, 0);
                return true;
              }
              return false;
            },
          );
        },
      );

  _dealClick(OptType n, int index, int newIndex) {
    if (n == OptType.remove) {
      controller.removeIndex(index);
    } else if (n == OptType.up) {
      controller.upIndex(index);
    } else if (n == OptType.down) {
      controller.downIndex(index);
    } else if (n == OptType.replase) {
      controller.replease(index, newIndex);
    } else if (n == OptType.modifyImage) {
      _showImagePikerDialog(Get.context!, index);
    }
  }

  _rightView(Widget child) => Expanded(
          child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('卡片编辑', style: appThemeData.textTheme.titleMedium),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_all_outlined,
                          color: Colors.cyanAccent),
                      tooltip: '复制Json',
                      onPressed: () {
                        controller.copyValue();
                      },
                    ),
                    _logout()
                  ],
                )
              ],
            ),
            _divider(),
            child
          ],
        ),
      ));

  _rightJsonWidget() => GetBuilder<HomeController>(
      id: controller.updateShowJsonMap,
      builder: (c) {
        return Expanded(
            child: JsonEditorTheme(
                themeData: JsonEditorThemeData.defaultTheme(),
                child: JsonEditor.object(
                  object: controller.showMap,
                  onValueChanged: (value) {
                    if (kDebugMode) {
                      print(value);
                    }
                    controller.updateShowMap(value);
                  },
                )));
      });

  _leftView() {
    final tabs = Container(
      height: 48,
      width: leftWidth,
      color: Colors.white,
      child: SizedBox(
        height: 32,
        child: TabBar(
          indicatorWeight: 0,
          tabs: controller.spList
              .map((e) => Tab(
                  child: Text(e,
                      style: Theme.of(Get.context!).textTheme.titleSmall)))
              .toList(),
          labelColor: Colors.blueAccent,
          unselectedLabelColor: const Color(0xFF5C6273).withOpacity(0.8),
          unselectedLabelStyle: Theme.of(Get.context!).textTheme.titleSmall,
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: Colors.blueAccent),
          ),
          indicatorPadding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        ),
      ),
    );
    final tabBarView = Container(
      width: leftWidth,
      color: Colors.white,
      child: TabBarView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _materWidget(),
          _leftWidget(),
          _saveWidget(),
        ],
      ),
    );

    return Column(children: [tabs, Expanded(child: tabBarView)]);
  }

  _materWidget() => SingleChildScrollView(
        child: FutureBuilder(
          future: controller.getMasterPlate(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return SizedBox();
            return Wrap(
              children: snapshot.data!
                  .map((e) => FutureBuilder(
                      future: controller.getMasterPlateFile(e.file ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return SizedBox();
                        return GestureDetector(
                          onTap: () {
                            controller.saveIndex = -1;
                            controller.changgeRoot(snapshot.data!);
                            RemoveOverlayNotifier.instance
                                .emit(RemoveOverlayEvent(remove: true));
                          },
                          child: Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.text ?? "",
                                    style: appThemeData.textTheme.titleMedium),
                                sizeHeight10,
                                _dynamicWidget(context, snapshot.data),
                                _divider()
                              ],
                            ),
                          ),
                        );
                      }))
                  .toList(),
            );
          },
        ),
      );

  _saveWidget() => GetBuilder<HomeController>(
      id: controller.updateSaveWidget,
      builder: (c) {
        return SingleChildScrollView(
          child: FutureBuilder(
            future: controller.getSave(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return SizedBox();
              return Wrap(
                children: snapshot.data!
                    .map((e) => GestureDetector(
                          onTap: () {
                            controller.saveIndex =
                                snapshot.data?.indexOf(e) ?? -1;
                            controller.changgeRoot(jsonDecode(e.file ?? ""));
                            RemoveOverlayNotifier.instance
                                .emit(RemoveOverlayEvent(remove: true));
                          },
                          child: Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.text ?? "",
                                  style: appThemeData.textTheme.bodyText1,
                                ),
                                sizeHeight10,
                                _dynamicWidget(
                                    context, jsonDecode(e.file ?? "")),
                                _divider()
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        );
      });

  _leftWidget() => GetBuilder<HomeController>(
      id: controller.updateItemList,
      builder: (c) {
        return SizedBox(
          width: UniversalPlatform.isMacOS || kIsWeb ? 280 : 200,
          child: ListView.builder(
              itemCount: controller.showItemList?.length,
              itemBuilder: (context, index) {
                InputItem? item = controller.showItemList?[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        // Icon(
                        //   getIconData(item?.type ?? ""),
                        //   color: getRandColor(index),
                        //   size: 55,
                        // ),
                        item?.icon?.isEmpty ?? false
                            ? Image.asset(
                                Config.ASSETS_IMG + (item?.icon ?? ""),
                                width: 55,
                                height: 55,
                              )
                            : Container(),
                        sizeWidth10,
                        Text(item?.text ?? "",
                            style: appThemeData.textTheme.bodyText1!
                                .copyWith(fontSize: 18))
                      ],
                    ),
                    if (item != null && item.children != null) ...[
                      Column(
                        children: item.children!
                            .map((child) => Container(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        controller.addChildItem(child);
                                      },
                                      child: Row(
                                        children: [
                                          // Icon(
                                          //   getIconData(child.type ?? ""),
                                          //   color: Colors.grey,
                                          //   size: 30,
                                          // ),
                                          Image.asset(
                                            Config.ASSETS_IMG +
                                                (item?.icon ?? ""),
                                            width: 20,
                                            height: 20,
                                          ),
                                          sizeWidth10,
                                          Text(child.text ?? "",
                                              style: appThemeData
                                                  .textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.black87))
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    ]
                  ],
                );
              }),
        );
      });

  IconData getIconData(String type) {
    switch (type) {
      case "text":
        return Icons.text_fields;
      case "image":
        return Icons.image;
      case "title":
        return Icons.title;
      case "radio":
        return Icons.radio_button_on;
      case "input":
        return Icons.picture_in_picture;
      case "divider":
        return Icons.safety_divider;
      case "button":
        return Icons.smart_button;
    }
    return Icons.add;
  }

  Color getRandColor(int index) {
    List colors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.tealAccent,
      Colors.purple,
      Colors.cyanAccent,
      Colors.teal,
      Colors.deepOrange,
      Colors.lightBlueAccent,
      Colors.limeAccent,
      Colors.deepPurple,
      Colors.amberAccent,
      Colors.amber
    ];
    if (index >= colors.length) index = 0;

    // index = Random().nextInt(colors.length);
    return colors[index];
  }
}

Widget buildChinaText() => Container(
      height: 1,
      child: const Opacity(
        opacity: 0,
        child: Text(
          '中文',
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
