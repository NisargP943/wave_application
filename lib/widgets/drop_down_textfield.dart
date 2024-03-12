import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dp_textfield.dart';

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
    this.suffixCallBack,
    required this.dropDownList,
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
  final VoidCallback? suffixCallBack;
  final EdgeInsets? edgeInsets;
  final List<DropDownValueModel> dropDownList;

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
                suffixCallback: widget.suffixCallBack,
                textFieldDecoration: InputDecoration(
                  prefixIcon: widget.prefixWidget,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.labelText,
                  contentPadding: widget.edgeInsets ??
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                          .r,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5).r,
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5).r,
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5).r,
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5).r,
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 0,
                  ),
                ),
                onChanged: widget.onChanged,
                searchShowCursor: false,
                dropDownList: widget.dropDownList,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
