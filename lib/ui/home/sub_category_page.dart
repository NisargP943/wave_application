import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/controller/internet_controller/internet_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/custom_text_field.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> showSearchBar = ValueNotifier(false);
  List<String> category = [
    "Astrologers",
    "Caterers",
    "CAR Service",
    "Bike Service",
    "Consultants - Advisory Service",
    "Contractors",
    "Electrical Service",
    "Electronics Service",
    "Event Organizer",
    "GYM - FITNESS",
    "Freelancer",
    "Homes Needs",
    "Jewellery Showrooms",
    "NGO - Old Age Homes - Care Centers",
    "Pest Control Services",
    "Part Time Job - Wave",
    "Pet Shops",
    "Real Estate Agents",
    "Rent - Hire",
    "Spa - Saloon",
    "TRAINING AND CERTIFICATION",
    "Transports Service",
    "Travel and Tourism",
    "Wedding Planners",
    "YOGA - MEDITATION"
  ];
  var internetController = Get.put(InternetController());
  var categoryController = Get.put(AllCatController());

  @override
  void initState() {
    super.initState();
    if (internetController.message.value == "Internet Connection Gained") {
      categoryController.getSubCategory("Astrologers");
    } else {
      Flushbar(
        backgroundColor: const Color(0xffA41C8E),
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: Text(
          internetController.message.value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Wave Tech Services",
          style: TextStyle(
            fontSize: 18.spMin,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Acme",
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showSearchBar.value = !showSearchBar.value;
            },
            child: Image.asset(
              Assets.imagesSearch,
              scale: 1.3,
            ),
          ),
        ],
      ),
      body: GetBuilder<AllCatController>(
        builder: (controller) => controller.loading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : pageBodyWidget(),
      ),
    );
  }

  Column pageBodyWidget() {
    return Column(
      children: [
        10.verticalSpace,
        ValueListenableBuilder(
          valueListenable: showSearchBar,
          builder: (context, value, child) => value
              ? TextFieldDesignPage(
                  onChanged: (val) {
                    categoryController.getSubCategory(val);
                  },
                  edgeInsets: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ).r,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  controller: searchController,
                  labelText: "Search Category",
                  prefixWidget: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        15.verticalSpace,
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10).r,
            shrinkWrap: true,
            itemCount: category.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (internetController.message.value ==
                      "Internet Connection Gained") {
                    categoryController.getSubCategory(category[index]);
                  } else {
                    Flushbar(
                      backgroundColor: const Color(0xffA41C8E),
                      flushbarPosition: FlushbarPosition.BOTTOM,
                      messageText: Text(
                        internetController.message.value,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ).show(context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20).r,
                    color: const Color(0xffA41C8E),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5).r,
                  child: Text(
                    category[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.spMin,
                      fontFamily: "Arial",
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8).r,
          padding: const EdgeInsets.symmetric(vertical: 15).r,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.40),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              10.horizontalSpace,
              Image.asset(
                Assets.imagesFilter,
                height: 24.r,
                width: 24.r,
              ),
              5.horizontalSpace,
              Text(
                "Filter",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.spMin,
                  fontFamily: "Arial",
                ),
              ),
              const Spacer(),
              Image.asset(
                Assets.imagesPriceFilter,
                height: 24.r,
                width: 24.r,
              ),
              5.horizontalSpace,
              Text(
                "Price:lowest to high",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.spMin,
                  fontFamily: "Arial",
                ),
              ),
              const Spacer(),
              Image.asset(
                Assets.imagesMoreVert,
                height: 24.r,
                width: 24.r,
              ),
              10.horizontalSpace,
            ],
          ),
        ),
        GetBuilder<AllCatController>(
          builder: (controller) =>
              controller.subCategoryResponseModel.value?.data != null
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: AlignedGridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ).r,
                          itemCount: controller.subCategoryResponseModel.value
                                  ?.data?.length ??
                              0,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            final subCategory = controller
                                .subCategoryResponseModel.value?.data?[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 3,
                              ).r,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  5.verticalSpace,
                                  Center(
                                    child: CustomImageView(
                                      height: 80.h,
                                      imagePath: subCategory?.thumbnail,
                                    ),
                                  ),
                                  15.verticalSpace,
                                  ratingBarRow(),
                                  5.verticalSpace,
                                  Text(
                                    subCategory?.name ?? "",
                                    style: CustomTextStyles.bodyMediumGrey13,
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    "Rs ${subCategory?.price}" ?? "",
                                    style: CustomTextStyles.bodySmallff222222,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No Data Found",
                      ),
                    ),
        )
      ],
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
          style: CustomTextStyles.bodyMediumGrey13,
        )
      ],
    );
  }
}
