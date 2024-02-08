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

  Future signUpNewUser(
    String name,
    String mobileNumber,
    String password,
    String email,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://wavetechservices.in/app/register_new_customer.php?username=$name&mobile=$mobileNumber&password=$password&email=$email&street=Vasna&city=Ahmedabad&pincode=380007&glat=23.0225&glong=72.5714",
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
