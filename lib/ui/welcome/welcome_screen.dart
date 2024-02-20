import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/ui/auth/login_page.dart';
import 'package:wave_app/ui/auth/login_with_email_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController imageController = PageController();
  ValueNotifier<int> pageIndex = ValueNotifier(0);
  late Timer timer;
  bool end = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (pageIndex.value == 1) {
        end = true;
      } else if (pageIndex.value == 0) {
        end = false;
      }

      if (end == false) {
        pageIndex.value++;
      }

      imageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    imageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pageBodyWidget(),
      ),
    );
  }

  Widget pageBodyWidget() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      builder: (BuildContext context, int val, Widget? child) {
        return PageView.builder(
          onPageChanged: (value) {
            pageIndex.value = value;
            if (val == 1) {
              Future.delayed(
                const Duration(seconds: 2),
                () => Get.off(
                  curve: Curves.easeIn,
                  const LoginOneScreen(),
                ),
              );
            }
          },
          itemBuilder: (context, index) {
            return Image.asset(
              walkthroughList[index],
              fit: BoxFit.fill,
            );
          },
          itemCount: walkthroughList.length,
          controller: imageController,
          physics: const BouncingScrollPhysics(),
        );
      },
    );
  }

  Widget buildLastScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).r,
      child: SizedBox(
        height: 50.h,
        child: AppButtonWidget(
          text: "Get Started",
          onTap: () {
            Get.off(const LoginOneScreen());
          },
        ),
      ),
    );
  }
}

List walkthroughList = [
  Assets.imagesBannerThree,
  Assets.imagesBannerFour,
];
