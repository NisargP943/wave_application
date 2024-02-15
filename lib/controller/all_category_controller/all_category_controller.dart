import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/model/response/all_consultants_response_model.dart';
import 'package:wave_app/service/category_service.dart';
import 'package:wave_app/ui/home/home_page.dart';
import 'package:wave_app/ui/home/sub_category_page.dart';

import '../../model/response/all_category_response_model.dart';
import '../../model/response/sub_category_response_model.dart';

class AllCatController extends GetxController {
  Rx<AllCategoryResponseModel?> allServicesResponse = AllCategoryResponseModel(
    data: [],
    success: 0,
  ).obs;
  Rx<AllCategoryResponseModel?> allAmcProducts = AllCategoryResponseModel(
    data: [],
    success: 0,
  ).obs;
  Rx<AllConsultantsResponseModel?> allConsultantResponse =
      AllConsultantsResponseModel(
    data: [],
    success: 0,
  ).obs;
  Rx<SubCategoryResponseModel?> subCategoryResponseModel =
      SubCategoryResponseModel(
    data: [],
  ).obs;
  var loading = true.obs;
  var errorMessage = "".obs;
  CategoryService categoryService = CategoryService();

  Future<void> getAllCategory() async {
    try {
      final authResp = await categoryService.getAllServices();
      if (authResp.statusCode == 200) {
        allServicesResponse.value?.data = allCategoryResponseModelFromJson(
          authResp.body,
        ).data;
        serviceListNotifier.value = allServicesResponse.value!.data!;
        loading.value = false;
        update();
        debugPrint("Response :::: ${allServicesResponse.value?.data}");
      }
    } on SocketException catch (e) {
      errorMessage.value = "Connection lost";
      loading.value = false;
    } catch (e) {
      debugPrint("error ${e.toString()}");
      errorMessage.value = "Something is wrong";
      loading.value = false;
    }
  }

  Future<void> getAllConsultants() async {
    try {
      final authResp = await categoryService.getAllConsultants();
      if (authResp.statusCode == 200) {
        allConsultantResponse.value?.data = allConsultantsResponseModelFromJson(
          authResp.body,
        ).data;
        consultantListNotifier.value = allConsultantResponse.value!.data;
        loading.value = false;
        update();
        debugPrint("Response :::: $authResp");
      }
    } on SocketException catch (e) {
      errorMessage.value = "Connection lost";
      loading.value = false;
    } catch (e) {
      loading.value = false;
      debugPrint("error ${e.toString()}");
      errorMessage.value = "Something is wrong";
    }
  }

  Future<void> getAmcProducts() async {
    try {
      final authResp = await categoryService.getAmcProducts();
      if (authResp.statusCode == 200) {
        allAmcProducts.value?.data = allCategoryResponseModelFromJson(
          authResp.body,
        ).data;
        amcListNotifier.value = allAmcProducts.value!.data!;
        loading.value = false;
        update();
        debugPrint("Response :::: $authResp");
      }
    } on SocketException catch (e) {
      errorMessage.value = e.message;
      loading.value = false;
    } catch (e) {
      debugPrint("error ${e.toString()}");
      errorMessage.value = "Something is wrong";
      loading.value = false;
    }
  }

  Future<void> getSubCategory(String category) async {
    var loading = true.obs;
    try {
      final authResp = await categoryService.getSubCategory(category);
      if (authResp.statusCode == 200) {
        subCategoryResponseModel.value?.data = subCategoryResponseModelFromJson(
          authResp.body,
        ).data;
        subCategoryNotifier.value = subCategoryResponseModel.value!.data!;
        loading.value = false;
        update();
        debugPrint("Response :::: $authResp");
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      errorMessage.value = "Something is wrong";
      loading.value = false;
    }
  }
}
