import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/controller/internet_controller/internet_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/search_page.dart';
import 'package:wave_app/ui/home/service_details_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/custom_text_field.dart';
import 'package:wave_app/widgets/home_side_menu.dart';

ValueNotifier<bool> widgetNotifier = ValueNotifier(false);
ValueNotifier<List<ServicesModel>> serviceListNotifier = ValueNotifier([]);

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.customerAuthResponseModel});

  final CustomerAuthResponseModel? customerAuthResponseModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  PageController pageController = PageController();
  ValueNotifier<bool> slidePage = ValueNotifier(false);
  var categoryController = Get.put(AllCatController());
  var internetController = Get.put(InternetController());
  List<Worker> workers = [];
  String? customerData;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
    customerData = locationDB?.get("city").toString();
    print("City $customerData");
    initWorkers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavDrawer(),
        drawerDragStartBehavior: DragStartBehavior.down,
        appBar: pageAppBar(),
        backgroundColor: Colors.white,
        //const Color(0xfff5f5f5),
        body: GetBuilder<AllCatController>(
          builder: (controller) => controller.loading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: mainWidgetTwo(),
                ),
        ),
      ),
    );
  }

  Widget mainWidgetTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidgetTwo("Home"),
        5.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          child: SizedBox(
            width: 200.w,
            child: Row(
              children: [
                Text(
                  customerData ?? "Ahmedabad",
                  style: CustomTextStyles.bodySmallff9b9b9b13,
                ),
                3.horizontalSpace,
                RotatedBox(
                  quarterTurns: 3,
                  child: CustomImageView(
                    imagePath: Assets.imagesBackIcon,
                    scale: 3.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        10.verticalSpace,
        TextFieldDesignPage(
          readOnly: true,
          onTap: () {
            Get.to(const SearchPage());
          },
          edgeInsets: const EdgeInsets.symmetric(vertical: 5, horizontal: 15).r,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.text,
          controller: searchController,
          labelText: "Search",
          prefixWidget: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
        10.verticalSpace,
        Container(
          height: 0.3.sh,
          decoration: const BoxDecoration(),
          child: ValueListenableBuilder(
            valueListenable: serviceListNotifier,
            builder: (context, value, child) => GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5).r,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: value.length,
              itemBuilder: (context, index) {
                final firstList = value[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ServiceDetailsPage(categoryModel: firstList),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      5.verticalSpace,
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ).r,
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 30,
                        ).r,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5).r,
                        ),
                        child: CustomImageView(
                          alignment: Alignment.center,
                          //margin: const EdgeInsets.only(left: 10),
                          height: 40.h,
                          imagePath: firstList.thumbnail,
                        ),
                      ),
                      2.verticalSpace,
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          firstList.servicename ?? "",
                          style: CustomTextStyles.bodySmallErrorContainer,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 15, top: 15).r,
          height: 10.h,
          color: const Color(0xfff5f5f5),
        ),
        labelWidgetOne("Talk to Our Experts"),
        10.verticalSpace,
        newCategoryListView(),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 15).r,
          height: 10.h,
          color: const Color(0xfff5f5f5),
        ),
        SizedBox(
          height: 250.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemCount: verticalBanner.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8).r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10).r,
                child: CustomImageView(
                  width: 130.w,
                  fit: BoxFit.fill,
                  imagePath: verticalBanner[index],
                  placeHolder: "Please wait",
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 15, top: 15).r,
          height: 10.h,
          color: const Color(0xfff5f5f5),
        ),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemCount: horizontalBanners.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10).r,
                child: CustomImageView(
                  fit: BoxFit.fill,
                  imagePath: horizontalBanners[index],
                  placeHolder: "Please wait",
                ),
              ),
            ),
          ),
        ),
        //homeServicesListView(),
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 15).r,
          height: 10.h,
          color: const Color(0xfff5f5f5),
        ),
        labelWidgetOne("Find other services"),
        10.verticalSpace,
        amcCategoryListView(),
      ],
    );
  }

  Row ratingBarRow(int rating) {
    return Row(
      children: [
        RatingBar(
          initialRating: double.parse(rating.toString()),
          allowHalfRating: true,
          itemCount: 1,
          glowColor: Colors.orangeAccent,
          itemSize: 12,
          ratingWidget: RatingWidget(
            full: Icon(
              Icons.star_sharp,
              color: Colors.black.withOpacity(0.5),
            ),
            half: Icon(
              Icons.star_half_sharp,
              color: Colors.black.withOpacity(0.5),
            ),
            empty: const Icon(
              Icons.star_border_sharp,
            ),
          ),
          onRatingUpdate: (double value) {},
        ),
        1.horizontalSpace,
        Text(
          "${double.parse(rating.toString())}",
          style: CustomTextStyles.bodySmallGrey11,
        ),
        2.horizontalSpace,
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
        height: 160.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: controller.allConsultantResponse.value?.data.length ?? 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList =
                controller.allConsultantResponse.value?.data[index];
            return GestureDetector(
              onTap: () {
                Get.to(ServiceDetailsPage(consultant: secondList));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ).r,
                    child: CustomImageView(
                      height: 90.r,
                      width: 90.r,
                      imagePath: secondList?.thumbnail,
                    ),
                  ),
                  5.verticalSpace,
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      secondList?.servicename ?? "",
                      style: CustomTextStyles.bodySmallErrorContainer,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  ratingBarRow(
                    secondList?.rating ?? 1,
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
                      text: "₹${secondList?.price}",
                      style: CustomTextStyles.bodyMediumGrey13,
                    ),
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

  Widget amcCategoryListView() {
    return GetBuilder<AllCatController>(
      builder: (controller) => SizedBox(
        height: 140.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: controller.allAmcProducts.value?.data?.length ?? 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList = controller.allAmcProducts.value?.data?[index];
            return GestureDetector(
              onTap: () {
                Get.to(ServiceDetailsPage(categoryModel: secondList));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ).r,
                    child: CustomImageView(
                      height: 70.r,
                      width: 70.r,
                      imagePath: secondList?.thumbnail,
                    ),
                  ),
                  5.verticalSpace,
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      secondList?.servicename ?? "",
                      style: CustomTextStyles.bodySmallErrorContainer,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  ratingBarRow(
                    secondList?.rating ?? 1,
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
                      text: "₹${secondList?.price}",
                      style: CustomTextStyles.bodyMediumGrey13,
                    ),
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

  Widget labelWidgetTwo(String? labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ).r,
      child: Text(
        labelText ?? "Home Services",
        style: CustomTextStyles.bodyMedium_1,
      ),
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

  void slideBanner() {
    pageController.addListener(() {
      if (slidePage.value == true) {
        Future.delayed(
          const Duration(seconds: 5),
          () => pageController.nextPage(
            duration: const Duration(
              seconds: 2,
            ),
            curve: Curves.ease,
          ),
        );
        slidePage.value = false;
      }
    });
  }

  AppBar pageAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Color(0xffA41C8E),
      ),
    );
  }

  void initWorkers() {
    ///internet worker
    ever(internetController.message, (callback) {
      if (callback == "Internet Connection Gained") {
        debugPrint("Proper internet connection");
        categoryController.getAllCategory();
        categoryController.getAllConsultants();
        categoryController.getAmcProducts();
      } else {
        Flushbar(
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: Text(
            callback,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    });
    ever(categoryController.errorMessage, (callback) {
      Flushbar(
        backgroundColor: const Color(0xffA41C8E),
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: Text(
          callback,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ).show(context);
    });
  }
}

List horizontalBanners = [
  "http://wavetechservices.in/appimages/homebanners/h1.png",
  "http://wavetechservices.in/appimages/homebanners/h2.png",
  "http://wavetechservices.in/appimages/homebanners/h3.png",
  "http://wavetechservices.in/appimages/homebanners/h4.png",
  "http://wavetechservices.in/appimages/homebanners/h5.png",
  "http://wavetechservices.in/appimages/homebanners/h6.png",
];

List verticalBanner = [
  "http://wavetechservices.in/appimages/homebanners/v1.png",
  "http://wavetechservices.in/appimages/homebanners/v2.png",
  "http://wavetechservices.in/appimages/homebanners/v3.png",
  "http://wavetechservices.in/appimages/homebanners/v4.png",
  "http://wavetechservices.in/appimages/homebanners/v5.png",
];
