import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/model/response/customer_auth_response_model.dart';
import 'package:wave_app/service/auth_service.dart';
import 'package:wave_app/ui/auth/sign_up_page.dart';
import 'package:wave_app/ui/home/main_page.dart';

class AuthController extends GetxController {
  var loading = false.obs;
  Rx<CustomerAuthResponseModel> customerAuthResponseModel =
      CustomerAuthResponseModel(data: [], otp: 0000).obs;
  AuthApiService authApiService = AuthApiService();

  Future<void> otpApi(String mobileNumber) async {
    loading.value = true;
    try {
      final authResp = await authApiService.checkUserApi(mobileNumber);
      if (authResp.statusCode == 200) {
        customerAuthResponseModel.value =
            customerAuthResponseModelFromJson(authResp.body);
        loading.value = false;
      }
    } catch (e) {
      debugPrint(e.toString());
      loading.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(customerAuthResponseModel, (callback) {
      if (callback.data == null) {
        Get.to(const SignUpPageScreen());
      } else {
        Get.off(const MainPage());
      }
    });
  }
}
