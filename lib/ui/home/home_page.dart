import 'dart:async';

import 'package:animated_icon/animated_icon.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/model/response/all_consultants_response_model.dart';
import 'package:wave_app/model/response/amc_response_model.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/location_screen.dart';
import 'package:wave_app/ui/home/order_details_page.dart';
import 'package:wave_app/ui/home/search_page.dart';
import 'package:wave_app/ui/home/service_details_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/drop_down_textfield.dart';
import 'package:wave_app/widgets/home_side_menu.dart';

ValueNotifier<List<ServicesModel>> serviceListNotifier = ValueNotifier([]);
ValueNotifier<List<Consultant>> consultantListNotifier = ValueNotifier([]);
ValueNotifier<List<ServiceModel>> amcListNotifier = ValueNotifier([]);

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.customerAuthResponseModel});

  final CustomerAuthResponseModel? customerAuthResponseModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SingleValueDropDownController searchController =
      SingleValueDropDownController();
  TextEditingController locationController = TextEditingController();
  late StreamSubscription connectivity;
  PageController pageController = PageController();
  var categoryController = Get.put(AllCatController());
  ValueNotifier<int> hIndex = ValueNotifier(0);
  List<Worker> workers = [];
  String? customerData, custName;
  List<DropDownValueModel> dropDownList = [];
  bool? serviceEnabled;
  late LocationPermission permission;
  late Position position;
  List<Placemark> address = [];
  bool end = false;
  late Timer timer;

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
    custName = nameDB?.get("customername");
    debugPrint("City $customerData  Name $custName");
    checkConnectivity();
    initWorkers();
    _determinePosition();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (hIndex.value == 5) {
        end = true;
      } else if (hIndex.value == 0) {
        end = false;
      }

      if (end == false) {
        hIndex.value++;
      } else {
        hIndex.value--;
      }

      pageController.animateToPage(
        hIndex.value,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    timer.cancel();
    connectivity.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavDrawer(),
        drawerDragStartBehavior: DragStartBehavior.down,
        backgroundColor: Colors.white,
        //const Color(0xfff5f5f5),
        body: GetBuilder<AllCatController>(
          builder: (controller) => controller.loading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(child: mainWidgetTwo()),
        ),
      ),
    );
  }

  Widget serviceDetailsItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5).r,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 15,
      ).r,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
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
              Row(
                children: [
                  Text(
                    "In Progress",
                    style: CustomTextStyles.bodyMediumGreen600,
                  ),
                  5.horizontalSpace,
                  AnimateIcon(
                    height: 25.r,
                    width: 25.r,
                    onTap: () {},
                    iconType: IconType.continueAnimation,
                    animateIcon: AnimateIcons.bell,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget mainWidgetTwo() {
    return CustomScrollView(
      slivers: [
        pageAppBar(),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.verticalSpace,
              GestureDetector(
                onTap: () {
                  Get.to(
                      LocationPage(
                        location: customerData!,
                      ),
                      transition: Transition.fadeIn,
                      duration: const Duration(seconds: 1));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ).r,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          customerData ?? "Ahmedabad",
                          style: CustomTextStyles.bodySmallff9b9b9b13,
                          overflow: TextOverflow.ellipsis,
                        ),
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
              DropDownTextFieldSearchPage(
                controller: searchController,
                onChanged: (p0) {
                  if (searchController.dropDownValue?.value != null) {
                    Get.to(
                      SearchServicePage(
                        serviceName: searchController.dropDownValue?.value,
                      ),
                      transition: Transition.fadeIn,
                      duration: const Duration(seconds: 1),
                    );
                  }
                },
                edgeInsets:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15).r,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                labelText: "Click to search",
                prefixWidget: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                dropDownList: dropDownList,
              ),
              15.verticalSpace,
              labelWidgetOne("Welcome, $custName"),
              3.verticalSpace,
              labelWidgetOne("Wave Home"),
              10.verticalSpace,
              serviceDetailsItem(),
              15.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15).r,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10).r,
                  child: CustomImageView(
                    imagePath:
                        "http://kalasampurna.com/wavetech/webimages/home11.png",
                  ),
                ),
              ),
              5.verticalSpace,
              ValueListenableBuilder(
                  valueListenable: serviceListNotifier,
                  builder: (context, value, child) => Container(
                        height: 0.3.sh,
                        decoration: const BoxDecoration(),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5)
                              .r,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final firstList = value[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  transition: Transition.fadeIn,
                                  duration: const Duration(seconds: 1),
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
                                      style: CustomTextStyles
                                          .bodySmallErrorContainer,
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
                      )),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 15).r,
                height: 10.h,
                color: const Color(0xfff5f5f5),
              ),
              labelWidgetOne("Talk to Our Experts"),
              10.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15).r,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10).r,
                  child: CustomImageView(
                    imagePath:
                        "http://kalasampurna.com/wavetech/webimages/home12.png",
                  ),
                ),
              ),
              5.verticalSpace,
              newCategoryListView(),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 15).r,
                height: 10.h,
                color: const Color(0xfff5f5f5),
              ),
              labelWidgetOne("AMC Services"),
              10.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15).r,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10).r,
                  child: CustomImageView(
                    imagePath:
                        "http://kalasampurna.com/wavetech/webimages/home13.png",
                  ),
                ),
              ),
              10.verticalSpace,
              amcCategoryListView(),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 15).r,
                height: 10.h,
                color: const Color(0xfff5f5f5),
              ),
              SizedBox(
                height: 250.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
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
                child: PageView.builder(
                  onPageChanged: (value) {
                    hIndex.value = value;
                  },
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
              10.verticalSpace,
            ],
          ),
        )
      ],
      physics: const BouncingScrollPhysics(),
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
    return ValueListenableBuilder(
      valueListenable: consultantListNotifier,
      builder: (context, value, widget) => SizedBox(
        height: 160.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: value.length,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList = value[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                    transition: Transition.fadeIn,
                    duration: const Duration(seconds: 1),
                    ServiceDetailsPage(consultant: secondList));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ).r,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ).r,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    child: CustomImageView(
                      height: 60.r,
                      imagePath: secondList.thumbnail,
                    ),
                  ),
                  5.verticalSpace,
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      secondList.servicename,
                      style: CustomTextStyles.bodySmallErrorContainer,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  ratingBarRow(
                    secondList.rating,
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
                      text: "₹${secondList.price}",
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
    return ValueListenableBuilder(
      valueListenable: amcListNotifier,
      builder: (context, value, widget) => SizedBox(
        height: 150.h,
        //  color: Colors.red,
        child: ListView.separated(
          itemCount: value.length,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ).r,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final secondList = value[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                  ServiceDetailsPage(amcModel: secondList),
                  transition: Transition.fadeIn,
                  duration: const Duration(seconds: 1),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ).r,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ).r,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5).r,
                    ),
                    child: CustomImageView(
                      height: 60.r,
                      imagePath: secondList.thumbnail,
                    ),
                  ),
                  5.verticalSpace,
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      secondList.servicename ?? "",
                      style: CustomTextStyles.bodySmallErrorContainer,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  ratingBarRow(
                    secondList.rating ?? 1,
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
                      text: "₹${secondList.srate}",
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

  SliverAppBar pageAppBar() {
    return const SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      expandedHeight: 50,
      elevation: 0,
      shadowColor: Colors.white,
      iconTheme: IconThemeData(
        color: Color(0xffA41C8E),
      ),
      floating: true,
    );
  }

  void initWorkers() {
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

  void checkConnectivity() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        categoryController.getAllCategory().then((value) {
          for (int i = 0; i < serviceListNotifier.value.length; i++) {
            dropDownList.add(
              DropDownValueModel(
                name: serviceListNotifier.value[i].servicename ?? "",
                value: serviceListNotifier.value[i].servicename,
              ),
            );
          }
        });
        categoryController.getAllConsultants();
        categoryController.getAmcProducts();
      } else {
        categoryController.loading.value = false;
        categoryController.update();
        Flushbar(
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "No Active Internet Connection",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    });
    connectivity = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        debugPrint("This is called");
        categoryController.getAllCategory().then((value) {
          for (int i = 0; i < serviceListNotifier.value.length; i++) {
            dropDownList.add(
              DropDownValueModel(
                name: serviceListNotifier.value[i].servicename ?? "",
                value: serviceListNotifier.value[i].servicename,
              ),
            );
          }
        });
        categoryController.getAllConsultants();
        categoryController.getAmcProducts();
      }
      if (event == ConnectivityResult.none) {
        debugPrint("This called");
        Flushbar(
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "No Internet Connection",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    });
  }

  Future<Position> _determinePosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    position = await Geolocator.getCurrentPosition();
    convertLatLongToAddress(position.latitude, position.longitude);
    debugPrint("current location ${position.longitude.toString()}");
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Placemark>> convertLatLongToAddress(
      double latitude, double longitude) async {
    address = await placemarkFromCoordinates(latitude, longitude);
    locationDB?.put("city",
        "${address[0].street},${address[0].subLocality},${address[0].locality},${address[0].postalCode}");
    debugPrint(
        "----------------------------------------------------value after conversion : ${address[0].street}, ${address[0].subLocality}, ${address[0].locality}, ${address[0].postalCode}");
    return address;
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
