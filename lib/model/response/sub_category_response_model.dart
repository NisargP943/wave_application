// To parse this JSON data, do
//
//     final subCategoryResponseModel = subCategoryResponseModelFromJson(jsonString);

import 'dart:convert';

SubCategoryResponseModel subCategoryResponseModelFromJson(String str) =>
    SubCategoryResponseModel.fromJson(json.decode(str));

String subCategoryResponseModelToJson(SubCategoryResponseModel data) =>
    json.encode(data.toJson());

class SubCategoryResponseModel {
  List<CategoryModel>? data;

  SubCategoryResponseModel({
    this.data,
  });

  factory SubCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryResponseModel(
        data: json["data"] == null
            ? []
            : List<CategoryModel>.from(
                json["data"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryModel {
  String? id;
  String? name;
  String? subcatg;
  String? price;
  String? thumbnail;

  CategoryModel({
    this.id,
    this.name,
    this.subcatg,
    this.price,
    this.thumbnail,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        subcatg: json["subcatg"],
        price: json["price"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subcatg": subcatg,
        "price": price,
        "thumbnail": thumbnail,
      };
}

enum Subcatg { SERVICES }

final subcatgValues = EnumValues({"Services": Subcatg.SERVICES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
