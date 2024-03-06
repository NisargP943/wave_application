import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/ui/home/order_details_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/search_textfield_widget.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> showSearchBar = ValueNotifier(false);
  late TextEditingController searchController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    tabController = TabController(length: 3, vsync: this);
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
          searchTextField(),
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
          inProgressServiceList(),
          inProgressServiceList(),
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ).r,
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) => serviceDetailsItem(),
    );
  }

  Widget serviceDetailsItem() {
    return Container(
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
                      text: "123456",
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
                DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
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
                  text: "IW3475453455",
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
                      text: "1",
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
                      text: "Rs350",
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
                    const OrderDetailsPage(),
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
    );
  }

  Widget searchIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(
              width: 24.r,
              height: 24.r,
              imagePath: Assets.imagesBackIcon,
              onTap: () {
                pageNotifier.value = 0;
              },
            ),
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
      ),
    );
  }

  ValueListenableBuilder<bool> searchTextField() {
    return ValueListenableBuilder(
      valueListenable: showSearchBar,
      builder: (context, value, child) => value
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10).r,
              child: TextFieldSearchPage(
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
              ),
            )
          : const SizedBox.shrink(),
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
}
