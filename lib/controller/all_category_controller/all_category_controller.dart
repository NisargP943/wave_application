import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/service/category_service.dart';

class AllCatController extends GetxController {
  Rx<AllCategoryResponseModel?> allCategoryResponseModel =
      AllCategoryResponseModel(
    data: [],
    success: 0,
  ).obs;
  var loading = false.obs;
  RxList<Datum>? firstPriorityList;
  CategoryService categoryService = CategoryService();

  Future<void> getAllCategory() async {
    loading.value = true;
    try {
      final authResp = await categoryService.getAllCategory();
      if (authResp.statusCode == 200) {
        allCategoryResponseModel.value?.data = allCategoryResponseModelFromJson(
          authResp.body,
        ).data;
        firstPriorityList = allCategoryResponseModel.value?.data
            .where((element) => element.priority.name == "Priority-1")
            .toList()
            .obs;
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
