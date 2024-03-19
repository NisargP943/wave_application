import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/home_page.dart';
import 'package:wave_app/ui/home/service_details_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/dp_textfield.dart';
import 'package:wave_app/widgets/drop_down_textfield.dart';

ValueNotifier<List<ServicesModel>> searchServiceNotifier = ValueNotifier([]);

class SearchServicePage extends StatefulWidget {
  const SearchServicePage({super.key, this.serviceName});

  final String? serviceName;

  @override
  State<SearchServicePage> createState() => _SearchServicePageState();
}

class _SearchServicePageState extends State<SearchServicePage> {
  SingleValueDropDownController searchController =
      SingleValueDropDownController();
  late StreamSubscription connectivity;
  SpeechToText speechToText = SpeechToText();
  List<ServicesModel> serviceList = [];
  List<DropDownValueModel> dropDownList = [];
  bool _speechEnabled = false;
  String _lastWords = '';

  List<String> category = [
    "Astrologers",
    "Caterers",
    "CAR Service",
    "Bike Service",
    "Consultants - Advisory Service",
    "Contractors",
    "Health Care",
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
  String cat = "";
  var categoryController = Get.put(AllCatController());

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    serviceList = serviceListNotifier.value;
    ever(categoryController.errorMessage, (callback) {
      Future.delayed(const Duration(seconds: 1), () {
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
      });
    });
    for (int i = 0; i < serviceListNotifier.value.length; i++) {
      dropDownList.add(
        DropDownValueModel(
          name: serviceListNotifier.value[i].servicename ?? "",
          value: serviceListNotifier.value[i].servicename,
        ),
      );
    }
    debugPrint("Hello ${widget.serviceName}");
  }

  @override
  void dispose() {
    searchController.dispose();
    speechToText.cancel();
    super.dispose();
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
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            scale: 1.8,
            Assets.imagesBackIcon,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
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
        5.verticalSpace,
        DropDownTextFieldSearchPage(
          suffixCallBack: () {
            checkPermission();
          },
          dropDownList: dropDownList,
          onChanged: (val) {
            if (searchController.dropDownValue?.value != null) {
              searchServiceNotifier.value.clear();
              cat = "";
              categoryController
                  .searchService(searchController.dropDownValue?.value);
              Future.delayed(const Duration(seconds: 1), () {
                for (int i = 0; i < searchServiceNotifier.value.length; i++) {
                  cat = searchServiceNotifier.value[i].catg!;
                }
                final tempList =
                    serviceList.where((element) => element.catg == cat);
                searchServiceNotifier.value = tempList.toList();
              });
            }
          },
          edgeInsets: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 0,
          ).r,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.text,
          controller: searchController,
          labelText: "Search Service",
          prefixWidget: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
        10.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).r,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Wave Top Rated",
              style: CustomTextStyles.bodyMediumBlack900,
            ),
          ),
        ),
        10.verticalSpace,
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
                  categoryController.searchService(category[index]);
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
        5.verticalSpace,
        ValueListenableBuilder(
          valueListenable: searchServiceNotifier,
          builder: (context, value, widget) => value == []
              ? const Center(
                  child: Text("No Data Found"),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ).r,
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final subCategory = value[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              ServiceDetailsPage(
                                categoryModel: subCategory,
                                fromSearchPage: true,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 13).r,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8).r,
                            ),
                            padding: const EdgeInsets.only(
                                    left: 15, top: 3, bottom: 3)
                                .r,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 0.1.sh,
                                  child: GestureDetector(
                                    onTap: () {
                                      debugPrint("Hello from search");
                                      /*  subCategory.isFav != subCategory.isFav;
                                      setState(() {});*/
                                    },
                                    child: Image.asset(
                                      Assets.imagesUnselectedFav,
                                      scale: 2,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    5.verticalSpace,
                                    Center(
                                      child: CustomImageView(
                                        height: 100.h,
                                        imagePath: subCategory.thumbnail,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          child: Text(
                                            "₹ ${subCategory.servicename}",
                                            style: CustomTextStyles
                                                .bodyMediumGrey13,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        5.verticalSpace,
                                        ratingBarRow(),
                                        5.verticalSpace,
                                        Text(
                                          "₹ ${subCategory.price}",
                                          style: CustomTextStyles
                                              .bodySmallff222222,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        )
      ],
    );
  }

  Row ratingBarRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
          style: CustomTextStyles.bodySmallGrey11,
        )
      ],
    );
  }

  void checkConnectivity() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        categoryController.searchService(widget.serviceName!).then((value) {
          Future.delayed(const Duration(seconds: 1), () {
            for (int i = 0; i < searchServiceNotifier.value.length; i++) {
              cat = searchServiceNotifier.value[i].catg!;
            }
            final tempList =
                serviceList.where((element) => element.catg == cat);
            searchServiceNotifier.value += tempList.toList();
          });
        });
      } else {
        categoryController.loading.value = false;
        categoryController.update();
        Future.delayed(
          const Duration(seconds: 1),
          () => Flushbar(
            duration: const Duration(seconds: 4),
            backgroundColor: const Color(0xffA41C8E),
            flushbarPosition: FlushbarPosition.BOTTOM,
            messageText: const Text(
              "No Active Internet Connection",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ).show(context),
        );
      }
    });
    connectivity = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        categoryController.searchService(widget.serviceName!).then((value) {
          Future.delayed(const Duration(seconds: 1), () {
            for (int i = 0; i < searchServiceNotifier.value.length; i++) {
              cat = searchServiceNotifier.value[i].catg!;
            }
            final tempList =
                serviceList.where((element) => element.catg == cat);
            searchServiceNotifier.value += tempList.toList();
          });
        });
      } else {
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

  Future _initSpeech() async {
    try {
      _speechEnabled = await speechToText.initialize(
        onStatus: (status) {},
        onError: (errorNotification) {},
      );
      _startListening();
    } on SpeechToTextNotInitializedException catch (e) {
      if (mounted) {
        Flushbar(
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "Voice Search is Supported only in Device above Android 11",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        Flushbar(
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xffA41C8E),
          flushbarPosition: FlushbarPosition.BOTTOM,
          messageText: const Text(
            "Voice Search is Supported only in Device above Android 11",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    }
  }

  void _startListening() async {
    debugPrint(_speechEnabled.toString());
    if (_speechEnabled) {
      await speechToText.listen(onResult: _onSpeechResult);
      setState(() {});
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (_lastWords.isNotEmpty) {
      searchController.dropDownValue =
          DropDownValueModel(name: _lastWords, value: _lastWords);
      Future.delayed(
        const Duration(
          seconds: 1,
        ),
        () => categoryController
            .searchService(searchController.dropDownValue?.value),
      );
      debugPrint(_lastWords);
    }
  }

  Future checkPermission() async {
    var permission = await Permission.audio.status;
    if (permission.isDenied || permission.isPermanentlyDenied) {
      permission = await Permission.audio.request();
      await _initSpeech();
    }
  }
}
