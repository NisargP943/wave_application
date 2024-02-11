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

  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
    initWorkers();
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
                  imagePath: Assets.imagesLoginbg,
                  alignment: Alignment.center,
                  height: 0.5.sh,
                  width: 1.sw,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  bottom: 0.02.sh,
                  right: 0.01.sh,
                  child: CustomImageView(
                    imagePath: Assets.imagesLogo2,
                    scale: 13,
                  ),
                ),
                Positioned(
                  right: 0.16.sh,
                  bottom: 0.05.sh,
                  child: CustomImageView(
                    height: 60.h,
                    imagePath: Assets.imagesLoginText,
                  ),
                ),
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
                    height: 45,
                    width: 45,
                    alignment: Alignment.center,
                  ),
                  40.horizontalSpace,
                  CustomImageView(
                    imagePath: Assets.imagesFbIcon,
                    height: 30,
                    width: 30,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept terms and privacy policy"),
        ),
      );
      return;
    } else {
      if (phoneNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter phone number"),
          ),
        );
        return;
      } else if (phoneNumberController.text.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter valid phone number"),
          ),
        );
      } else {
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
    }
  }

  void initWorkers() {
    workers = [
      ever(authController.customerAuthResponseModel, (callback) {
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
        customerDB?.put("isLogin", CustomerData(isLogin: true));
      })
    ];
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
