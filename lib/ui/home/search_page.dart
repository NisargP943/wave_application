import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave_app/controller/all_category_controller/all_category_controller.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/ui/home/service_details_page.dart';
import 'package:wave_app/widgets/custom_image_view.dart';
import 'package:wave_app/widgets/search_textfield_widget.dart';

ValueNotifier<List<ServicesModel>> searchServiceNotifier = ValueNotifier([]);

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchController;
  var catController = Get.put(AllCatController());

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    catController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //    appBar: AppBar(),
        body: Column(
          children: [
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).r,
              child: TextFieldSearchPage(
                onChanged: (p0) {
                  catController.searchService(p0);
                },
                edgeInsets:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 17).r,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: searchController,
                labelText: "Search Services",
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
            10.verticalSpace,
            Divider(
              thickness: 1,
              color: Colors.grey.withOpacity(0.1),
            ),
            GetBuilder<AllCatController>(
              builder: (controller) {
                return controller.loading.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ValueListenableBuilder(
                        valueListenable: searchServiceNotifier,
                        builder: (context, value, child) => Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15)
                                .r,
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              final item = value[index];

                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    ServiceDetailsPage(
                                      categoryModel: item,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ).r,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10).r,
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ).r,
                                        child: CustomImageView(
                                          height: 90.r,
                                          width: 90.r,
                                          imagePath: item.thumbnail,
                                        ),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.servicename ?? "",
                                            style: CustomTextStyles
                                                .bodyMediumGray50013,
                                            overflow: TextOverflow.visible,
                                          ),
                                          5.verticalSpace,
                                          Row(
                                            children: [
                                              ratingBarRow(1),
                                              7.horizontalSpace,
                                              Text(
                                                "₹${item.price}",
                                                style: CustomTextStyles
                                                    .bodySmallErrorContainer,
                                                overflow: TextOverflow.visible,
                                              ),
                                              7.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  item.sdesc ?? "",
                                                  style: CustomTextStyles
                                                      .bodySmallErrorContainer,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return 30.verticalSpace;
                            },
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
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
}
