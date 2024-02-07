import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  Future checkUserApi(String mobileNumber) async {
    try {
      final response = await http.get(Uri.parse(""));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
