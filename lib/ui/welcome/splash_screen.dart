import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/customer_data.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/ui/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/images/wave_video.MP4");
    _controller.initialize();
    _controller.play();
    _controller.addListener(() {
      if (_controller.value.hasError) {
        print(_controller.value.errorDescription);
      }
    });

    CustomerData temp = customerDB?.get("isLogin");
    Future.delayed(
      const Duration(seconds: 2),
      () {
        /// checking condition if the user is already logged in than redirect to home page
        if (temp.isLogin == true) {
          Get.off(
              transition: Transition.fadeIn,
              duration: const Duration(seconds: 1),
              const MainPage());
        } else {
          Get.off(
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1),
            const WelcomeScreen(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        fit: BoxFit.fill,
        Assets.imagesWaveSpalsh,
        width: 1.sw,
        height: 1.sh,
      ),
    );
  }
}
