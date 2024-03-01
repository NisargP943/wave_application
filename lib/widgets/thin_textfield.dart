import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/generated/assets.dart';

class ThinTextField extends StatefulWidget {
  const ThinTextField(
      {Key? key,
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
      this.onTap,
      this.suffixWidget})
      : super(key: key);
  final TextEditingController? controller;
  final String labelText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? visiblePassword, readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final ValueNotifier<bool>? accepted;
  final Widget? prefixWidget, suffixWidget;
  final void Function()? onTap;
  final EdgeInsets? edgeInsets;

  @override
  _ThinTextFieldState createState() => _ThinTextFieldState();
}

class _ThinTextFieldState extends State<ThinTextField> {
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
              builder: (context, value, child) => TextField(
                onChanged: widget.onChanged,
                controller: widget.controller,
                onTap: widget.onTap,
                obscureText: widget.visiblePassword ?? false,
                focusNode: _focusNode,
                readOnly: widget.readOnly ?? true,
                style: TextStyle(color: Colors.black, fontSize: 16.spMin),
                keyboardType: widget.textInputType,
                textInputAction: widget.textInputAction,
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(
                  prefixIcon: widget.prefixWidget,
                  suffixIcon: Image.asset(
                    Assets.assetsTextfieldIcon,
                    height: 40,
                    width: 40,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: widget.edgeInsets ??
                      const EdgeInsets.only(top: 15, bottom: 0, left: 15).r,
                  border: InputBorder.none,
                  // labelText: widget.labelText,
                  hintText: widget.labelText,
                ),
                cursorColor: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
