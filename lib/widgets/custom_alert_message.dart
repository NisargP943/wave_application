import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomErrorMessage extends StatelessWidget {
  const CustomErrorMessage(
      {super.key, required this.message, this.flushBarPosition});

  final String message;
  final FlushbarPosition? flushBarPosition;

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      messageColor: Colors.white,
      backgroundColor: const Color(0xffA41C8E),
      flushbarPosition: flushBarPosition ?? FlushbarPosition.BOTTOM,
      message: message,
    )..show(context);
  }
}
