import 'package:fb_message_card_editor/app/modules/home/views/home_view.dart';
import 'package:fb_message_card_editor/app/modules/login/LandscapeLoginWrap.dart';
import 'package:fb_message_card_editor/theme/app_theme.dart';
import 'package:fb_message_card_editor/theme/const.dart';
import 'package:fb_message_card_editor/theme/default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'login_logic.dart';

class LoginPage  extends GetView<LoginLogic>{
  @override
  Widget build(BuildContext context) {

    return LandscapeLoginWrap(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          sizeHeight46,
          Text(
            '手机号码登录'.tr,
            style: appThemeData.textTheme.bodyText1?.copyWith(
                fontSize: 24, height: 1.16, fontWeight: FontWeight.w600),
          ),
          buildChinaText(),
          sizeHeight12,
          Text('%s的手机号验证后自动登录'.trArgs(['未注册'.tr]),
              style: appThemeData.textTheme.caption?.copyWith(
                fontSize: 12,
                height: 1.21,
              )),
          const SizedBox(
            height: 32,
          ),
          Column(
            children: [
              Builder(
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    // color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: appThemeData.dividerColor),
                  ),
                  height: 48,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {},
                        child: SizedBox(
                            width: 66,
                            child: Center(
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '+86',
                                        style: appThemeData.textTheme.bodyText1
                                            ?.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ]))),
                      ),
                      SizedBox(
                        height: 20,
                        child: VerticalDivider(
                            color: appThemeData.dividerColor),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (text) {},
                          keyboardType: TextInputType.phone,
                          controller: controller.mobileController,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(11), //限制长度
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: appThemeData.textTheme.bodyText1
                              ?.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            border: InputBorder.none,
                            hintText: '请输入手机号'.tr,
                            hintStyle:
                            appThemeData.textTheme.caption?.copyWith(
                              color: appThemeData.disabledColor
                                  .withOpacity(0.4),
                            ),
                            suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFaaaaaa),
                                  size: 20,
                                ),
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) =>
                                      controller.mobileController?.clear());
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizeHeight16,
              SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: (_loading) ? null : toCaptcha,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: _loading
                        ? DefaultTheme.defaultLoadingIndicator(
                        color: Colors.white)
                        : Text(
                      '获取验证码'.tr,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: (_loading)
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white),
                    ),
                  )),
              sizeHeight16,
            ],
          ),
        ],
      ),
    );
  }

  bool _loading = false;

  Future toCaptcha() async {
    FocusScope.of(Get.context!).unfocus();
    _loading = true;
    controller.update();
    controller.getCode();
  }
}
