import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/theme/app_decoration.dart';
import 'package:wave_app/theme/theme_helper.dart';
import 'package:wave_app/ui/auth/forgot_password_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/custom_text_field.dart';

// ignore_for_file: must_be_immutable
class LoginPageScreen extends StatelessWidget {
  LoginPageScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> emailAccepted = ValueNotifier(false);

  ValueNotifier<bool> passwordAccepted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20).r,
          child: Row(
            children: [
              CustomImageView(
                imagePath: Assets.imagesBackIcon,
                onTap: () {
                  onTapImgArrowLeft(context);
                },
                width: 24.r,
                height: 24.r,
              ),
              const Spacer(),
              CustomImageView(
                imagePath: Assets.imagesLogo,
                height: 70.h,
                width: 80.w,
              ),
              30.horizontalSpace,
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                80.verticalSpace,
                _buildNavigationBarBig(context),
                80.verticalSpace,
                TextFieldDesignPage(
                  accepted: emailAccepted,
                  controller: emailController,
                  labelText: "Email",
                  onChanged: (p0) {
                    if (!p0.contains("@") || !p0.contains(".")) {
                      emailAccepted.value = false;
                    } else {
                      emailAccepted.value = true;
                    }
                  },
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                ),
                10.verticalSpace,
                TextFieldDesignPage(
                  accepted: passwordAccepted,
                  controller: passwordController,
                  labelText: "Password",
                  onChanged: (p0) {
                    if (p0.length < 6) {
                      passwordAccepted.value = false;
                    } else {
                      passwordAccepted.value = true;
                    }
                  },
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                ),
                14.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Get.to(ForgotPasswordPage());
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 1),
                            child: Text("Forgot your password?",
                                style: theme.textTheme.bodyMedium),
                          ),
                          CustomImageView(
                            imagePath: Assets.imagesArrow,
                            height: 24.r,
                            width: 24.r,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.27.sh,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15).r,
                  child: AppButtonWidget(
                    text: "LOGIN",
                    onTap: () {},
                  ),
                ),
                14.verticalSpace,
                Text("Or login with social account",
                    style: theme.textTheme.bodyMedium),
                14.verticalSpace,
                _buildSeventySeven(context),
                30.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNavigationBarBig(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: Text("Login", style: theme.textTheme.displaySmall),
      ),
    );
  }

  /// Section Widget
  Widget _buildSeventySeven(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 64.h,
          width: 92.w,
          decoration: AppDecoration.outlineBlack9004
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
          child: CustomImageView(
            imagePath: Assets.imagesGoogle,
            height: 24.r,
            width: 24.r,
            alignment: Alignment.center,
          ),
        ),
        10.horizontalSpace,
        Container(
          height: 64.h,
          width: 92.w,
          decoration: AppDecoration.outlineBlack9004
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
          child: CustomImageView(
            imagePath: Assets.imagesFacebook,
            height: 24.r,
            width: 24.r,
            alignment: Alignment.center,
          ),
        )
      ],
    );
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
