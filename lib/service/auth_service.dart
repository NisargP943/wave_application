import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  Future checkUserApi(String mobileNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://wavetechservices.in/app/cust_get_otp.php?record=$mobileNumber",
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
    required String password,
    required String pincode,
    street,
    city,
    required String email,
    double? lat,
    lang,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://wavetechservices.in/app/register_new_customer.php?username=$name&mobile=$mobileNumber&password=$password&email=$email&street=$street&city=$city&pincode=$pincode&glat=$lat&glong=$lang",
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
