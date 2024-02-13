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
  Priority? priority;
  Stype? stype;
  int? rating;
  int? price;
  String? thumbnail;
  bool? imageLoaded;

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
    this.imageLoaded,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        id: json["id"],
        servicename: json["servicename"],
        sdesc: json["sdesc"],
        srate: json["srate"],
        catg: json["catg"],
        priority: priorityValues.map[json["priority"]]!,
        stype: stypeValues.map[json["stype"]]!,
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
        "priority": priorityValues.reverse[priority],
        "stype": stypeValues.reverse[stype],
        "rating": rating,
        "price": price,
        "thumbnail": thumbnail,
      };
}

enum Priority { PRIORITY_1, PRIORITY_2 }

final priorityValues = EnumValues(
    {"Priority-1": Priority.PRIORITY_1, "Priority-2": Priority.PRIORITY_2});

enum Stype { SERVICES }

final stypeValues = EnumValues({"Services": Stype.SERVICES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
