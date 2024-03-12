import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/response/booked_service_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/search_textfield_widget.dart';

import '../../widgets/custom_elevated_button.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage(
      {super.key, this.bookedServiceModel, this.fromHomePage});

  final BookedServiceModel? bookedServiceModel;
  final bool? fromHomePage;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  ValueNotifier<bool> showSearchBar = ValueNotifier(false);
  ValueNotifier<bool> dataLoaded = ValueNotifier(false);
  ValueNotifier<String> priceNotifier = ValueNotifier("");
  ValueNotifier<String> ratingNotifier = ValueNotifier("");
  ValueNotifier<String> feedbackNotifier = ValueNotifier("");
  ValueNotifier<bool> showAmountField = ValueNotifier(false);
  late TextEditingController reviewController, priceController;
  var categoryController = Get.put(AllCatController());

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
    priceController = TextEditingController();
    Future.delayed(const Duration(seconds: 1), () => dataLoaded.value = true);
    ever(categoryController.isBookingCompleted, (callback) {
      if (callback == "Done") {
        showDialog(
          builder: (context) => AlertDialog(
            title: const Text("Service Completed"),
            actions: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (widget.fromHomePage == true) {
                      Get.offAll(
                        const MainPage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(seconds: 1),
                      );
                    } else {
                      Get.offAll(
                        const MainPage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(seconds: 1),
                      );
                      pageNotifier.value = 0;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(40).r,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ).r,
                    child: Text(
                      "Ok / Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 14.spMin),
                    ),
                  ),
                ),
              ),
            ],
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(Assets.imagesSuccess),
                ),
                5.verticalSpace,
                Text(
                    "Your Booking is Completed with Booking ID : ${widget.bookedServiceModel?.id.toString()}"),
              ],
            ),
          ),
          context: context,
          barrierDismissible: false,
        );
      }
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            Assets.imagesBackIcon,
            scale: 1.5,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        title: Text(
          "Service Order Details",
          style: TextStyle(
            fontSize: 18.spMin,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Arial",
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: dataLoaded,
        builder: (context, value, child) => value
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      ValueListenableBuilder(
                        valueListenable: showSearchBar,
                        builder: (context, value, child) => value
                            ? TextFieldSearchPage(
                                padding: 0,
                                onChanged: (val) {},
                                edgeInsets: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 0,
                                ).r,
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.text,
                                readOnly: true,
                                labelText: "Search order details",
                                prefixWidget: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      15.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "OrderNo:${widget.bookedServiceModel?.id}",
                            style: CustomTextStyles.bodyLargeBlack900,
                          ),
                          Text(
                            "${widget.bookedServiceModel?.bookdate}",
                            style: CustomTextStyles.bodyMediumGrey13,
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Tracking number: ",
                              style: CustomTextStyles.bodySmallff9b9b9b,
                              children: [
                                TextSpan(
                                  text: widget.bookedServiceModel?.id,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.spMin,
                                      fontFamily: "Arial"),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "In Progress",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15.spMin,
                              fontFamily: "Arial",
                            ),
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      Text(
                        "${widget.bookedServiceModel?.quantity} item",
                        style: TextStyle(
                          fontSize: 13.spMin,
                          fontFamily: "Arial",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      25.verticalSpace,
                      orderDetailsItem(),
                      35.verticalSpace,
                      Text(
                        "Service Order Tracking Information",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Arial",
                          fontSize: 15.spMin,
                        ),
                      ),
                      30.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: "Service ID:    ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: "${widget.bookedServiceModel?.id}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: "Service Engineer:    ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text:
                                  "${widget.bookedServiceModel?.vendordetails}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.spMin,
                                  fontFamily: "Arial"),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: "Shipping Address:    ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: widget.bookedServiceModel?.location,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: "Service Requested:    ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: widget.bookedServiceModel?.servicename,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.spMin,
                                  fontFamily: "Arial"),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      ValueListenableBuilder(
                        valueListenable: feedbackNotifier,
                        builder: (context, value, child) => RichText(
                          text: TextSpan(
                            text: "Feedback:    ",
                            style: CustomTextStyles.bodySmallff9b9b9b,
                            children: [
                              TextSpan(
                                text:
                                    "${value.isEmpty ? widget.bookedServiceModel?.feedback : value}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.spMin,
                                    fontFamily: "Arial"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      30.verticalSpace,
                      ValueListenableBuilder(
                        valueListenable: ratingNotifier,
                        builder: (context, value, child) => RichText(
                          text: TextSpan(
                            text: "Rating:    ",
                            style: CustomTextStyles.bodySmallff9b9b9b,
                            children: [
                              TextSpan(
                                text: value.isEmpty
                                    ? widget.bookedServiceModel?.rating
                                    : value,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.spMin,
                                    fontFamily: "Arial"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      30.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: "Amc Needed:    ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: "${widget.bookedServiceModel?.amcneeded}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.spMin,
                                  fontFamily: "Arial"),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      RichText(
                        text: TextSpan(
                          text: "Discount:    ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: "10% Personal promo code",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: priceNotifier,
                            builder: (context, value, child) => RichText(
                              text: TextSpan(
                                text: "Total Amount:    ",
                                style: CustomTextStyles.bodySmallff9b9b9b,
                                children: [
                                  TextSpan(
                                    text:
                                        "Rs ${value.isEmpty ? widget.bookedServiceModel?.price : value}/-",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.spMin,
                                      fontFamily: "Arial",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimateIcon(
                            height: 22.r,
                            onTap: () {
                              showAmountField.value = !showAmountField.value;
                            },
                            iconType: IconType.animatedOnTap,
                            animateIcon: AnimateIcons.edit,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      ValueListenableBuilder(
                        valueListenable: showAmountField,
                        builder: (context, value, child) => value
                            ? TextFieldSearchPage(
                                onSubmitted: (val) {
                                  showAmountField.value = false;
                                  priceNotifier.value = val;
                                },
                                padding: 0,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                hintText: "Enter Amount Paid",
                                controller: priceController,
                              )
                            : const SizedBox.shrink(),
                      ),
                      40.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                callCompleteBookingApi();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12).r,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50).r,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Text("Complete"),
                              ),
                            ),
                          ),
                          25.horizontalSpace,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                reviewSheet();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ).r,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50).r,
                                  color: Colors.purple,
                                ),
                                child: const Text(
                                  "Leave Feedback",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Arial",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void callCompleteBookingApi() {
    categoryController.getCompleteBookedServiceApi(
        "Completed",
        widget.bookedServiceModel?.id ?? "",
        widget.bookedServiceModel?.id ?? "",
        ratingNotifier.value.isEmpty
            ? widget.bookedServiceModel?.rating ?? ''
            : ratingNotifier.value,
        nameDB?.get("mobile"),
        widget.bookedServiceModel?.comments ?? "No Comments",
        feedbackNotifier.value.isEmpty
            ? widget.bookedServiceModel?.feedback ?? ""
            : feedbackNotifier.value,
        "Yes",
        priceNotifier.value.isEmpty
            ? widget.bookedServiceModel?.price ?? ""
            : priceNotifier.value);
  }

  Widget orderDetailsItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15).r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8).r,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 5,
          )
        ],
      ),
      padding: const EdgeInsets.only(left: 15, top: 3, bottom: 3).r,
      child: Row(
        children: [
          CustomImageView(
            height: 100.h,
            imagePath: widget.bookedServiceModel?.thumbnail ?? "",
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bookedServiceModel?.servicename ?? "",
                  style: CustomTextStyles.bodyMediumBlack900,
                ),
                10.verticalSpace,
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "No: ",
                        style: CustomTextStyles.bodySmallff9b9b9b,
                        children: [
                          TextSpan(
                            text: widget.bookedServiceModel?.id,
                            style: CustomTextStyles.bodyMediumGray50013,
                          ),
                        ],
                      ),
                    ),
                    50.horizontalSpace,
                    Text(
                      "Male",
                      style: CustomTextStyles.bodySmallff9b9b9b,
                    )
                  ],
                ),
                10.verticalSpace,
                Padding(
                  padding: const EdgeInsets.only(right: 10).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Units: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: widget.bookedServiceModel?.quantity,
                              style: CustomTextStyles.bodyMediumGray50013,
                            ),
                          ],
                        ),
                      ),
                      Text("₹${widget.bookedServiceModel?.price}")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void reviewSheet() {
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
          margin:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          height: 0.5.sh,
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).r,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                15.verticalSpace,
                Text(
                  "What is your rating ?",
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyLargeBlack900_1,
                ),
                20.verticalSpace,
                RatingBar(
                  itemPadding: const EdgeInsets.symmetric(horizontal: 5).r,
                  initialRating: 0,
                  allowHalfRating: true,
                  itemCount: 5,
                  glowColor: Colors.orangeAccent,
                  ratingWidget: RatingWidget(
                    full: const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.yellow,
                    ),
                    half: const Icon(
                      Icons.star_half_rounded,
                      color: Colors.yellow,
                    ),
                    empty: const Icon(
                      Icons.star_border_rounded,
                    ),
                  ),
                  onRatingUpdate: (double value) {
                    ratingNotifier.value = value.toString();
                  },
                ),
                10.verticalSpace,
                Text(
                  "Please share your opinion about the service",
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyLargeBlack900_1,
                ),
                10.verticalSpace,
                TextFieldSearchPage(
                  padding: 0,
                  maxLines: 4,
                  controller: reviewController,
                  hintText: 'Your review',
                ),
                34.verticalSpace,
                AppButtonWidget(
                  text: "Send Review",
                  onTap: () {
                    feedbackNotifier.value = reviewController.text;
                    Get.back();
                  },
                ),
                10.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
