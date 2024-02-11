import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:wave_app/generated/assets.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/theme/custom_text_style.dart';
import 'package:wave_app/widgets/custom_elevated_button.dart';
import 'package:wave_app/widgets/custom_image_view.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({super.key, this.categoryModel});

  final Datum? categoryModel;

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  int? dateTimeIndex;
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    debugPrint(widget.categoryModel?.id);
    Future.delayed(const Duration(seconds: 2), () => isLoading.value = false);
  }

  @override
  void dispose() {
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageAppBar(),
      body: pageBodyWidget(),
    );
  }

  AppBar pageAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Image.asset(
          Assets.imagesBackIcon,
          scale: 1.8,
        ),
      ),
      title: Text(
        widget.categoryModel?.catg ?? "Please wait",
        style: CustomTextStyles.titleMediumGray700,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [
        Image.asset(
          Assets.imagesShare,
          scale: 1.8,
        ),
      ],
    );
  }

  Widget pageBodyWidget() {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, child) => value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : widget.categoryModel == null
              ? Center(
                  child: Text(
                    "No Data Found",
                    style: CustomTextStyles.bodyLargeBlack90018,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomImageView(
                          imagePath: widget.categoryModel?.thumbnail,
                          height: 0.4.sh,
                          fit: BoxFit.fill,
                        ),
                      ),
                      30.verticalSpace,
                      dateTimePicker(),
                      20.verticalSpace,
                      serviceDetails(),
                      serviceLabel(),
                      5.verticalSpace,
                      ratingBarRow(),
                      30.verticalSpace,
                      serviceDescription(),
                      70.verticalSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15).r,
                        child: AppButtonWidget(
                          onTap: () {},
                          text: "ADD TO CART",
                        ),
                      ),
                      20.verticalSpace,
                    ],
                  ),
                ),
    );
  }

  Widget serviceDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Text(
        "Blood Test at Home in 60 Mins - Get Tested at Home in 60 Minsconcealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.",
        style: CustomTextStyles.titleMediumff407bff,
      ),
    );
  }

  Widget serviceLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Text(
        widget.categoryModel?.servicename ?? "",
        style: CustomTextStyles.bodySmallff9b9b9b,
      ),
    );
  }

  Widget serviceDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.categoryModel?.stype ?? "",
            style: CustomTextStyles.bodyLargeBlack90018,
          ),
          Text(
            "Rs ${widget.categoryModel?.price}",
            style: CustomTextStyles.bodyLargeBlack90018,
          ),
        ],
      ),
    );
  }

  Widget dateTimePicker() {
    return StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).r,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  dateTimeIndex = 0;
                  setState(() {});
                  buildCalenderDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8).r,
                    border: Border.all(
                      color: dateTimeIndex == 0
                          ? Colors.orangeAccent
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateController.text.isEmpty
                            ? "Date"
                            : dateController.text,
                        style: CustomTextStyles.bodyLargeBlack900,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Image.asset(
                          Assets.imagesBackIcon,
                          scale: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            15.horizontalSpace,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  dateTimeIndex = 1;
                  timeSheet();
                  setState(() {});
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14)
                          .r,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: dateTimeIndex == 1
                          ? Colors.orangeAccent
                          : Colors.grey.withOpacity(0.5),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8).r,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeController.text.isEmpty
                            ? "Time"
                            : timeController.text,
                        style: CustomTextStyles.bodyLargeBlack900,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Image.asset(
                          Assets.imagesBackIcon,
                          scale: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Padding(
              padding: const EdgeInsets.only(top: 5).r,
              child: Image.asset(
                Assets.imagesFavIcon,
                scale: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ratingBarRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Row(
        children: [
          RatingBar(
            initialRating: 5,
            allowHalfRating: true,
            itemCount: 5,
            glowColor: Colors.orangeAccent,
            itemSize: 16,
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
      ),
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      firstDate: DateTime.now(),
      weekdayLabels: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
      /* weekdayLabelTextStyle: textStyle.copyWith(
        fontSize: 13.spMin,
        color: const Color.fromRGBO(60, 60, 67, 0.80),
        fontWeight: FontWeight.w500,
      ),*/
      firstDayOfWeek: 0,
      controlsHeight: 50,
      /* customModePickerIcon: Image.asset(
        Assets.images.viewAllArrow.path,
        height: 18.r,
        width: 18.r,
        color: AppColor.teal,
      ),*/
      /*  controlsTextStyle: .copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 17.sp,
      ),
      dayTextStyle: textStyle.copyWith(
        color: AppColor.black,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
      selectedDayTextStyle: textStyle.copyWith(
        color: AppColor.white,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),
      disabledDayTextStyle: textStyle.copyWith(
        color: AppColor.grey,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
      ),*/
      selectableDayPredicate: (day) => !day
          .difference(
            DateTime.now().subtract(
              const Duration(days: 3),
            ),
          )
          .isNegative,
    );

    return CalendarDatePicker2(
      config: config,
      value: _singleDatePickerValueWithDefaultValue,
      onValueChanged: (dates) {
        dateController.text =
            DateFormat("yyyy-MM-dd").format(dates.last ?? DateTime.now());
        setState(() => _singleDatePickerValueWithDefaultValue = dates);
      },
    );
  }

  buildCalenderDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(24).r,
          topLeft: const Radius.circular(24).r,
        ),
      ),
      context: context,
      builder: (context) {
        return _buildDefaultSingleDatePickerWithValue();
      },
    );
  }

  void timeSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(24).r,
          topLeft: const Radius.circular(24).r,
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              34.verticalSpace,
              SizedBox(
                height: 0.25.sh,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    primaryColor: Colors.black,
                    applyThemeToAll: true,
                    brightness: Brightness.dark,
                    primaryContrastingColor: Colors.purple,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 18.spMin,
                        color: Colors.black,
                      ),
                      primaryColor: Colors.black,
                    ),
                  ),
                  child: CupertinoDatePicker(
                    showDayOfWeek: true,
                    onDateTimeChanged: (val) {
                      timeController.text =
                          DateFormat.jm().format(val).toLowerCase();
                      setState(() {});
                    },
                    mode: CupertinoDatePickerMode.time,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
