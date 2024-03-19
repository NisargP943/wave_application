import 'package:another_flushbar/flushbar.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/my_cart_model.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/model/response/all_consultants_response_model.dart';
import 'package:wave_app/model/response/amc_response_model.dart';
import 'package:wave_app/model/response/sub_category_response_model.dart';
import 'package:wave_app/model/service_details_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/theme/theme_helper.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

class ServiceDetailsPage extends StatefulWidget {
  ServiceDetailsPage(
      {super.key,
      this.categoryModel,
      this.consultant,
      this.subCategoryModel,
      this.fromSubCategory,
      this.fromSearchPage,
      this.amcModel});

  ServicesModel? categoryModel;
  ServiceModel? amcModel;
  Consultant? consultant;
  CategoryModel? subCategoryModel;
  final bool? fromSubCategory;
  final bool? fromSearchPage;

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  int? dateTimeIndex;
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var catController = Get.put(AllCatController());
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  ValueNotifier<String> descNotifier = ValueNotifier("No Description found");
  List<String> splitIssues = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    issuesList = [];
    selectedIssue = [];
    debugPrint(widget.categoryModel?.srate);
    Future.delayed(const Duration(seconds: 2), () => isLoading.value = false);
    dateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    timeController.text = timeController.text =
        DateFormat.jm().format(DateTime.now()).toLowerCase();
    if (widget.consultant != null) {
      catController.getAllConsultants();
    } else if (widget.amcModel != null) {
      catController.getAmcProducts();
    } else if (widget.subCategoryModel != null) {
      catController.searchService(widget.categoryModel?.catg ?? "Health Care");
    } else {
      catController.searchService(widget.categoryModel?.catg ?? "Health Care");
    }
    serviceBookingTime?.put(
        "serviceTime", "${dateController.text} and ${timeController.text}");
    setDescription();
    issuesSplit();
  }

  void issuesSplit() {
    if (widget.categoryModel != null) {
      splitIssues = widget.categoryModel?.mainissues
              ?.split(',')
              .map((service) => service.trim())
              .toList() ??
          [];
      for (var split in splitIssues) {
        issuesList.add(ServiceDetailsModel(split, false));
      }
    } else if (widget.amcModel != null) {
      splitIssues = widget.amcModel?.mainissues
              ?.split(',')
              .map((service) => service.trim())
              .toList() ??
          [];
      for (var split in splitIssues) {
        issuesList.add(ServiceDetailsModel(split, false));
      }
    } else {
      splitIssues = widget.consultant?.mainissues
              ?.split(',')
              .map((service) => service.trim())
              .toList() ??
          [];
      for (var split in splitIssues) {
        issuesList.add(ServiceDetailsModel(split, false));
      }
    }
  }

  @override
  void dispose() {
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageAppBar(),
      body: pageBodyWidget(),
    );
  }

  AppBar pageAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Image.asset(
          Assets.imagesBackIcon,
          scale: 1.8,
        ),
      ),
      title: Text(
        widget.fromSubCategory == true
            ? widget.subCategoryModel!.name!
            : widget.amcModel != null
                ? widget.amcModel?.catg ?? ""
                : widget.categoryModel?.catg ?? "${widget.consultant?.catg}",
        style: CustomTextStyles.titleMediumGray700,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
    );
  }

  Widget pageBodyWidget() {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, child) => value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : widget.categoryModel == null &&
                  widget.consultant == null &&
                  widget.amcModel == null &&
                  widget.subCategoryModel == null
              ? Center(
                  child: Text(
                    "No Data Found",
                    style: CustomTextStyles.bodyLargeBlack90018,
                  ),
                )
              : SingleChildScrollView(
                  child: servicesDetailsFromHomeWidget(),
                ),
    );
  }

  Widget servicesDetailsFromHomeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomImageView(
            imagePath: widget.amcModel != null
                ? widget.amcModel?.thumbnail
                : widget.categoryModel?.thumbnail ??
                    widget.consultant?.thumbnail,
            height: 0.4.sh,
            fit: BoxFit.fill,
          ),
        ),
        30.verticalSpace,
        serviceDetails(),
        3.verticalSpace,
        serviceLabel(),
        5.verticalSpace,
        ratingBarRow(4),
        30.verticalSpace,
        serviceDescription(),
        10.verticalSpace,
        labelWidgetOne("Issues"),
        10.verticalSpace,
        issuesListView(),
        10.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: AppButtonWidget(
            onTap: () {
              validate();
            },
            text: "Book Now",
          ),
        ),
        20.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: RichText(
            text: TextSpan(
              text: "Note : ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.spMin,
              ),
              children: [
                TextSpan(
                  text: "To schedule booking please select date and time",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.spMin,
                  ),
                ),
              ],
            ),
          ),
        ),
        15.verticalSpace,
        dateTimePicker(),
        15.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: AppButtonWidget(
            onTap: () {
              pageNotifier.value = 2;
              if (widget.categoryModel != null) {
                myCartList.add(widget.categoryModel!);
                catDB?.put("category", widget.categoryModel?.servicename);
              } else if (widget.consultant != null) {
                myConsultantModel.add(widget.consultant!);
                catDB?.put("category", widget.consultant?.servicename);
              } else if (widget.amcModel != null) {
                myAMCList.add(widget.amcModel!);
                catDB?.put("category", widget.amcModel?.servicename);
              }
              if (widget.fromSearchPage == true) {
                Get.back();
                Future.delayed(
                    const Duration(milliseconds: 100), () => Get.back());
              } else {
                Get.back();
              }
            },
            text: "Schedule Booking",
          ),
        ),
        20.verticalSpace,
        labelWidgetOne("You Can Also Select"),
        6.verticalSpace,
        widget.consultant != null
            ? consultantListView()
            : widget.amcModel != null
                ? amcListView()
                : newCategoryListView(),
        10.verticalSpace,
      ],
    );
  }

  Widget issuesListView() {
    return issuesList.isEmpty
        ? const Center(
            child: Text("No Issues Found"),
          )
        : StatefulBuilder(
            builder: (context, setState) => ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: issuesList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15).r,
                  child: GestureDetector(
                    onTap: () {
                      if (issuesList[index].isSelected == true) {
                        issuesList[index].isSelected = false;
                      } else {
                        issuesList[index].isSelected = true;
                      }
                      setState(() {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0).r,
                          child: Icon(
                            size: 22,
                            issuesList[index].isSelected == true
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_outlined,
                          ),
                        ),
                        termsTextWidget(index)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return 10.verticalSpace;
              },
            ),
          );
  }

  void validate() {
    if (dateController.text.isEmpty) {
      Flushbar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xffA41C8E),
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: const Text(
          "Please select booking date",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ).show(context);
      return;
    } else if (timeController.text.isEmpty) {
      Flushbar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xffA41C8E),
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: const Text(
          "Please select booking time",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ).show(context);
      return;
    } else {
      pageNotifier.value = 2;
      selectedIssue =
          issuesList.where((element) => element.isSelected == true).toList();
      if (widget.categoryModel != null) {
        myCartList.add(widget.categoryModel!);
        catDB?.put("category", widget.categoryModel?.servicename);
      } else if (widget.consultant != null) {
        myConsultantModel.add(widget.consultant!);
        catDB?.put("category", widget.consultant?.servicename);
      } else if (widget.amcModel != null) {
        myAMCList.add(widget.amcModel!);
        catDB?.put("category", widget.amcModel?.servicename);
      }
      if (widget.fromSearchPage == true) {
        Get.back();
        Future.delayed(const Duration(milliseconds: 100), () => Get.back());
      } else {
        Get.back();
      }
    }
  }

  Widget termsTextWidget(int index) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: issuesList[index].issue,
              style: theme.textTheme.titleSmall?.copyWith(fontSize: 15.spMin),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

