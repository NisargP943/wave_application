import 'package:wave_app/model/response/all_category_response_model.dart';
import 'package:wave_app/model/response/all_consultants_response_model.dart';
import 'package:wave_app/model/response/amc_response_model.dart';
import 'package:wave_app/model/response/sub_category_response_model.dart';

List<ServicesModel> myCartList = [];
List<Consultant> myConsultantModel = [];
List<ServiceModel> myAMCList = [];
List<CategoryModel> myCategory = [];

class ServicePaymentModel {
  String name;
  String bid;
  String amts;
  String addr;
  String pincode;
  String mobile;
  String bservice;

  ServicePaymentModel(
      {required this.name,
      required this.bid,
      required this.amts,
      required this.addr,
      required this.pincode,
      required this.mobile,
      required this.bservice});
}
