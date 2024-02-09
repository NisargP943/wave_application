import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:wave_app/controller/auth_controller/auth_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/theme/app_decoration.dart';
import 'package:wave_app/theme/theme_helper.dart';
import 'package:wave_app/ui/auth/login_with_email_page.dart';
import 'package:wave_app/values/string.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/custom_text_field.dart';

// ignore_for_file: must_be_immutable
class SignUpPageScreen extends StatefulWidget {
  const SignUpPageScreen(
      {Key? key, this.customerAuthResponseModel, this.mobileNumber})
      : super(key: key);
  final CustomerAuthResponseModel? customerAuthResponseModel;
  final String? mobileNumber;

  @override
  State<SignUpPageScreen> createState() => _SignUpPageScreenState();
}

class _SignUpPageScreenState extends State<SignUpPageScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordAgainController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  ValueNotifier<bool> emailAccepted = ValueNotifier(false);

  ValueNotifier<bool> passwordAccepted = ValueNotifier(false);

  ValueNotifier<bool> nameAccepted = ValueNotifier(false);

  ValueNotifier<bool> passwordAgainAccepted = ValueNotifier(false);

  ValueNotifier<bool> currentLocation = ValueNotifier(false);
  ValueNotifier<bool> showPlaces = ValueNotifier(false);

  bool? serviceEnabled;

  late LocationPermission permission;

  late Position position;

  String session = "122334";

  late Uuid uuid;

  List places = [];

  List<Location> locations = [];

  List<Placemark> address = [];

  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    locationController.addListener(() {
      setState(() {
        if (session.isEmpty) {
          session = uuid.v4();
        }
      });
      getPlacesSuggestion();
    });
    _determinePosition().then(
      (value) => convertLatLongToAddress(value.latitude, value.longitude).then(
        (value) => locationController.text =
            "${value[0].locality}, ${value[0].postalCode}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                35.verticalSpace,
                Row(
                  children: [
                    CustomImageView(
                      imagePath: Assets.imagesBackIcon,
                      onTap: () {
                        onTapImgArrowLeft(context);
                      },
                      width: 24.r,
                      height: 24.r,
                    ),
                    const Spacer(),
                    CustomImageView(
                      imagePath: Assets.imagesLogo,
                      scale: 14,
                    ),
                    15.horizontalSpace,
                  ],
                ),
                _buildNavigationBarBig(context),
                65.verticalSpace,
                TextFieldDesignPage(
                  prefixWidget: const Icon(
                    Icons.person_2_outlined,
                    color: Colors.grey,
                  ),
                  accepted: nameAccepted,
                  controller: nameController,
                  labelText: "Name",
                  onChanged: (p0) {
                    if (p0.isEmpty) {
                      nameAccepted.value = false;
                    } else {
                      nameAccepted.value = true;
                    }
                  },
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.name,
                ),
                10.verticalSpace,
                TextFieldDesignPage(
                  prefixWidget: const Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                  ),
                  accepted: emailAccepted,
                  controller: emailController,
                  labelText: "Email",
                  onChanged: (p0) {
                    if (!p0.contains("@") || !p0.contains(".")) {
                      emailAccepted.value = false;
                    } else {
                      emailAccepted.value = true;
                    }
                  },
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                ),
                10.verticalSpace,
                TextFieldDesignPage(
                  prefixWidget: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.grey,
                  ),
                  accepted: passwordAccepted,
                  controller: passwordController,
                  labelText: "Password",
                  onChanged: (p0) {
                    if (p0.length < 6) {
                      passwordAccepted.value = false;
                    } else {
                      passwordAccepted.value = true;
                    }
                  },
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.visiblePassword,
                ),
                10.verticalSpace,
                TextFieldDesignPage(
                  prefixWidget: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.grey,
                  ),
                  accepted: passwordAgainAccepted,
                  controller: passwordAgainController,
                  labelText: "Password Again",
                  onChanged: (p0) {
                    if (p0.length < 6) {
                      passwordAgainAccepted.value = false;
                    } else if (p0 != passwordController.text) {
                      passwordAgainAccepted.value = false;
                    } else {
                      passwordAgainAccepted.value = true;
                    }
                  },
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                ),
                10.verticalSpace,
                TextFieldDesignPage(
                  prefixWidget: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),
                  controller: locationController,
                  labelText: "Current location",
                  onChanged: (p0) {
                    showPlaces.value = true;
                  },
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                ),
                10.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: showPlaces,
                  builder: (context, value, child) => !value
                      ? const SizedBox.shrink()
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15).r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10).r,
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ).r,
                            itemCount: places.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                locationController.text = places[index]
                                    ['structured_formatting']["main_text"];
                                convertAddressToLatLong(
                                    locationController.text);
                                showPlaces.value = false;
                              },
                              child: Text(
                                places[index]['structured_formatting']
                                    ["main_text"],
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return 15.verticalSpace;
                            },
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(LoginPageScreen());
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 1).r,
                            child: Text("Already have an account?",
                                style: theme.textTheme.bodyMedium),
                          ),
                          CustomImageView(
                            imagePath: Assets.imagesArrow,
                            height: 24.r,
                            width: 24.r,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                10.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15).r,
                  child: AppButtonWidget(
                    text: "SIGN UP WAVE Tech Services",
                    onTap: () {
                      validate();
                    },
                  ),
                ),
                14.verticalSpace,
                Text("Or sign up with social account",
                    style: theme.textTheme.bodyMedium),
                14.verticalSpace,
                _buildSeventySeven(context),
                30.verticalSpace,
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNavigationBarBig(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: Text("Sign Up", style: theme.textTheme.displaySmall),
      ),
    );
  }

  /// Section Widget
  Widget _buildSeventySeven(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 64.h,
          width: 92.w,
          decoration: AppDecoration.outlineBlack9004
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
          child: CustomImageView(
            imagePath: Assets.imagesGoogle,
            height: 24.r,
            width: 24.r,
            alignment: Alignment.center,
          ),
        ),
        10.horizontalSpace,
        Container(
          height: 64.h,
          width: 92.w,
          decoration: AppDecoration.outlineBlack9004
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
          child: CustomImageView(
            imagePath: Assets.imagesFacebook,
            height: 24.r,
            width: 24.r,
            alignment: Alignment.center,
          ),
        )
      ],
    );
  }

  void validate() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter name"),
        ),
      );
      return;
    } else if (nameController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid name"),
        ),
      );
      return;
    } else if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email"),
        ),
      );
      return;
    } else if (!emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid email"),
        ),
      );
      return;
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter password"),
        ),
      );
      return;
    } else if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid password"),
        ),
      );
      return;
    } else if (passwordAgainController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password doesn't matched"),
        ),
      );
      return;
    } else if (locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter current location"),
        ),
      );
      return;
    } else if (locationController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid current location"),
        ),
      );
      return;
    } else {
      authController.newUserSignUp(
        name: nameController.text,
        mobileNumber: widget.mobileNumber ?? "",
        email: emailController.text,
        password: passwordController.text,
        street: address[0].subLocality,
        city: address[0].locality,
        pincode: address[0].postalCode,
        lang: locations.isEmpty ? position.longitude : locations[0].longitude,
        lat: locations.isEmpty ? position.latitude : locations[0].latitude,
      );
      if (authController.loading.isTrue) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
    }
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
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
    debugPrint(position.longitude.toString());
    return await Geolocator.getCurrentPosition();
  }

  void getPlacesSuggestion() async {
    String request =
        '${Constant().placesBaseUrl}?input=${locationController.text}&key=${Constant().placesApiKey}.&sessiontoken=$session';
    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        places = jsonDecode(response.body)['predictions'];
        setState(() {});
        debugPrint(places.toString());
        //debugPrint(response.body);
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<List<Placemark>> convertLatLongToAddress(
      double latitude, double longitude) async {
    address = await placemarkFromCoordinates(latitude, longitude);
    locationController.text =
        "${address[0].subLocality}, ${address[0].locality}, ${address[0].postalCode}";
    debugPrint("value after conversion : ${locationController.text}");
    return address;
  }

  void convertAddressToLatLong(String address) async {
    locations = await locationFromAddress(
      address,
    );
    debugPrint(
      "lat lang from location ${locations[0]}",
    );
    convertLatLongToAddress(locations[0].latitude, locations[0].longitude);
  }
}
