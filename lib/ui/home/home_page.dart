import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

ValueNotifier<bool> widgetNotifier = ValueNotifier(false);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var categoryController = Get.put(AllCatController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        body: GetBuilder<AllCatController>(
          builder: (controller) => categoryController.loading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: widgetNotifier,
                    builder: (context, value, child) => mainWidgetTwo(),
                  ),
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
          imagePath: Assets.imagesOne,
          height: 0.25.sh,
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
        ///   Top Service List
        height: 210.h,

        child: ListView.separated(
          itemCount: controller.allCategoryByTypesResponseModel.value?.data.length ?? 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final firstList =
                controller.allCategoryByTypesResponseModel.value?.data[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
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
                  margin: const EdgeInsets.only(left: 10),
                  height: 70.h,
                  imagePath: firstList?.thumbnail,
                ),
                0.verticalSpace,
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60, top: 0).r,
                    child: Icon(
                      size: 25.r,
                      color: firstList?.isFavourite == true ? Colors.red : null,
                      firstList?.isFavourite == true
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    ),
                  ),
                ),
                3.verticalSpace,
                ratingBarRow(firstList, index),
                3.verticalSpace,
                SizedBox(
                  width: 110.w,
                  child: Text(
                    firstList?.servicename ?? "",
                    style: CustomTextStyles.bodyLargeBlack900_1,
                  ),
                ),
                3.verticalSpace,
                /* SizedBox(
                  width: 110.w,
                  child: Text(
                    firstList?.stype ?? "",
                    style: CustomTextStyles.bodyLargeBlack900_1,
                  ),
                ),
                3.verticalSpace,*/
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "",
                        style: CustomTextStyles.bodySmallRed700,
                      ),
                    ],
                    text: "Rs ${firstList?.price}",
                    style: CustomTextStyles.bodyMediumGrey13,
                  ),
                )
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 15.horizontalSpace;
          },
        ),
      ),
    );
  }

  Row ratingBarRow(Datum? data, int index) {
    return Row(
      children: [
        RatingBar(
          initialRating: double.tryParse(data!.rating.toString()) ?? 1.0,
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
        ///   Bottom Service List
        height: 230.h,

        child: ListView.separated(
          itemCount: controller.secondPriorityList?.length ?? 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList = controller.secondPriorityList?[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
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
                  height: 70.h,
                  imagePath: secondList?.thumbnail,
                ),
                5.verticalSpace,
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                      top: 0,
                    ).r,
                    child: Icon(
                      size: 25.r,
                      color: secondList?.isFavourite == true ? Colors.red : null,
                      secondList?.isFavourite == true
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    ),
                  ),
                ),
                3.verticalSpace,
                ratingBarRow(secondList, index),
                3.verticalSpace,
                /*Text(
                  secondList?.servicename ?? "",
                  style: CustomTextStyles.bodySmallff9b9b9b,
                ),
                3.verticalSpace,*/
                SizedBox(
                  width: 110.w,
                  child: Text(
                    secondList?.catg ?? "",
                    style: CustomTextStyles.bodyLargeBlack900_1,
                  ),
                ),
                3.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "",
                        style: CustomTextStyles.bodySmallRed700,
                      ),
                    ],
                    text: "Rs ${secondList?.price}",
                    style: CustomTextStyles.bodyMediumGrey13,
                  ),
                )
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 15.horizontalSpace;
          },
        ),
      ),
    );
  }

  /*Widget mainWidgetOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: Assets.imagesOne,
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
  }*/

  /*Widget categoryListviewWidget() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 110.h,
        child: controller.loading.isTrue
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: controller.mainCatFirstPriority?.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 5).r,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final mainFirst = controller.mainCatFirstPriority?[index];
                  return Column(
                    children: [
                      CustomImageView(
                        height: 80.h,
                        imagePath: mainFirst?.thumbnail,
                      ),
                      5.verticalSpace,
                      Text(mainFirst?.catg ?? "",
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
  }*/

/*
  Widget labelWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 5).r,
      child: Text(
        "Home Services",
        style: CustomTextStyles.bodyLargeBlack90018,
      ),
    );
  }
*/

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
            style: CustomTextStyles.bodyMedium_1,
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
            margin: const EdgeInsets.only(left: 15).r,
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
