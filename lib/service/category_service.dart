import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future getAllCategory() async {
    try {
      final response = await http.get(Uri.parse(
          "http://kalasampurna.com/wavetech/app/get_all_maincatg.php"));
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAllCategoryByType() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://kalasampurna.com/wavetech/app/get_maincatg_types.php"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getSubCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://kalasampurna.com/wavetech/app/get_all_mainsubcatg.php?record=$category"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
