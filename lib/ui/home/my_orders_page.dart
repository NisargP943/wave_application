import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/response/booked_service_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/ui/home/order_details_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/search_textfield_widget.dart';

ValueNotifier<List<BookedServiceModel>> bookedServiceModel = ValueNotifier([]);
List<BookedServiceModel> bookedList = [],
    completedList = [],
    cancelledList = [];

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  late TabController tabController;
  var categoryController = Get.put(AllCatController());
  List<Worker> workers = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    tabController = TabController(length: 3, vsync: this);
    categoryController
        .getBookedServiceApi(nameDB?.get("mobile"))
        .then((value) => debugPrint("lvkdldknfdg"));
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          40.verticalSpace,
          searchIcon(),
          20.verticalSpace,
          myOrderTextRow(),
          10.verticalSpace,
          ordersTabBar(),
          5.verticalSpace,
          tabBarViewWidget()
        ],
      ),
    );
  }

  Widget tabBarViewWidget() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          inProgressServiceList(),
          completedServiceList(),
          cancelledServiceList(),
        ],
      ),
    );
  }

  Widget ordersTabBar() {
    return TabBar(
      splashBorderRadius: const BorderRadius.all(Radius.circular(20)).r,
      physics: const NeverScrollableScrollPhysics(),
      unselectedLabelStyle: const TextStyle(
        color: Colors.black,
      ),
      indicatorPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      indicator: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)).r,
        color: Colors.purple,
      ),
      controller: tabController,
      tabs: const [
        Tab(
          text: "In Progress",
        ),
        Tab(
          text: "Completed",
        ),
        Tab(
          text: "Cancelled",
        ),
      ],
    );
  }

  Widget inProgressServiceList() {
    return bookedList.isEmpty
        ? const Center(
            child: Text("No Service Booked"),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ).r,
            itemCount: bookedList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 20).r,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ).r,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
                borderRadius: BorderRadius.circular(8).r,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "OrderNo : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.spMin,
                          ),
                          children: [
                            TextSpan(
                              text: bookedList[index].id,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.spMin,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        bookedList[index].bookdate ?? "",
                        style: TextStyle(
                          fontSize: 13.spMin,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  10.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: "Tracking number: ",
                      style: CustomTextStyles.bodySmallff9b9b9b,
                      children: [
                        TextSpan(
                          text: bookedList[index].id,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.spMin,
                              fontFamily: "Arial"),
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Quantity: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: bookedList[index].quantity,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Total Amount: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: "Rs${bookedList[index].price}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            OrderDetailsPage(
                                bookedServiceModel: bookedList[index],
                                fromHomePage: false),
                            duration: const Duration(seconds: 1),
                            transition: Transition.fadeIn,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ).r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30).r,
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Text("Details"),
                        ),
                      ),
                      Text(
                        "In Progress",
                        style: CustomTextStyles.bodyMediumGreen600,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget completedServiceList() {
    return completedList.isEmpty
        ? const Center(
            child: Text("No Service Completed"),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ).r,
            itemCount: completedList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 20).r,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ).r,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
                borderRadius: BorderRadius.circular(8).r,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "OrderNo : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.spMin,
                          ),
                          children: [
                            TextSpan(
                              text: completedList[index].id,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.spMin,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        completedList[index].bookdate ?? "",
                        style: TextStyle(
                          fontSize: 13.spMin,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  10.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: "Tracking number: ",
                      style: CustomTextStyles.bodySmallff9b9b9b,
                      children: [
                        TextSpan(
                          text: completedList[index].id,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.spMin,
                              fontFamily: "Arial"),
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Quantity: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: completedList[index].quantity,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Total Amount: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: "Rs${completedList[index].price}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            OrderDetailsPage(
                                bookedServiceModel: completedList[index]),
                            duration: const Duration(seconds: 1),
                            transition: Transition.fadeIn,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ).r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30).r,
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Text("Details"),
                        ),
                      ),
                      Text(
                        "Completed",
                        style: CustomTextStyles.bodyMediumGreen600,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget cancelledServiceList() {
    return cancelledList.isEmpty
        ? const Center(
            child: Text("No Service Cancelled"),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ).r,
            itemCount: cancelledList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 20).r,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ).r,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
                borderRadius: BorderRadius.circular(8).r,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "OrderNo : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.spMin,
                          ),
                          children: [
                            TextSpan(
                              text: cancelledList[index].id,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.spMin,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        cancelledList[index].bookdate ?? "",
                        style: TextStyle(
                          fontSize: 13.spMin,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  10.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: "Tracking number: ",
                      style: CustomTextStyles.bodySmallff9b9b9b,
                      children: [
                        TextSpan(
                          text: cancelledList[index].id,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.spMin,
                              fontFamily: "Arial"),
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Quantity: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: cancelledList[index].quantity,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Total Amount: ",
                          style: CustomTextStyles.bodySmallff9b9b9b,
                          children: [
                            TextSpan(
                              text: "Rs${cancelledList[index].price}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.spMin,
                                fontFamily: "Arial",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*  Get.to(
                      OrderDetailsPage(
                          bookedServiceModel: cancelledList?[index]),
                      duration: const Duration(seconds: 1),
                      transition: Transition.fadeIn,
                    );*/
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ).r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30).r,
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Text("Details"),
                        ),
                      ),
                      Text(
                        "In Progress",
                        style: CustomTextStyles.bodyMediumGreen600,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget searchIcon() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: CustomImageView(
          width: 24.r,
          height: 24.r,
          imagePath: Assets.imagesBackIcon,
          onTap: () {
            pageNotifier.value = 0;
          },
        ),
      ),
    );
  }

  Widget myOrderTextRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Orders",
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

  void initWorker() {
    ever(
      categoryController.bookedServiceListResponseModel,
      (callback) {
        debugPrint("Booked Service List feteched");
        bookedList = callback.data
                ?.where((element) => element.status == "Booked")
                .toList() ??
            [];
        completedList = callback.data
                ?.where((element) => element.status == "Completed")
                .toList() ??
            [];
        cancelledList = callback.data
                ?.where((element) => element.status == "Cancelled")
                .toList() ??
            [];
        setState(() {});
      },
    );
  }

  Future navigateToDetails(BookedServiceModel bookedServiceModel) async {
    final result = await Get.to(
      duration: const Duration(seconds: 1),
      transition: Transition.fadeIn,
      OrderDetailsPage(
        bookedServiceModel: bookedServiceModel,
      ),
    );
    if (result != null) {
      categoryController.getBookedServiceApi(nameDB?.get("mobile"));
      setState(() {});
    }
  }
}
