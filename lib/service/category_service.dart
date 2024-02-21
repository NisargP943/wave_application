import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wave_app/values/string.dart';

class CategoryService {
  Future getAllServices() async {
    try {
      final response = await http
          .get(Uri.parse("${Constant().baseUrl}get_all_mainservices.php"));
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAllConsultants() async {
    try {
      final response = await http.get(
        Uri.parse("${Constant().baseUrl}get_all_mainconsultants.php"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAmcProducts() async {
    try {
      final response = await http.get(
        Uri.parse("${Constant().baseUrl}get_all_amc.php"),
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

  Future searchServiceApi(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Constant().baseUrl}get_all_searchservices.php?record=$category"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
