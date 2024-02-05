import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/theme/custom_text_style.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({super.key, this.text, this.onTap});

  final String? text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ).r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffA41C8E),
          borderRadius: BorderRadius.circular(30).r,
        ),
        child: Text(
          text ?? "",
          style: CustomTextStyles.bodyLarge18,
        ),
      ),
    );
  }
}
