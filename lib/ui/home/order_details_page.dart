import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/my_cart_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/search_textfield_widget.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  ValueNotifier<bool> showSearchBar = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: 18.spMin,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Arial",
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
      body: SingleChildScrollView(
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
                    "OrderNo:1234567",
                    style: CustomTextStyles.bodyLargeBlack900,
                  ),
                  Text(
                    "5-02-2024",
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
                          text: "IW3475453455",
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
                "3 items",
                style: TextStyle(
                  fontSize: 13.spMin,
                  fontFamily: "Arial",
                  fontWeight: FontWeight.w500,
                ),
              ),
              25.verticalSpace,
              bookingServiceList(),
              35.verticalSpace,
              Text(
                "Order Tracking Information",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Arial",
                  fontSize: 15.spMin,
                ),
              ),
              30.verticalSpace,
              RichText(
                text: TextSpan(
                  text: "Service Engineer:    ",
                  style: CustomTextStyles.bodySmallff9b9b9b,
                  children: [
                    TextSpan(
                      text: "Vikas",
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
                      text: locationDB?.get("city").toString(),
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
                  text: "Service method:    ",
                  style: CustomTextStyles.bodySmallff9b9b9b,
                  children: [
                    TextSpan(
                      text: "Home Services",
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
              RichText(
                text: TextSpan(
                  text: "Total Amount:    ",
                  style: CustomTextStyles.bodySmallff9b9b9b,
                  children: [
                    TextSpan(
                      text: "Rs 363/-",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.spMin,
                          fontFamily: "Arial"),
                    ),
                  ],
                ),
              ),
              40.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12).r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50).r,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: const Text("Reorder"),
                    ),
                  ),
                  25.horizontalSpace,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bookingServiceList() {
    if (myCartList.isEmpty) {
      return const Center(
        child: Text("No Services Selected"),
      );
    } else {
      return StatefulBuilder(
        builder: (context, setState) => ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: myCartList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = myCartList[index];
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
                    imagePath: item.thumbnail ?? "",
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.catg ?? "",
                          style: CustomTextStyles.bodyMediumBlack900,
                        ),
                        3.verticalSpace,
                        Text(
                          item.servicename ?? "",
                          style: CustomTextStyles.bodySmallff222222,
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
                                    text: "1",
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
                                      text: "1",
                                      style:
                                          CustomTextStyles.bodyMediumGray50013,
                                    ),
                                  ],
                                ),
                              ),
                              Text("₹${item.price}")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
