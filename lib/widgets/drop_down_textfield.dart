import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/generated/assets.dart';

class DropDownTextFieldSearchPage extends StatefulWidget {
  const DropDownTextFieldSearchPage({
    Key? key,
    this.controller,
    required this.labelText,
    this.textInputType,
    this.textInputAction,
    this.visiblePassword,
    this.inputFormatters,
    this.onChanged,
    this.accepted,
    this.prefixWidget,
    this.edgeInsets,
    this.readOnly,
  }) : super(key: key);
  final SingleValueDropDownController? controller;
  final String labelText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? visiblePassword, readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(dynamic)? onChanged;
  final ValueNotifier<bool>? accepted;
  final Widget? prefixWidget;
  final EdgeInsets? edgeInsets;

  @override
  _DropDownTextFieldSearchPageState createState() =>
      _DropDownTextFieldSearchPageState();
}

class _DropDownTextFieldSearchPageState
    extends State<DropDownTextFieldSearchPage> {
  // Use it to change color for border when textFiled in focus
  final FocusNode _focusNode = FocusNode();

  // Color for border
  Color _borderColor = Colors.transparent;

  Color labelColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Change color for border if focus was changed
    _focusNode.addListener(() {
      setState(() {
        labelColor = _focusNode.hasFocus ? Colors.grey : Colors.black;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).r,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
              )
            ],
            borderRadius: BorderRadius.circular(5).r,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5).r,
            child: ValueListenableBuilder(
              valueListenable: widget.accepted ?? ValueNotifier(true),
              builder: (context, value, child) => DropDownTextField(
                controller: widget.controller,
                readOnly: widget.readOnly ?? false,
                textFieldDecoration: InputDecoration(
                  prefixIcon: widget.prefixWidget,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.labelText,
                  contentPadding: widget.edgeInsets ??
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                          .r,
                  border: InputBorder.none,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 0,
                  ),
                  suffixIcon: const SizedBox.shrink(),
                ),
                onChanged: widget.onChanged,
                searchShowCursor: false,
                dropDownList: const [
                  DropDownValueModel(name: "Astrologer", value: "Astrologer"),
                  DropDownValueModel(name: "Caterers", value: "Caterers"),
                  DropDownValueModel(
                      name: "Bike Service", value: "Bike Service"),
                  DropDownValueModel(name: "CAR Serivce", value: "CAR Service"),
                  DropDownValueModel(
                      name: "Consultants - Advisory Service",
                      value: "Consultants - Advisory Service"),
                  DropDownValueModel(name: "Contractors", value: "Contractors"),
                  DropDownValueModel(
                      name: "Electrical Service", value: "Electrical Service"),
                  DropDownValueModel(
                      name: "Electronics Service",
                      value: "Electronics Service"),
                  DropDownValueModel(
                      name: "Event Organizer", value: "Event Organizer"),
                  DropDownValueModel(name: "GYM-FITNESS", value: "GYM-FITNESS"),
                  DropDownValueModel(name: "Freelancer", value: "Freelancer"),
                  DropDownValueModel(name: "Homes Needs", value: "Homes Needs"),
                  DropDownValueModel(
                      name: "Jewellery Showrooms",
                      value: "Jewellery Showrooms"),
                  DropDownValueModel(
                      name: "NGO-Old Age Homes-Care Centers",
                      value: "NGO-Old Age Homes-Care Centers"),
                  DropDownValueModel(
                      name: "Pest Control Services",
                      value: "Pest Control Services"),
                  DropDownValueModel(
                      name: "Part Time Job-Wave", value: "Part Time Job-Wave"),
                  DropDownValueModel(name: "Pet Shops", value: "Pet Shops"),
                  DropDownValueModel(
                      name: "Real Estate Agents", value: "Real Estate Agents"),
                  DropDownValueModel(name: "Rent Hire", value: "Rent Hire"),
                  DropDownValueModel(name: "Spa-Saloon", value: "Spa-Saloon"),
                  DropDownValueModel(
                      name: "TRAINING AND CERTIFICATION",
                      value: "TRAINING AND CERTIFICATION"),
                  DropDownValueModel(
                      name: "Transports Service", value: "Transports Service"),
                  DropDownValueModel(
                      name: "Travel And Tourism", value: "Travel and Tourism"),
                  DropDownValueModel(
                      name: "Wedding Planners", value: "Wedding Planners"),
                  DropDownValueModel(
                      name: "YOGA-MEDITATION", value: "YOGA-MEDITATION"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
