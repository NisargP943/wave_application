import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/model/response/sub_category_response_model.dart';
import 'package:wave_app/service/category_service.dart';

class AllCatController extends GetxController {
  Rx<AllCategoryResponseModel?> allCategoryResponseModel =
      AllCategoryResponseModel(
    data: [],
    success: 0,
  ).obs;
  Rx<AllCategoryResponseModel?> allServicesResponse = AllCategoryResponseModel(
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
      final authResp = await categoryService.getAllCategory();
      if (authResp.statusCode == 200) {
        allCategoryResponseModel.value?.data = allCategoryResponseModelFromJson(
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

  Future<void> getAllCategoryByTypes() async {
    loading.value = true;
    try {
      final authResp = await categoryService.getAllCategoryByType();
      if (authResp.statusCode == 200) {
        allServicesResponse.value?.data = allCategoryResponseModelFromJson(
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
    getAllCategoryByTypes();

    ///success workers
    ever(allCategoryResponseModel, (callback) {
      if (callback?.data != null) {
        print("ever called");
        loading.value = false;
      } else {
        loading.value = true;
      }
    });
  }
}
