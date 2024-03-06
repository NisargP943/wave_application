import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/generated/assets.dart';

class TextFieldSearchPage extends StatefulWidget {
  const TextFieldSearchPage(
      {Key? key,
      this.controller,
      this.labelText,
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
      this.padding,
      this.hintText,
      this.maxLines})
      : super(key: key);
  final TextEditingController? controller;
  final String? labelText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? visiblePassword, readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final ValueNotifier<bool>? accepted;
  final Widget? prefixWidget;
  final void Function()? onTap;
  final EdgeInsets? edgeInsets;
  final double? padding;
  final String? hintText;
  final int? maxLines;

  @override
  _TextFieldSearchPageState createState() => _TextFieldSearchPageState();
}

class _TextFieldSearchPageState extends State<TextFieldSearchPage> {
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
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 15).r,
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
                onTap: widget.onTap,
                controller: widget.controller,
                readOnly: widget.readOnly ?? false,
                focusNode: _focusNode,
                maxLines: widget.maxLines,
                style: TextStyle(color: Colors.black, fontSize: 16.spMin),
                decoration: InputDecoration(
                  prefixIcon: widget.prefixWidget,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: widget.edgeInsets ??
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                          .r,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: labelColor,
                    fontSize: 14.spMin,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 0,
                  ),
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
