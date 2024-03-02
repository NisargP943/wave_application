import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/my_cart_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/search_textfield_widget.dart';
import 'package:wave_app/widgets/thin_textfield.dart';

class WaveCartPage extends StatefulWidget {
  const WaveCartPage({super.key});

  @override
  State<WaveCartPage> createState() => _WaveCartPageState();
}

class _WaveCartPageState extends State<WaveCartPage> {
  ValueNotifier<bool> showSearchBar = ValueNotifier(false);
  ValueNotifier<bool> dummyCouponCode = ValueNotifier(false);
  ValueNotifier<double> totalPrice = ValueNotifier(0);
  TextEditingController searchController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  var categoryController = Get.put(AllCatController());
  List<Worker> workers = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    calculateTotalPrice();
    initWorkers();
  }

  @override
  void dispose() {
    searchController.dispose();
    releaseWorker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageBodyWidget(),
    );
  }

  Widget pageBodyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          40.verticalSpace,
          searchIcon(),
          10.verticalSpace,
          searchTextField(),
          10.verticalSpace,
          myCartTextRow(),
          myCartList.isNotEmpty
              ? bookingServiceList()
              : myConsultantModel.isNotEmpty
                  ? bookingConsultantList()
                  : myCategory.isNotEmpty
                      ? bookingCategoryList()
                      : bookingAMCList(),
          promoCodeList(),
          const ThinTextField(labelText: "Express Service"),
          10.verticalSpace,
          ThinTextField(
            labelText: serviceBookingTime?.get("serviceTime") != null
                ? serviceBookingTime!.get("serviceTime").toString()
                : "Select Date and Time",
          ),
          10.verticalSpace,
          ThinTextField(
              labelText:
                  locationDB?.get("city").toString() ?? "Select Location",
              onTap: () {
                pageNotifier.value = 0;
              }),
          10.verticalSpace,
          ValueListenableBuilder(
              valueListenable: dummyCouponCode,
              builder: (context, value, child) {
                return ThinTextField(
                  labelText: value ? "1234" : "Enter your promo code",
                  onTap: () {
                    showPromoCodeBottomSheet();
                  },
                );
              }),
          30.verticalSpace,
          totalPriceRow(),
          30.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).r,
            child: AppButtonWidget(
              onTap: () {
                if (myCartList.isEmpty &&
                    myConsultantModel.isEmpty &&
                    myAMCList.isEmpty &&
                    myCategory.isEmpty) {
                  Flushbar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: const Color(0xffA41C8E),
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    messageText: const Text(
                      "Nothing added in the cart",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ).show(context);
                  return;
                } else {
                  callBookServiceApi();
                }
              },
              text: "Book Service",
            ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  void callBookServiceApi() {
    print(nameDB!.get("mobile").toString());
    categoryController.bookService(
      name: nameDB!.get("customername").toString(),
      number: nameDB!.get("mobile").toString(),
      cityLat: "23.0039",
      cityLong: "72.5461",
      address: locationDB?.get("city").toString() ?? "",
      bookingDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      bookingTime: DateFormat.jm().format(DateTime.now()).toLowerCase(),
      landmark: "Indian oil petrol pump",
      sdetails: myCartList.isNotEmpty
          ? "${myCartList.first.id}-${myCartList.first.servicename}-${myCartList.first.count}-${myCartList.first.srate}"
          : myAMCList.isNotEmpty
              ? "${myAMCList.first.id}-${myAMCList.first.servicename}-${myAMCList.first.count}-${myAMCList.first.srate}"
              : myCategory.isNotEmpty
                  ? "${myCategory.first.id}-${myCategory.first.subcatg}-${myCategory.first.count}-${myCategory.first.price}"
                  : "${myConsultantModel.first.id}-${myConsultantModel.first.servicename}-${myConsultantModel.first.count}-${myConsultantModel.first.price}",
      amcDetails: myAMCList.isNotEmpty
          ? "${myAMCList.first.id}-${myAMCList.first.servicename}-${myAMCList.first.count}-${myAMCList.first.srate}"
          : "4023-AMC-1-1499",
      couponCode: "123",
    );
  }

  Future<dynamic> showPromoCodeBottomSheet() {
    return showModalBottomSheet(
      shape: OutlineInputBorder(
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(10),
          left: Radius.circular(10),
        ).r,
      ),
      isDismissible: false,
      context: context,
      builder: (context) {
        return Column(
          children: [
            20.verticalSpace,
            const ThinTextField(labelText: "Enter your promo code"),
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Promo codes",
                    style: CustomTextStyles.displaySmallBlack900,
                  ),
                  CustomImageView(
                    imagePath: Assets.imagesLogo2,
                    height: 50.r,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: promoCodeList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Align searchIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20).r,
        child: GestureDetector(
          onTap: () {
            showSearchBar.value = !showSearchBar.value;
          },
          child: Image.asset(
            Assets.imagesSearch,
            scale: 1.3,
          ),
        ),
      ),
    );
  }

  Widget totalPriceRow() {
    return ValueListenableBuilder(
      valueListenable: totalPrice,
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Amount:"),
            Text(
              "₹ ${totalServiceCostDB?.get("cost")}",
              style: CustomTextStyles.bodyMediumGray50013,
            )
          ],
        ),
      ),
    );
  }

  Widget promoCodeList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 15).r,
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
          child: Row(
            children: [
              Container(
                height: 80.r,
                width: 80.r,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    scale: 2,
                    image: AssetImage(Assets.imagesDiscount),
                  ),
                  color: Colors.purple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ).r,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(right: 15).r,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Wave Amc offer",
                            style: CustomTextStyles.bodyMediumBlack900,
                          ),
                          Text(
                            "6 days remaining",
                            style: CustomTextStyles.bodyMediumGray50013,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "mypromocode2020",
                          style: CustomTextStyles.bodyMediumGray50013,
                        ),
                        GestureDetector(
                          onTap: () {
                            dummyCouponCode.value = true;
                            Get.back();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              right: 15,
                            ).r,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ).r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50).r,
                              color: Colors.purple,
                            ),
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Arial",
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
            ],
          ),
        );
      },
    );
  }

  Widget bookingServiceList() {
    return myCartList.isEmpty
        ? const Center(
            child: Text("No Services in cart"),
          )
        : StatefulBuilder(
            builder: (context, setState) => ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myCartList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = myCartList[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 15)
                          .r,
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
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.catg ?? "",
                                      style:
                                          CustomTextStyles.bodyMediumBlack900,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            3.verticalSpace,
                            Text(
                              item.servicename ?? "",
                              style: CustomTextStyles.bodyMediumGray50013,
                            ),
                            10.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImageView(
                                        onTap: () {
                                          if (item.count! > 1) {
                                            /* item.count = item.count! - 1;
                                            totalPrice.value =
                                                item.price! * item.count!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);*/
                                          } else {
                                            myCartList.removeAt(index);
                                            totalPrice.value =
                                                totalPrice.value - item.price!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);
                                          }
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesMinus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        item.count.toString(),
                                        style: CustomTextStyles
                                            .bodyMediumGray50013,
                                      ),
                                      10.horizontalSpace,
                                      CustomImageView(
                                        onTap: () {
                                          /*  item.count = item.count! + 1;
                                          totalPrice.value =
                                              item.price! * item.count!;
                                          totalServiceCostDB?.put(
                                              "cost", totalPrice.value);*/
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesPlus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                    ],
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

  Widget bookingConsultantList() {
    return myConsultantModel.isEmpty
        ? const Center(
            child: Text("Nothing to show in cart"),
          )
        : StatefulBuilder(
            builder: (context, setState) => ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myConsultantModel.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = myConsultantModel[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 15)
                          .r,
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
                        imagePath: item.thumbnail,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.catg,
                                      style:
                                          CustomTextStyles.bodyMediumBlack900,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            3.verticalSpace,
                            Text(
                              item.servicename,
                              style: CustomTextStyles.bodyMediumGray50013,
                            ),
                            10.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImageView(
                                        onTap: () {
                                          if (item.count! > 1) {
                                            /* item.count = item.count! - 1;
                                            totalPrice.value =
                                                item.price! * item.count!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);*/
                                          } else {
                                            myConsultantModel.removeAt(index);
                                            totalPrice.value =
                                                totalPrice.value - item.price;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);
                                          }
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesMinus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        item.count.toString(),
                                        style: CustomTextStyles
                                            .bodyMediumGray50013,
                                      ),
                                      10.horizontalSpace,
                                      CustomImageView(
                                        onTap: () {
                                          /*  item.count = item.count! + 1;
                                          totalPrice.value =
                                              item.price! * item.count!;
                                          totalServiceCostDB?.put(
                                              "cost", totalPrice.value);*/
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesPlus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                    ],
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

  Widget bookingAMCList() {
    return myAMCList.isEmpty
        ? const Center(
            child: Text("Nothing to show in cart"),
          )
        : StatefulBuilder(
            builder: (context, setState) => ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myAMCList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = myAMCList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 15,
                  ).r,
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
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.catg ?? "",
                                      style:
                                          CustomTextStyles.bodyMediumBlack900,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            3.verticalSpace,
                            Text(
                              item.servicename ?? "",
                              style: CustomTextStyles.bodyMediumGray50013,
                            ),
                            10.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImageView(
                                        onTap: () {
                                          if (item.count! > 1) {
                                            /* item.count = item.count! - 1;
                                            totalPrice.value =
                                                item.price! * item.count!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);*/
                                          } else {
                                            myAMCList.removeAt(index);
                                            totalPrice.value =
                                                totalPrice.value - item.price!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);
                                          }
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesMinus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        item.count.toString(),
                                        style: CustomTextStyles
                                            .bodyMediumGray50013,
                                      ),
                                      10.horizontalSpace,
                                      CustomImageView(
                                        onTap: () {
                                          /*  item.count = item.count! + 1;
                                          totalPrice.value =
                                              item.price! * item.count!;
                                          totalServiceCostDB?.put(
                                              "cost", totalPrice.value);*/
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesPlus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                    ],
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

  Widget bookingCategoryList() {
    return myCategory.isEmpty
        ? const Center(
            child: Text("Nothing to show in cart"),
          )
        : StatefulBuilder(
            builder: (context, setState) => ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myCategory.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = myCategory[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 15,
                  ).r,
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
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.subcatg ?? "",
                                      style:
                                          CustomTextStyles.bodyMediumBlack900,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            3.verticalSpace,
                            Text(
                              item.name ?? "",
                              style: CustomTextStyles.bodyMediumGray50013,
                            ),
                            10.verticalSpace,
                            Padding(
                              padding: const EdgeInsets.only(right: 10).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImageView(
                                        onTap: () {
                                          if (item.count! > 1) {
                                            /* item.count = item.count! - 1;
                                            totalPrice.value =
                                                item.price! * item.count!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);*/
                                          } else {
                                            myCategory.removeAt(index);
                                            totalPrice.value =
                                                totalPrice.value -
                                                    double.tryParse(
                                                        item.price ?? "")!;
                                            totalServiceCostDB?.put(
                                                "cost", totalPrice.value);
                                          }
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesMinus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        item.count.toString(),
                                        style: CustomTextStyles
                                            .bodyMediumGray50013,
                                      ),
                                      10.horizontalSpace,
                                      CustomImageView(
                                        onTap: () {
                                          /*  item.count = item.count! + 1;
                                          totalPrice.value =
                                              item.price! * item.count!;
                                          totalServiceCostDB?.put(
                                              "cost", totalPrice.value);*/
                                          setState(() {});
                                        },
                                        imagePath: Assets.imagesPlus,
                                        height: 40.r,
                                        width: 40.r,
                                      ),
                                    ],
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

  Widget myCartTextRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Cart",
            style: CustomTextStyles.displaySmallOnPrimary,
          ),
          CustomImageView(
            imagePath: Assets.imagesLogo2,
            height: 65.r,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> searchTextField() {
    return ValueListenableBuilder(
      valueListenable: showSearchBar,
      builder: (context, value, child) => value
          ? TextFieldSearchPage(
              onChanged: (val) {
                // categoryController.searchService(val);
              },
              edgeInsets: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ).r,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              controller: searchController,
              labelText: "Search Cart",
              prefixWidget: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  void calculateTotalPrice() {
    if (myCartList.isNotEmpty) {
      for (int i = 0; i < myCartList.length; i++) {
        totalPrice.value += myCartList[i].price! * myCartList[i].count!;
        print("dfgdfg ${totalPrice.value}");
        totalServiceCostDB?.put("cost", totalPrice.value);
      }
    } else if (myConsultantModel.isNotEmpty) {
      for (int i = 0; i < myConsultantModel.length; i++) {
        totalPrice.value +=
            myConsultantModel[i].price * myConsultantModel[i].count!;
        print("dfgdfg ${totalPrice.value}");
        totalServiceCostDB?.put("cost", totalPrice.value);
      }
    } else if (myAMCList.isNotEmpty) {
      for (int i = 0; i < myAMCList.length; i++) {
        totalPrice.value += myAMCList[i].price! * myAMCList[i].count!;
        print("dfgdfg ${totalPrice.value}");
        totalServiceCostDB?.put("cost", totalPrice.value);
      }
    } else {
      for (int i = 0; i < myCategory.length; i++) {
        totalPrice.value +=
            double.tryParse(myCategory[i].price!)! * myCategory[i].count!;
        print("dfgdfg ${totalPrice.value}");
        totalServiceCostDB?.put("cost", totalPrice.value);
      }
    }
  }

  void initWorkers() {
    workers = [
      ever(
        categoryController.bookServiceResponseModel,
        (callback) {
          if (callback.status == "Done") {
            Flushbar(
              duration: const Duration(seconds: 3),
              backgroundColor: const Color(0xffA41C8E),
              flushbarPosition: FlushbarPosition.BOTTOM,
              messageText: const Text(
                "Service Booked Successfully",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ).show(context);
            Future.delayed(
              const Duration(seconds: 2),
              () => pageNotifier.value = 0,
            );
            serviceBookingTime?.clear();
            totalServiceCostDB?.clear();
            myCartList.clear();
            myConsultantModel.clear();
            myAMCList.clear();
            myCategory.clear();
          }
        },
      ),
      ever(categoryController.errorMessage, (callback) {
        Flushbar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: Text(
            callback,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }),
    ];
  }

  void releaseWorker() {
    for (var temp in workers) {
      if (!temp.disposed) {
        temp.dispose();
      }
    }
  }
}
