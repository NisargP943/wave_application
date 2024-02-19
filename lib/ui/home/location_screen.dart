import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:wave_app/main.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/main_page.dart';
import 'package:wave_app/values/string.dart';
import 'package:wave_app/widgets/custom_text_field.dart';
import 'package:http/http.dart' as http;

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.location});

  final String location;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController locationController = TextEditingController();
  String session = "122334";
  late Uuid uuid;

  List places = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).r,
              child: TextFieldDesignPage(
                onChanged: (p0) {
                  getPlacesSuggestion(p0);
                },
                edgeInsets:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 17).r,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: locationController,
                labelText: "Search Location",
                prefixWidget: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    size: 20,
                    Icons.keyboard_backspace_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ).r,
                itemCount: places.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    locationDB?.put("city", places[index]["description"]);
                    Get.off(const MainPage());
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 28,
                        color: Colors.grey,
                      ),
                      20.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            15.verticalSpace,
                            Text(
                              "${places[index]["structured_formatting"]["main_text"]}",
                              style: CustomTextStyles.bodyLargeBlack900,
                              overflow: TextOverflow.visible,
                            ),
                            8.verticalSpace,
                            Text(
                              "${places[index]["description"]}",
                              style: CustomTextStyles.bodySmallErrorContainer,
                              overflow: TextOverflow.ellipsis,
                            ),
                            15.verticalSpace,
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 2,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getPlacesSuggestion(String value) async {
    String request =
        '${Constant().placesBaseUrl}?input=$value&key=${Constant().placesApiKey}.&sessiontoken=$session';
    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        places = jsonDecode(response.body)['predictions'];
        setState(() {});
        debugPrint(response.body);
      }
    } catch (e) {
      e.toString();
    }
  }
}
