import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/ui/auth/sign_up_page.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

import '../../generated/assets.dart';
import '../../theme/custom_text_style.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.customerAuthResponseModel, this.mobileNumber});

  final CustomerAuthResponseModel? customerAuthResponseModel;
  final String? mobileNumber;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  int _secondsRemaining = 60;
  late Timer _timer;
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(
          () {
            if (_secondsRemaining > 0) {
              _secondsRemaining--;
            } else {
              _timer.cancel();
              // Timer completed, do something here
            }
          },
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (widget.customerAuthResponseModel?.otp != null) {
        Flushbar(
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: Text(
            "Your OTP is ${widget.customerAuthResponseModel?.otp}\nPlease do not share to anyone",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 8),
            content: Text(
                "Your OTP is ${widget.customerAuthResponseModel?.otp}\nPlease do not share to anyone"),
          ),
        );*/
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.06.sh,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomImageView(
                    imagePath: Assets.imagesBackIcon,
                    onTap: () {
                      Get.back();
                    },
                    width: 24.r,
                    height: 24.r,
                  ),
                  CustomImageView(
                    imagePath: Assets.imagesLogo,
                    scale: 11,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  Text(
                    "Please Enter OTP",
                    style: CustomTextStyles.bodyMediumBlack900,
                  ),
                  10.verticalSpace,
                  Text(
                    "We have send the verification \ncode to your mobile number",
                    style: CustomTextStyles.bodyMediumGrey13,
                  ),
                  40.verticalSpace,
                  Pinput(
                    controller: otpController,
                    defaultPinTheme: PinTheme(
                      margin: const EdgeInsets.only(
                        right: 25,
                      ).r,
                      height: 50.r,
                      width: 55.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12).r,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      margin: const EdgeInsets.only(
                        right: 25,
                      ).r,
                      height: 50.r,
                      width: 55.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12,
                        ).r,
                        border: Border.all(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  AppButtonWidget(
                    onTap: () {
                      if (otpController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter OTP"),
                          ),
                        );
                        return;
                      } else if (otpController.text.length < 4 ||
                          double.tryParse(otpController.text) !=
                              widget.customerAuthResponseModel?.otp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter valid OTP"),
                          ),
                        );
                        return;
                      } else {
                        for (int i = 0;
                            i < widget.customerAuthResponseModel!.data!.length;
                            i++) {
                          if (widget.customerAuthResponseModel?.data?[i]
                                  .customername ==
                              null) {
                            Get.to(
                              transition: Transition.fadeIn,
                              duration: const Duration(seconds: 2),
                              SignUpPageScreen(
                                mobileNumber: widget.mobileNumber,
                              ),
                            );
                          } else {
                            Get.offAll(
                                transition: Transition.fadeIn,
                                duration: const Duration(seconds: 2),
                                MainPage(
                                  customerAuthResponseModel:
                                      widget.customerAuthResponseModel,
                                ));
                          }
                        }
                      }
                    },
                    text: "Confirm",
                  ),
                  30.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          _secondsRemaining = 60;
                          _timer.cancel();
                          _timer = Timer.periodic(
                            const Duration(seconds: 1),
                            (Timer timer) {
                              setState(
                                () {
                                  if (_secondsRemaining > 0) {
                                    _secondsRemaining--;
                                  } else {
                                    _timer.cancel();
                                    // Timer completed, do something here
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _secondsRemaining > 0
                            ? "Resend in $_secondsRemaining seconds"
                            : "Resend OTP",
                        style: CustomTextStyles.bodyMediumRed700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomImageView(
        imagePath: Assets.imagesHelpdesk,
        onTap: () {
          _launchURL("https://www.wavetechservices.in");
        },
        height: 100.r,
        width: 130.r,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
