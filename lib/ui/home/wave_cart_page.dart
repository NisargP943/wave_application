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
  ValueNotifier<int> totalPrice = ValueNotifier(0);
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
    if (myCartList.isNotEmpty) {
      for (int i = 0; i < myCartList.length; i++) {
        totalPrice.value += myCartList[i].price! * myCartList[i].count!;
        print("dfgdfg ${totalPrice.value}");
        totalServiceCostDB?.put("cost", totalPrice.value);
      }
    }
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
          bookingServiceList(),
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
          ThinTextField(
            controller: codeController,
            labelText:
                codeController.text.isEmpty ? "Enter your promo code" : "1234",
            onTap: () {
              showPromoCodeBottomSheet();
            },
          ),
          30.verticalSpace,
          totalPriceRow(),
          30.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).r,
            child: AppButtonWidget(
              onTap: () {
                callBookServiceApi();
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
    categoryController.bookService(
      name: nameDB!.get("customername").toString(),
      number: "9327053587",
      cityLat: "23.0039",
      cityLong: "72.5461",
      address: "Vasna Ahmedabad",
      bookingDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      bookingTime: DateFormat.jm().format(DateTime.now()).toLowerCase(),
      landmark: "Indian oil petrol pump",
      sdetails: "3883-Inverterservice-1-300 ",
      amcDetails: "4023-AMC-1-1499",
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
