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
        Uri.parse("http://wavetechservices.in/app/get_all_amc.php"),
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

  Future bookServiceApi(
      {required String name,
      required String number,
      required String cityLat,
      required String cityLong,
      required String address,
      required String bookingDate,
      required String bookingTime,
      required String landmark,
      required String sdetails,
      required String amcDetails,
      required String couponCode}) async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://kalasampurna.com/wavetech/app/customer_book_service.php?name=$name&number=$number&citylat=$cityLat.1&citylng=$cityLong&addr=$address&bdate=$bookingDate&btime=$bookingTime&landmark=$landmark&sdetails=3883-Inverter service-1-300&amcdetails=4023-AMC-1-1499&couponcode=$couponCode"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
