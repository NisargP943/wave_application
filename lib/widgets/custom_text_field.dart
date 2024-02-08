import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/generated/assets.dart';

class TextFieldDesignPage extends StatefulWidget {
  const TextFieldDesignPage(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.textInputType,
      this.textInputAction,
      this.visiblePassword,
      this.inputFormatters,
      this.onChanged,
      required this.accepted,
      this.prefixWidget})
      : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? visiblePassword;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final ValueNotifier<bool> accepted;
  final Widget? prefixWidget;

  @override
  _TextFieldDesignPageState createState() => _TextFieldDesignPageState();
}

class _TextFieldDesignPageState extends State<TextFieldDesignPage> {
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
              valueListenable: widget.accepted,
              builder: (context, value, child) => TextField(
                onChanged: widget.onChanged,
                controller: widget.controller,
                obscureText: widget.visiblePassword ?? false,
                focusNode: _focusNode,
                style: TextStyle(color: Colors.black, fontSize: 16.spMin),
                keyboardType: widget.textInputType,
                textInputAction: widget.textInputAction,
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(
                  prefixIcon: widget.prefixWidget,
                  suffixIcon: widget.controller.text.isNotEmpty
                      ? Image.asset(
                          value ? Assets.imagesAccepted : Assets.imagesReject,
                          scale: 1.6,
                        )
                      : const SizedBox.shrink(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                          .r,
                  border: InputBorder.none,
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
                cursorColor: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
