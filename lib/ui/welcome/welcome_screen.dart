import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/ui/auth/login_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController imageController = PageController();
  ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pageBodyWidget(),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (context, value, child) =>
              value == 6 ? buildLastScreen() : Container(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget pageBodyWidget() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      builder: (BuildContext context, int value, Widget? child) {
        return PageView.builder(
          onPageChanged: (value) {
            pageIndex.value = value;
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
  Assets.imagesBannerOne,
  Assets.imagesBannerTwo,
  Assets.imagesBannerThree,
  Assets.imagesBannerFour,
  Assets.imagesBannerFive,
  Assets.imagesBannerSix,
  Assets.imagesBannerSeven,
];
