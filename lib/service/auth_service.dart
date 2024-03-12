import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wave_app/values/string.dart';

class AuthApiService {
  Future checkUserApi(String mobileNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${Constant().baseUrl}cust_get_otp.php?record=$mobileNumber",
        ),
      );
      print(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future signUpNewUser({
    required String name,
    required String mobileNumber,
    required String pincode,
    street,
    city,
    required String email,
    double? lat,
    lang,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(
          "${Constant().baseUrl}register_new_customer.php?username=$name&mobile=$mobileNumber&email=$email&street=$street&city=$city&pincode=$pincode&glat=$lat&glong=$lang",
        ),
      );
      print(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
