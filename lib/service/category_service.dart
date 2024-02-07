import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future getAllCategory() async {
    try {
      final response = await http.get(Uri.parse(
          "http://kalasampurna.com/wavetech/app/get_all_maincatg.php"));
      print(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
