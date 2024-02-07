import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/theme/app_decoration.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/theme/theme_helper.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/custom_phone_number.dart';

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

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageView(
                  imagePath: Assets.imagesLoginBg, alignment: Alignment.center),
              40.verticalSpace,
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ).r,
                  child: Text(
                    "Enter Mobile Number",
                    style: CustomTextStyles.titleLargeBlack900,
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
              19.verticalSpace,
              _buildLoginSignup(),
              18.verticalSpace,
              _buildWebUrl(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget termsChecker() {
    return Padding(
      padding: const EdgeInsets.only(left: 38, right: 70).r,
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
          text: TextSpan(children: [
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
          ]),
          textAlign: TextAlign.left),
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
        text: "Login/Signup",
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
              padding: const EdgeInsets.only(left: 15).r,
              child: Row(
                children: [
                  Container(
                    height: 64,
                    width: 92,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 34, vertical: 20),
                    decoration: AppDecoration.outlineBlack9004.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder24),
                    child: CustomImageView(
                      imagePath: Assets.imagesGoogle,
                      height: 24,
                      width: 23,
                      alignment: Alignment.center,
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 92,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 34, vertical: 20),
                    decoration: AppDecoration.outlineBlack9004.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder24),
                    child: CustomImageView(
                      imagePath: Assets.imagesFacebook,
                      height: 24,
                      width: 24,
                      alignment: Alignment.center,
                    ),
                  ),
                  const Spacer(),
                  CustomImageView(
                    imagePath: Assets.imagesLogo,
                    height: 110.r,
                    width: 130.r,
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
    // TODO: implement Actions
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
      } else {}
    }
  }
}
