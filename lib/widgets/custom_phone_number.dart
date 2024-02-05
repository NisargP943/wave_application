import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/theme/custom_text_style.dart';

// ignore: must_be_immutable
class CustomPhoneNumber extends StatelessWidget {
  CustomPhoneNumber({
    Key? key,
    required this.controller,
  }) : super(
          key: key,
        );

  ValueNotifier<Country> country = ValueNotifier(
    Country(isoCode: "IN", iso3Code: "IND", phoneCode: "91", name: "India"),
  );

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "987-654-3210",
        prefixIconConstraints: BoxConstraints(
          maxWidth: 120.w,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20).r,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(8).r,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(8).r,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(8).r,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(8).r,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(8).r,
        ),
        prefixIcon: InkWell(
          onTap: () {
            _openCountryPicker(context);
          },
          child: countryWidget(),
        ),
      ),
      cursorColor: Colors.black,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      controller: controller,
    );
  }

  Widget countryWidget() {
    return ValueListenableBuilder(
      valueListenable: country,
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.only(left: 15).r,
        child: Row(
          children: [
            CountryPickerUtils.getDefaultFlagImage(
              value,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10).r,
              child: Text(
                "+${value.phoneCode}",
                style: CustomTextStyles.bodyLargeBlack900_1,
              ),
            ),
            20.horizontalSpace,
            Container(
              height: 35.h,
              color: Colors.black,
              width: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            width: 60,
            child: Text(
              "+${country.phoneCode}",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              country.name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  void _openCountryPicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          searchInputDecoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14),
          ),
          isSearchable: true,
          title: const Text(
            'Select your phone code',
            style: TextStyle(fontSize: 14),
          ),
          onValuePicked: (value) {
            country.value = value;
            debugPrint(
                "${value.isoCode} ${value.iso3Code} ${value.phoneCode} ${value.name}");
          },
          itemBuilder: (val) => _buildDialogItem(val),
        ),
      );
}
