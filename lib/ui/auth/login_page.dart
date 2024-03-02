import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_app/controller/auth_controller/auth_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/theme/theme_helper.dart';
import 'package:wave_app/ui/auth/otp_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/custom_phone_number.dart';

import '../../main.dart';
import '../../model/customer_data.dart';

// ignore_for_file: must_be_immutable
class LoginOneScreen extends StatefulWidget {
  const LoginOneScreen({Key? key}) : super(key: key);

  @override
  State<LoginOneScreen> createState() => _LoginOneScreenState();
}

class _LoginOneScreenState extends State<LoginOneScreen> {
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('91');

  TextEditingController phoneNumberController = TextEditingController();

  String staticNumber = "9427337907";

  List<Worker>? workers;

  bool isChecked = false;
  late StreamSubscription connectivity;
  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );
    initWorkers();
  }

  @override
  void dispose() {
    connectivity.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CustomImageView(
                  imagePath: Assets.imagesFour,
                  alignment: Alignment.center,
                  height: 0.52.sh,
                  fit: BoxFit.fill,
                  width: 1.sw,
                ),
                /* Positioned(
                  bottom: 0.03.sh,
                  right: 0.01.sh,
                  child: CustomImageView(
                    imagePath: Assets.imagesLogo2,
                    scale: 13,
                  ),
                ),*/
              ],
            ),
            20.verticalSpace,
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ).r,
                child: Text(
                  "Enter Mobile Number",
                  style: CustomTextStyles.titleMediumGray700,
                ),
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15).r,
              child: CustomPhoneNumber(
                controller: phoneNumberController,
              ),
            ),
            20.verticalSpace,
            termsChecker(),
            25.verticalSpace,
            _buildLoginSignup(),
            15.verticalSpace,
            _buildWebUrl(context)
          ],
        ),
      ),
    );
  }

  Widget termsChecker() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 50).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 8).r,
            child: StatefulBuilder(
              builder: (context, setState) => GestureDetector(
                onTap: () {
                  isChecked = !isChecked;
                  setState(() {});
                },
                child: Icon(
                  size: 22,
                  isChecked
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_outlined,
                ),
              ),
            ),
          ),
          termsTextWidget()
        ],
      ),
    );
  }

  Widget termsTextWidget() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "By signing up I agree to the",
                style: theme.textTheme.titleMedium),
            const TextSpan(text: " "),
            TextSpan(text: "Terms of use", style: theme.textTheme.titleMedium),
            const TextSpan(text: " "),
            TextSpan(text: "and", style: theme.textTheme.titleMedium),
            const TextSpan(text: " "),
            TextSpan(
                text: "Privacy Policy.", style: theme.textTheme.titleMedium)
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginSignup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: AppButtonWidget(
        onTap: () {
          validate();
        },
        text: "Login / Signup",
      ),
    );
  }

  /// Section Widget
  Widget _buildWebUrl(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).r,
              child: Row(
                children: [
                  20.horizontalSpace,
                  CustomImageView(
                    imagePath: Assets.imagesGoogleIcon,
                    height: 45.h,
                    width: 45.w,
                    alignment: Alignment.center,
                  ),
                  40.horizontalSpace,
                  CustomImageView(
                    imagePath: Assets.imagesFbIcon,
                    height: 30.h,
                    width: 30.w,
                    alignment: Alignment.center,
                  ),
                  const Spacer(),
                  CustomImageView(
                    imagePath: Assets.imagesHelpdesk,
                    onTap: () {
                      _launchURL("https://www.wavetechservices.in");
                    },
                    height: 80.r,
                    width: 90.r,
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          GestureDetector(
            onTap: () {
              onTapTxtWeburl(context);
            },
            child: Text(
              "www.wavetechservices.in",
              style: CustomTextStyles.titleMediumGray700,
            ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  onTapTxtWeburl(BuildContext context) {
    _launchURL("https://www.wavetechservices.in/");
  }

  void validate() {
    if (!isChecked) {
      Flushbar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xffA41C8E),
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: const Text(
          "Please accept terms and privacy policy",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ).show(context);
      return;
    } else {
      if (phoneNumberController.text.isEmpty) {
        Flushbar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "Please enter phone number",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
        return;
      } else if (phoneNumberController.text.length < 10) {
        Flushbar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "Please enter valid phone number",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
        return;
      } else {
        checkConnectivity();
      }
    }
  }

  void initWorkers() {
    workers = [
      ever(
        authController.customerAuthResponseModel,
        (callback) {
          Get.back();
          Future.delayed(
            const Duration(seconds: 1),
            () => Get.to(
              OtpPage(
                customerAuthResponseModel: callback,
                mobileNumber: phoneNumberController.text,
              ),
            ),
          );
          if (callback.data?[0].customername != null) {
            customerDB?.put("isLogin", CustomerData(isLogin: true));
            for (int i = 0; i < callback.data!.length; i++) {
              print("location ${callback.data?[i].city}");
              locationDB?.put(
                "city",
                callback.data?[i].city,
              );
              nameDB?.put("customername", callback.data?[i].customername);
              nameDB?.put("mobile", callback.data?[i].mobile);
            }
          }
        },
      ),

      ///error worker
      ever(authController.errorMessage, (callback) {
        Flushbar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: Text(
            callback,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }),
    ];
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void checkConnectivity() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        authController.otpApi(phoneNumberController.text);
        if (authController.loading.isTrue) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const AlertDialog(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      } else {
        Flushbar(
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "No Active Internet Connection",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    });
    connectivity = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        debugPrint("This is called");
        authController.otpApi(phoneNumberController.text);
        if (authController.loading.isTrue) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const AlertDialog(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      }
      if (event == ConnectivityResult.none) {
        debugPrint("This called");
        Flushbar(
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "No Internet Connection",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    });
  }
}
