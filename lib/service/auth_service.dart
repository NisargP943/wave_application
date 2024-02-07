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
}
