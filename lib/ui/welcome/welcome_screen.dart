import 'package:flutter/material.dart';
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
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pageBodyWidget(),
    );
  }

  Widget pageBodyWidget() {
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, Widget? child) {
          return Column(
            children: [
              SizedBox(
                height: 0.7.sh,
                child: PageView.builder(
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
                ),
              ),
              50.verticalSpace,
              value == 2 ? buildLastScreen() : const SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }

  Widget buildLastScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: AppButtonWidget(
        text: "Get Started",
        onTap: () {
          Get.off(LoginOneScreen());
        },
      ),
    );
  }
}

List walkthroughList = [
  Assets.imagesWelcome1,
  Assets.imagesWelcome2,
  Assets.imagesWelcome3,
];
