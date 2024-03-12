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
            "${Constant().baseUrl}customer_book_service.php?name=$name&number=$number&citylat=$cityLat&citylng=$cityLong&addr=$address&bdate=$bookingDate&btime=$bookingTime&landmark=$landmark&sdetails=$sdetails&amcdetails=$amcDetails&couponcode=$couponCode"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getBookedServiceApi(String phoneNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Constant().baseUrl}customer_get_bookings.php?mobile=$phoneNumber"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getCompleteBookedServiceApi(
    String status,
    String sid,
    String custid,
    String rating,
    String phoneNumber,
    String commentes,
    String feedback,
    String amc,
    String amountpaid,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Constant().baseUrl}customer_complete_booking.php?status=$status&sid=$sid&custid=$custid&rating=$rating&mobile=$phoneNumber&comments=$commentes&feedback=$feedback&amc=$amc&amountpaid=$amountpaid"),
      );
      debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
