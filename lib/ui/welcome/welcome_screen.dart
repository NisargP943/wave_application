import 'dart:async';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/transformer/transformers.dart';
import 'package:wave_app/ui/auth/login_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  IndexController imageController = IndexController();
  TransformerPageController pageController = TransformerPageController();
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
        Get.off(
          const LoginOneScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 2),
        );
        end = true;
      } else if (pageIndex.value == 0) {
        end = false;
      }

      if (end == false) {
        pageIndex.value++;
      }
    });
  }

  @override
  void dispose() {
    imageController.dispose();
    pageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (context, value, child) => ImageFade(
            // whenever the image changes, it will be loaded, and then faded in:
            image: AssetImage(walkthroughList[value]),
            height: 1.sh,

            // slow fade for newly loaded images:
            duration: const Duration(seconds: 1),

            // if the image is loaded synchronously (ex. from memory), fade in faster:
            syncDuration: const Duration(seconds: 5),

            // supports most properties of Image:
            alignment: Alignment.center,
            fit: BoxFit.fill,

            // shown behind everything:
            placeholder: Container(
              color: const Color(0xFFCFCDCA),
              alignment: Alignment.center,
              child:
                  const Icon(Icons.photo, color: Colors.white30, size: 128.0),
            ),

            // shows progress while loading an image:
            loadingBuilder: (context, progress, chunkEvent) =>
                Center(child: CircularProgressIndicator(value: progress)),

            // displayed when an error occurs:
            errorBuilder: (context, error) => Container(
              color: const Color(0xFF6F6D6A),
              alignment: Alignment.center,
              child:
                  const Icon(Icons.warning, color: Colors.black26, size: 128.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget pageBodyWidget() {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      builder: (BuildContext context, int val, Widget? child) {
        return TransformerPageView(
          pageController: pageController,
          onPageChanged: (value) {
            pageIndex.value = value!;
            /*if (val == 1) {
              Future.delayed(
                const Duration(seconds: 1),
                () => Get.off(
                  transition: Transition.fadeIn,
                  const LoginOneScreen(),
                ),
              );
            }*/
          },
          itemBuilder: (context, index) {
            return ImageFade(
              // whenever the image changes, it will be loaded, and then faded in:
              image: AssetImage(walkthroughList[index]),
              height: 1.sh,

              // slow fade for newly loaded images:
              duration: const Duration(milliseconds: 900),

              // if the image is loaded synchronously (ex. from memory), fade in faster:
              syncDuration: const Duration(milliseconds: 150),

              // supports most properties of Image:
              alignment: Alignment.center,
              fit: BoxFit.cover,

              // shown behind everything:
              placeholder: Container(
                color: const Color(0xFFCFCDCA),
                alignment: Alignment.center,
                child:
                    const Icon(Icons.photo, color: Colors.white30, size: 128.0),
              ),

              // shows progress while loading an image:
              loadingBuilder: (context, progress, chunkEvent) =>
                  Center(child: CircularProgressIndicator(value: progress)),

              // displayed when an error occurs:
              errorBuilder: (context, error) => Container(
                color: const Color(0xFF6F6D6A),
                alignment: Alignment.center,
                child: const Icon(Icons.warning,
                    color: Colors.black26, size: 128.0),
              ),
            );
          },
          itemCount: walkthroughList.length,
          transformer: FadeInTransformer(),
          physics: const BouncingScrollPhysics(),
        );
      },
    );
  }
}

List walkthroughList = [
  Assets.imagesBannerThree,
  Assets.imagesBannerFour,
];