/*
  Widget servicesDetailsFromSubCategoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomImageView(
            imagePath: widget.subCategoryModel!.thumbnail,
            height: 0.4.sh,
            fit: BoxFit.fill,
          ),
        ),
        30.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.subCategoryModel!.name!,
                  style: CustomTextStyles.displaySmallBlack900,
                ),
              ),
              Text(
                "₹ ${widget.subCategoryModel!.price}",
                style: CustomTextStyles.displaySmallBlack900,
              ),
            ],
          ),
        ),
        3.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: Text(
            widget.subCategoryModel!.subcatg!,
            style: CustomTextStyles.bodySmallff9b9b9b,
          ),
        ),
        5.verticalSpace,
        ratingBarRow(4),
        30.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: Text(
            widget.subCategoryModel!.name!,
            style: CustomTextStyles.titleMediumff407bff,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: AppButtonWidget(
            onTap: () {
              pageNotifier.value = 2;
              myCategory.add(widget.subCategoryModel!);
              catDB?.put("category", widget.subCategoryModel?.subcatg);

              Get.back();
            },
            text: "Book Now",
          ),
        ),
        10.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: RichText(
            text: TextSpan(
              text: "Note : ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.spMin,
              ),
              children: [
                TextSpan(
                  text: "To schedule booking please select date and time",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.spMin,
                  ),
                ),
              ],
            ),
          ),
        ),
        10.verticalSpace,
        dateTimePicker(),
        10.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: AppButtonWidget(
            onTap: () {
              pageNotifier.value = 3;
              myCategory.add(widget.subCategoryModel!);
              Get.back();
            },
            text: "Schedule Booking",
          ),
        ),
        20.verticalSpace,
        labelWidgetOne("You Can Also Select"),
        6.verticalSpace,
        categoryListView(),
        10.verticalSpace,
      ],
    );
  }
*/

  Widget newCategoryListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 205.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: controller.allServicesResponse.value?.data?.length ?? 0,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList =
                controller.allServicesResponse.value?.data?[index];
            return GestureDetector(
              onTap: () {
                widget.categoryModel = secondList;
                setState(() {});
              },
              child: Column(
                children: [
                  5.verticalSpace,
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ).r,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 30,
                    ).r,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    child: CustomImageView(
                      height: 60.r,
                      imagePath: secondList?.thumbnail,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          secondList?.servicename ?? "",
                          style: CustomTextStyles.bodySmallErrorContainer,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar(
                            initialRating: 5,
                            allowHalfRating: true,
                            itemCount: 5,
                            glowColor: Colors.orangeAccent,
                            itemSize: 16,
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
                      ),
                      10.verticalSpace,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "",
                              style: CustomTextStyles.bodySmallRed700,
                            ),
                          ],
                          text: "₹${secondList?.price}",
                          style: CustomTextStyles.bodyMediumGrey13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 20.horizontalSpace;
          },
        ),
      ),
    );
  }

  Widget categoryListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 205.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount:
              controller.subCategoryResponseModel.value?.data?.length ?? 0,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList =
                controller.subCategoryResponseModel.value?.data?[index];
            return GestureDetector(
              onTap: () {
                widget.subCategoryModel = secondList;
                setState(() {});
              },
              child: Column(
                children: [
                  5.verticalSpace,
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ).r,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 30,
                    ).r,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    child: CustomImageView(
                      height: 60.r,
                      imagePath: secondList?.thumbnail,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          secondList?.name ?? "",
                          style: CustomTextStyles.bodySmallErrorContainer,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar(
                            initialRating:
                                widget.categoryModel!.rating!.toDouble(),
                            allowHalfRating: true,
                            itemCount: 5,
                            glowColor: Colors.orangeAccent,
                            itemSize: 16,
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
                      ),
                      10.verticalSpace,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "",
                              style: CustomTextStyles.bodySmallRed700,
                            ),
                          ],
                          text: "₹${secondList?.price}",
                          style: CustomTextStyles.bodyMediumGrey13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 20.horizontalSpace;
          },
        ),
      ),
    );
  }

  Widget consultantListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 205.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: controller.allConsultantResponse.value?.data.length ?? 0,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList =
                controller.allConsultantResponse.value?.data[index];
            return GestureDetector(
              onTap: () {
                widget.consultant = secondList;
                setState(() {});
              },
              child: Column(
                children: [
                  5.verticalSpace,
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ).r,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 30,
                    ).r,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    child: CustomImageView(
                      height: 60.r,
                      imagePath: secondList?.thumbnail,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          secondList?.servicename ?? "",
                          style: CustomTextStyles.bodySmallErrorContainer,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar(
                            initialRating: widget.consultant!.rating.toDouble(),
                            allowHalfRating: true,
                            itemCount: 5,
                            glowColor: Colors.orangeAccent,
                            itemSize: 16,
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
                      ),
                      10.verticalSpace,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "",
                              style: CustomTextStyles.bodySmallRed700,
                            ),
                          ],
                          text: "₹${secondList?.price}",
                          style: CustomTextStyles.bodyMediumGrey13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 20.horizontalSpace;
          },
        ),
      ),
    );
  }

  Widget amcListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 205.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: controller.allAmcProducts.value?.data?.length ?? 0,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList = controller.allAmcProducts.value?.data?[index];
            return GestureDetector(
              onTap: () {
                widget.amcModel = secondList;
                setState(() {});
              },
              child: Column(
                children: [
                  5.verticalSpace,
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ).r,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 30,
                    ).r,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    child: CustomImageView(
                      height: 60.r,
                      imagePath: secondList?.thumbnail ?? "",
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          secondList?.servicename ?? "",
                          style: CustomTextStyles.bodySmallErrorContainer,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar(
                            initialRating: widget.amcModel!.rating!.toDouble(),
                            allowHalfRating: true,
                            itemCount: 5,
                            glowColor: Colors.orangeAccent,
                            itemSize: 16,
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
                      ),
                      10.verticalSpace,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "",
                              style: CustomTextStyles.bodySmallRed700,
                            ),
                          ],
                          text: "₹${secondList?.price}",
                          style: CustomTextStyles.bodyMediumGrey13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 20.horizontalSpace;
          },
        ),
      ),
    );
  }

  Widget serviceDescription() {
    return ValueListenableBuilder(
      valueListenable: descNotifier,
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: Text(
          value,
          style: CustomTextStyles.titleMediumff407bff,
        ),
      ),
    );
  }

  Widget serviceLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Text(
        widget.categoryModel?.catg ??
            widget.consultant?.catg ??
            widget.amcModel?.catg ??
            "",
        style: CustomTextStyles.bodySmallff9b9b9b,
      ),
    );
  }

  Widget serviceDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.categoryModel?.servicename.toString() ??
                  widget.consultant?.servicename ??
                  widget.amcModel?.servicename ??
                  "",
              style: CustomTextStyles.displaySmallBlack900,
            ),
          ),
          Text(
            /* widget.categoryModel?.price == null ||
                    widget.consultant?.price == null ||
                    widget.amcModel?.price.toString() == null
                ? "Rs 0"
                :*/
            "Rs ${widget.categoryModel?.price ?? widget.consultant?.price ?? widget.amcModel?.price}",
            style: CustomTextStyles.displaySmallBlack900,
          ),
        ],
      ),
    );
  }

  Widget dateTimePicker() {
    return StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).r,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  dateTimeIndex = 0;
                  setState(() {});
                  buildCalenderDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8).r,
                    border: Border.all(
                      color: dateTimeIndex == 0
                          ? Colors.orangeAccent
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateController.text.isEmpty
                            ? "Date"
                            : dateController.text,
                        style: CustomTextStyles.bodyLargeBlack900,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Image.asset(
                          Assets.imagesBackIcon,
                          scale: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            15.horizontalSpace,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  dateTimeIndex = 1;
                  timeSheet();
                  setState(() {});
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14)
                          .r,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: dateTimeIndex == 1
                          ? Colors.orangeAccent
                          : Colors.grey.withOpacity(0.5),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8).r,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeController.text.isEmpty
                            ? "Time"
                            : timeController.text,
                        style: CustomTextStyles.bodyLargeBlack900,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Image.asset(
                          Assets.imagesBackIcon,
                          scale: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Padding(
              padding: const EdgeInsets.only(top: 5).r,
              child: Image.asset(
                Assets.imagesFavIcon,
                scale: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ratingBarRow(int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBar(
            initialRating: 5,
            allowHalfRating: true,
            itemCount: 5,
            glowColor: Colors.orangeAccent,
            itemSize: 16,
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
      ),
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      firstDate: DateTime.now(),
      weekdayLabels: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
      /* weekdayLabelTextStyle: textStyle.copyWith(
        fontSize: 13.spMin,
        color: const Color.fromRGBO(60, 60, 67, 0.80),
        fontWeight: FontWeight.w500,
      ),*/

      firstDayOfWeek: 0,
      controlsHeight: 50,
      selectedDayHighlightColor: const Color(0xffA41C8E),
      /* customModePickerIcon: Image.asset(
        Assets.images.viewAllArrow.path,
        height: 18.r,
        width: 18.r,
        color: AppColor.teal,
      ),*/
      /*  controlsTextStyle: .copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 17.sp,
      ),
      dayTextStyle: textStyle.copyWith(
        color: AppColor.black,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
      selectedDayTextStyle: textStyle.copyWith(
        color: AppColor.white,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
      disabledDayTextStyle: textStyle.copyWith(
        color: AppColor.grey,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),*/
      selectableDayPredicate: (day) => !day
          .difference(
            DateTime.now().subtract(
              const Duration(days: 3),
            ),
          )
          .isNegative,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: config,
          value: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (dates) {
            dateController.text =
                DateFormat("dd-MM-yyyy").format(dates.last ?? DateTime.now());
            setState(() => _singleDatePickerValueWithDefaultValue = dates);
          },
        ),
        SizedBox(
          width: 100.w,
          child: AppButtonWidget(
            text: "Ok",
            onTap: () {
              Get.back();
            },
          ),
        ),
        10.verticalSpace,
      ],
    );
  }

  buildCalenderDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(24).r,
          topLeft: const Radius.circular(24).r,
        ),
      ),
      context: context,
      builder: (context) {
        return _buildDefaultSingleDatePickerWithValue();
      },
    );
  }

  void timeSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(24).r,
          topLeft: const Radius.circular(24).r,
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              34.verticalSpace,
              SizedBox(
                height: 0.25.sh,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    primaryColor: Colors.black,
                    applyThemeToAll: true,
                    brightness: Brightness.dark,
                    primaryContrastingColor: Colors.purple,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 18.spMin,
                        color: Colors.black,
                      ),
                      primaryColor: Colors.black,
                    ),
                  ),
                  child: CupertinoDatePicker(
                    showDayOfWeek: true,
                    onDateTimeChanged: (val) {
                      timeController.text =
                          DateFormat.jm().format(val).toLowerCase();
                      setState(() {});
                    },
                    mode: CupertinoDatePickerMode.time,
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                child: AppButtonWidget(
                  text: "Ok",
                  onTap: () {
                    serviceBookingTime?.put("serviceTime",
                        "${dateController.text} and ${timeController.text}");
                    Get.back();
                  },
                ),
              ),
              10.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget labelWidgetOne(String? labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ).r,
      child: Text(
        labelText ?? "Talk to our Experts",
        style: CustomTextStyles.bodyMediumBlack900,
      ),
    );
  }

  void setDescription() {
    if (widget.amcModel?.maindesc != "") {
      descNotifier.value = widget.amcModel?.maindesc ?? "No Description found";
    } else if (widget.consultant?.maindesc != "") {
      descNotifier.value =
          widget.consultant?.maindesc ?? "No Description found";
    } else if (widget.categoryModel?.maindesc != "") {
      descNotifier.value =
          widget.categoryModel?.maindesc ?? "No Description found";
    } else {
      descNotifier.value = "No Description found";
    }
  }
}
