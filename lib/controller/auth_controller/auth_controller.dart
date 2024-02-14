import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/service/auth_service.dart';
import 'package:wave_app/ui/home/main_page.dart';

class AuthController extends GetxController {
  var loading = false.obs;
  Rx<CustomerAuthResponseModel> customerAuthResponseModel =
      CustomerAuthResponseModel(data: [], otp: 0000).obs;
  AuthApiService authApiService = AuthApiService();
  var errorMessage = "".obs;

  Future<void> otpApi(String mobileNumber) async {
    loading.value = true;
    try {
      final authResp = await authApiService.checkUserApi(mobileNumber);
      if (authResp.statusCode == 200) {
        customerAuthResponseModel.value =
            customerAuthResponseModelFromJson(authResp.body);
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      errorMessage.value = "Connection lost";
    } catch (e) {
      debugPrint(e.toString());
      errorMessage.value = "Something is wrong";
    }
  }

  Future<void> newUserSignUp(
      {required String name,
      required String mobileNumber,
      required String email,
      pincode,
      street,
      city,
      required String password,
      double? lat,
      double? lang}) async {
    loading.value = true;
    try {
      final authResp = await authApiService.signUpNewUser(
          name: name,
          mobileNumber: mobileNumber,
          password: password,
          email: email,
          street: street,
          city: city,
          lat: lat,
          lang: lang,
          pincode: pincode);
      if (authResp.statusCode == 200) {
        loading.value = false;
        Get.off(const MainPage());
      }
    } on SocketException catch (e) {
      errorMessage.value = "Connection lost";
    } catch (e) {
      debugPrint(e.toString());
      errorMessage.value = "Something is wrong";
    }
  }
}
