import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  ValueNotifier<bool> widgetNotifier = ValueNotifier(false);

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
        body: GetBuilder<AllCatController>(
          builder: (controller) => categoryController.loading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: widgetNotifier,
                    builder: (context, value, child) =>
                        value ? mainWidgetTwo() : mainWidgetOne(),
                  ),
                ),
        ),
        bottomNavigationBar: bottomNavigationBar(),
        floatingActionButton: GestureDetector(
          onTap: () {},
          child: const CircleAvatar(
            backgroundImage: AssetImage(
              Assets.imagesChatbot,
            ),
            radius: 30,
          ),
        ),
      ),
    );
  }

  Widget mainWidgetTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: "https://wavetechservices.in/images/web/decor2.jpeg",
          height: 0.35.sh,
          width: 1.sw,
          fit: BoxFit.fill,
          placeHolder: "Please wait",
        ),
        15.verticalSpace,
        labelWidgetTwo("Home Services"),
        5.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: Text(
            "click and book",
            style: CustomTextStyles.bodyMediumGrey13,
          ),
        ),
        20.verticalSpace,
        homeServicesListView(),
        labelWidgetTwo("Talk to Our Experts"),
        3.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: Text(
            "You've never seen it before!",
            style: CustomTextStyles.bodyMediumGrey13,
          ),
        ),
        10.verticalSpace,
        newCategoryListView(),
      ],
    );
  }

  Widget homeServicesListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 240.h,
        child: ListView.separated(
          itemCount:
              controller.allCategoryResponseModel.value?.data.length ?? 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20).r,
                    color: Colors.red,
                  ),
                  child: Text(
                    "-20%",
                    style: CustomTextStyles.bodySmallOnPrimary,
                  ),
                ),
                5.verticalSpace,
                CustomImageView(
                  height: 80.h,
                  imagePath: controller
                      .allCategoryResponseModel.value?.data[index].thumbnail,
                ),
                5.verticalSpace,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryController.allCategoryResponseModel.value
                              ?.data[index].isFavourite !=
                          categoryController.allCategoryResponseModel.value
                              ?.data[index].isFavourite;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60, top: 10).r,
                    child: Icon(
                      color: controller.allCategoryResponseModel.value
                                  ?.data[index].isFavourite ==
                              true
                          ? Colors.red
                          : null,
                      controller.allCategoryResponseModel.value?.data[index]
                                  .isFavourite ==
                              true
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    ),
                  ),
                ),
                3.verticalSpace,
                ratingBarRow(),
                3.verticalSpace,
                Text(
                  "Dorothy Perkins",
                  style: CustomTextStyles.bodySmallff9b9b9b,
                ),
                3.verticalSpace,
                Text(
                  "${controller.allCategoryResponseModel.value?.data[index].catg}" ??
                      "",
                  style: CustomTextStyles.bodyLargeBlack900_1,
                ),
                3.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "   19\$",
                        style: CustomTextStyles.bodySmallRed700,
                      ),
                    ],
                    text: "15\$",
                    style: CustomTextStyles.bodyMediumGrey13LineThrough,
                  ),
                )
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

  Row ratingBarRow() {
    return Row(
      children: [
        RatingBar(
          initialRating: 5,
          allowHalfRating: true,
          itemCount: 5,
          glowColor: Colors.orangeAccent,
          itemSize: 12,
          ratingWidget: RatingWidget(
            full: const Icon(
              Icons.star_sharp,
              color: Colors.orangeAccent,
            ),
            half: const Icon(
              Icons.star_half_sharp,
              color: Colors.yellow,
            ),
            empty: const Icon(
              Icons.star_border_sharp,
            ),
          ),
          onRatingUpdate: (double value) {},
        ),
        3.horizontalSpace,
        Text(
          "(10)",
          style: CustomTextStyles.bodySmallGrey11,
        )
      ],
    );
  }

  Widget newCategoryListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 240.h,
        child: ListView.separated(
          itemCount:
              controller.allCategoryResponseModel.value?.data.length ?? 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20).r,
                    color: Colors.black,
                  ),
                  child: Text(
                    "New",
                    style: CustomTextStyles.bodySmallOnPrimary,
                  ),
                ),
                5.verticalSpace,
                CustomImageView(
                  height: 80.h,
                  imagePath: controller
                      .allCategoryResponseModel.value?.data[index].thumbnail,
                ),
                5.verticalSpace,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryController.allCategoryResponseModel.value
                              ?.data[index].isFavourite !=
                          categoryController.allCategoryResponseModel.value
                              ?.data[index].isFavourite;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                      top: 10,
                    ).r,
                    child: Icon(
                      color: controller.allCategoryResponseModel.value
                                  ?.data[index].isFavourite ==
                              true
                          ? Colors.red
                          : null,
                      controller.allCategoryResponseModel.value?.data[index]
                                  .isFavourite ==
                              true
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    ),
                  ),
                ),
                3.verticalSpace,
                ratingBarRow(),
                3.verticalSpace,
                Text(
                  "Dorothy Perkins",
                  style: CustomTextStyles.bodySmallff9b9b9b,
                ),
                3.verticalSpace,
                Text(
                  "${controller.allCategoryResponseModel.value?.data[index].catg}" ??
                      "",
                  style: CustomTextStyles.bodyLargeBlack900_1,
                ),
                3.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "   19\$",
                        style: CustomTextStyles.bodySmallRed700,
                      ),
                    ],
                    text: "15\$",
                    style: CustomTextStyles.bodyMediumGrey13LineThrough,
                  ),
                )
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
          if (widgetNotifier.value == true) {
            widgetNotifier.value = false;
          }
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

  Widget labelWidgetTwo(String? labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText ?? "Home Services",
            style: CustomTextStyles.bodyLargeBlack90018,
          ),
          Text(
            "View All",
            style: CustomTextStyles.bodySmallff9b9b9b11,
          ),
        ],
      ),
    );
  }

  Widget chatBotButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            widgetNotifier.value = !widgetNotifier.value;
          },
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
