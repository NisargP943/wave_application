// To parse this JSON data, do
//
//     final allCategoryResponseModel = allCategoryResponseModelFromJson(jsonString);

import 'dart:convert';

AllCategoryResponseModel allCategoryResponseModelFromJson(String str) =>
    AllCategoryResponseModel.fromJson(json.decode(str));

String allCategoryResponseModelToJson(AllCategoryResponseModel data) =>
    json.encode(data.toJson());

class AllCategoryResponseModel {
  List<Datum> data;
  int success;

  AllCategoryResponseModel({
    required this.data,
    required this.success,
  });

  factory AllCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      AllCategoryResponseModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
      };
}

class Datum {
  String id;
  String? servicename;
  String catg;
  Priority priority;
  String thumbnail;
  bool? isFavourite;
  String? stype;
  int rating;
  int price;

  Datum(
      {required this.id,
      this.servicename,
      required this.catg,
      required this.priority,
      required this.thumbnail,
      this.isFavourite,
      this.stype,
      required this.rating,
      required this.price});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        servicename: json['servicename'],
        catg: json["catg"],
        priority: priorityValues.map[json["priority"]]!,
        thumbnail: json["thumbnail"],
        stype: json["stype"],
        rating: json["rating"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "servicename": servicename,
        "catg": catg,
        "priority": priorityValues.reverse[priority],
        "thumbnail": thumbnail,
        "stype": stype,
        "rating": rating,
        "price": price,
      };
}

enum Priority { PRIORITY_1, PRIORITY_2 }

final priorityValues = EnumValues(
    {"Priority-1": Priority.PRIORITY_1, "Priority-2": Priority.PRIORITY_2});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
