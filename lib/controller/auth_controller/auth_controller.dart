import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/service/auth_service.dart';

class AuthController extends GetxController {
  AuthApiService authApiService = AuthApiService();

  Future<void> otpApi(String mobileNumber) async {
    try {
      final authResp = await authApiService.checkUserApi(mobileNumber);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();

    //ever(, (callback) => debugPrint(""));
  }
}
