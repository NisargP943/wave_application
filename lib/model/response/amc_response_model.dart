// To parse this JSON data, do
//
//     final allCategoryResponseModel = allCategoryResponseModelFromJson(jsonString);

import 'dart:convert';

AmcResponseModel amcResponseModelFromJson(String str) =>
    AmcResponseModel.fromJson(json.decode(str));

String allCategoryResponseModelToJson(AmcResponseModel data) =>
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
  Priority? priority;
  Stype? stype;
  int? rating;
  int? price;
  String? thumbnail;
  bool? imageLoaded;

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
    this.imageLoaded,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
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
