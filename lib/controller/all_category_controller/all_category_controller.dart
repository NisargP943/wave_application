import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/model/response/all_consultants_response_model.dart';
import 'package:wave_app/service/category_service.dart';
import 'package:wave_app/ui/home/home_page.dart';

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
  var loading = false.obs;
  CategoryService categoryService = CategoryService();

  Future<void> getAllCategory() async {
    loading.value = true;
    try {
      final authResp = await categoryService.getAllServices();
      if (authResp.statusCode == 200) {
        allServicesResponse.value?.data = allCategoryResponseModelFromJson(
          authResp.body,
        ).data;
        if (allServicesResponse.value?.data != null) {
          serviceListNotifier.value = allServicesResponse.value!.data!;
        }
        loading.value = false;
        update();
        debugPrint("Response :::: ${allServicesResponse.value?.data}");
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      loading.value = true;
      update();
    }
  }

  Future<void> getAllConsultants() async {
    loading.value = true;
    try {
      final authResp = await categoryService.getAllConsultants();
      if (authResp.statusCode == 200) {
        allConsultantResponse.value?.data = allConsultantsResponseModelFromJson(
          authResp.body,
        ).data;

        loading.value = false;
        update();
        debugPrint("Response :::: $authResp");
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      loading.value = true;
      update();
    }
  }

  Future<void> getAmcProducts() async {
    loading.value = true;
    try {
      final authResp = await categoryService.getAmcProducts();
      if (authResp.statusCode == 200) {
        allAmcProducts.value?.data = allCategoryResponseModelFromJson(
          authResp.body,
        ).data;

        loading.value = false;
        update();
        debugPrint("Response :::: $authResp");
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      loading.value = true;
      update();
    }
  }

  Future<void> getSubCategory(String category) async {
    loading.value = true;
    try {
      final authResp = await categoryService.getSubCategory(category);
      if (authResp.statusCode == 200) {
        subCategoryResponseModel.value?.data = subCategoryResponseModelFromJson(
          authResp.body,
        ).data;
        loading.value = false;
        update();
        debugPrint("Response :::: $authResp");
      }
    } catch (e) {
      debugPrint("error ${e.toString()}");
      loading.value = true;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategory();
    getAllConsultants();
    getAmcProducts();
  }
}
