import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _controller = VideoPlayerController.asset(Assets.imagesWaveVideo);
    _controller.initialize();
    _controller.play();

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
      body: _controller.value.isInitialized
          ? SizedBox(
              width: 1.sw,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
