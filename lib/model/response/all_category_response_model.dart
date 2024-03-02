// To parse this JSON data, do
//
//     final allCategoryResponseModel = allCategoryResponseModelFromJson(jsonString);

import 'dart:convert';

AllCategoryResponseModel allCategoryResponseModelFromJson(String str) =>
    AllCategoryResponseModel.fromJson(json.decode(str));

String allCategoryResponseModelToJson(AllCategoryResponseModel data) =>
    json.encode(data.toJson());

class AllCategoryResponseModel {
  List<ServicesModel>? data;
  int? success;

  AllCategoryResponseModel({
    this.data,
    this.success,
  });

  factory AllCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      AllCategoryResponseModel(
        data: json["data"] == null
            ? []
            : List<ServicesModel>.from(
                json["data"]!.map((x) => ServicesModel.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
      };
}

class ServicesModel {
  String? id;
  String? servicename;
  String? sdesc;
  String? srate;
  String? catg;
  String? priority;
  String? stype;
  int? rating;
  int? price;
  String? thumbnail;
  int? count;

  ServicesModel({
    this.id,
    this.servicename,
    this.sdesc,
    this.srate,
    this.catg,
    this.priority,
    this.stype,
    this.rating,
    this.price,
    this.thumbnail,
    this.count = 1,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        id: json["id"],
        servicename: json["servicename"],
        sdesc: json["sdesc"],
        srate: json["srate"],
        catg: json["catg"],
        priority: json["priority"],
        stype: json["stype"],
        rating: json["rating"],
        price: json["price"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "servicename": servicename,
        "sdesc": sdesc,
        "srate": srate,
        "catg": catg,
        "priority": priority,
        "stype": stype,
        "rating": rating,
        "price": price,
        "thumbnail": thumbnail,
      };
}
