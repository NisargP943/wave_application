import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var categoryController = Get.put(AllCatController());
  ValueNotifier<int> pageNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: mainWidgetOne(),
        ),
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  Widget mainWidgetOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: "https://wavetechservices.in/images/web/decor2.jpeg",
          height: 0.52.sh,
          fit: BoxFit.fill,
          placeHolder: "Please wait",
        ),
        chatBotButtonRow(),
        labelWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5).r,
          child: Text(
            "You've never seen it before!",
            style: CustomTextStyles.bodyMediumGrey13,
          ),
        ),
        20.verticalSpace,
        categoryListviewWidget()
      ],
    );
  }

  Widget bottomNavigationBar() {
    return ValueListenableBuilder(
      valueListenable: pageNotifier,
      builder: (context, value, child) => BottomNavigationBar(
        selectedItemColor: const Color(0xffDB3022),
        onTap: (val) {
          pageNotifier.value = val;
        },
        currentIndex: value,
        selectedLabelStyle: CustomTextStyles.bodySmall11,
        unselectedLabelStyle: CustomTextStyles.bodySmall11_1,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              color: value == 0 ? const Color(0xffDB3022) : null,
              height: 45.h,
              width: 30.w,
              Assets.imagesHome,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              color: value == 1 ? const Color(0xffDB3022) : null,
              height: 45.h,
              width: 30.w,
              Assets.imagesShoppingCart,
            ),
            label: "Book",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              color: value == 2 ? const Color(0xffDB3022) : null,
              height: 45.h,
              width: 30.w,
              Assets.imagesShopping,
            ),
            label: "My Orders",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              color: value == 3 ? const Color(0xffDB3022) : null,
              height: 45.h,
              width: 30.w,
              Assets.imagesHeart,
            ),
            label: "Favourites",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              color: value == 4 ? const Color(0xffDB3022) : null,
              height: 45.h,
              width: 30.w,
              Assets.imagesProfile,
            ),
            label: "Helpdesk",
          ),
        ],
      ),
    );
  }

  Widget categoryListviewWidget() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 110.h,
        child: controller.loading.isTrue
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount:
                    controller.allCategoryResponseModel.value?.data.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 5).r,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CustomImageView(
                        height: 80.h,
                        imagePath: controller.allCategoryResponseModel.value
                            ?.data[index].thumbnail,
                      ),
                      5.verticalSpace,
                      Text(
                          controller.allCategoryResponseModel.value?.data[index]
                                  .catg ??
                              "",
                          style: CustomTextStyles.bodyLargeBlack900_1),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return 20.horizontalSpace;
                },
              ),
      ),
    );
  }

  Widget labelWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 5).r,
      child: Text(
        "Home Services",
        style: CustomTextStyles.bodyLargeBlack90018,
      ),
    );
  }

  Widget chatBotButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(left: 5).r,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 30,
            ).r,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
              color: const Color(0xffA41C8E),
              borderRadius: BorderRadius.circular(20).r,
            ),
            child: Text(
              "Select Service",
              style: CustomTextStyles.bodySmall11,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10).r,
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              backgroundImage: AssetImage(Assets.imagesChatbot),
              radius: 38,
            ),
          ),
        ),
      ],
    );
  }
}
