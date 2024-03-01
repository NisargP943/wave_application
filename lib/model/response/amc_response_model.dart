// To parse this JSON data, do
//
//     final amcResponseModel = amcResponseModelFromJson(jsonString);

import 'dart:convert';

AmcResponseModel amcResponseModelFromJson(String str) =>
    AmcResponseModel.fromJson(json.decode(str));

String amcResponseModelToJson(AmcResponseModel data) =>
    json.encode(data.toJson());

class AmcResponseModel {
  List<ServiceModel>? data;
  int? success;

  AmcResponseModel({
    this.data,
    this.success,
  });

  factory AmcResponseModel.fromJson(Map<String, dynamic> json) =>
      AmcResponseModel(
        data: json["data"] == null
            ? []
            : List<ServiceModel>.from(
                json["data"]!.map((x) => ServiceModel.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
      };
}

class ServiceModel {
  String? id;
  String? servicename;
  String? sdesc;
  int? srate;
  String? catg;
  String? priority;
  String? stype;
  int? rating;
  int? price;
  String? thumbnail;

  ServiceModel({
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
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
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
