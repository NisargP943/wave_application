import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/ui/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.off(
          const WelcomeScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Image(
              height: ScreenUtil().setHeight(180),
              width: ScreenUtil().setWidth(210),
              fit: BoxFit.fill,
              image: const AssetImage(Assets.imagesLogo),
            ),
            SizedBox(height: 35.h),
            Image(
              height: ScreenUtil().setHeight(162),
              width: ScreenUtil().setWidth(300),
              fit: BoxFit.fill,
              image: const AssetImage(Assets.imagesBanner),
            ),
            SizedBox(height: 25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Services Faster Than\nYour Next Coffee Break",
                  style: TextStyle(
                      color: const Color(0xff636363), fontSize: 23.spMin),
                ),
                SizedBox(height: 40.h),
                Image(
                  height: ScreenUtil().setHeight(54),
                  width: ScreenUtil().setWidth(66),
                  fit: BoxFit.fill,
                  image: const AssetImage(Assets.imagesTitleLogo),
                ),
              ],
            ),
            SizedBox(height: 75.h),
            Text(
              "www.wavetechservices.in",
              style:
                  TextStyle(color: const Color(0xff636363), fontSize: 19.spMin),
            ),
            SizedBox(height: 0.10.sh),
            Image(
              height: ScreenUtil().setHeight(126),
              width: double.infinity,
              fit: BoxFit.fitWidth,
              image: const AssetImage(Assets.imagesBottomImg),
            ),
          ],
        ),
      ),
    );
  }
}
