// To parse this JSON data, do
//
//     final allConsultantsResponseModel = allConsultantsResponseModelFromJson(jsonString);

import 'dart:convert';

AllConsultantsResponseModel allConsultantsResponseModelFromJson(String str) =>
    AllConsultantsResponseModel.fromJson(json.decode(str));

String allConsultantsResponseModelToJson(AllConsultantsResponseModel data) =>
    json.encode(data.toJson());

class AllConsultantsResponseModel {
  List<Consultant> data;
  int success;

  AllConsultantsResponseModel({
    required this.data,
    required this.success,
  });

  factory AllConsultantsResponseModel.fromJson(Map<String, dynamic> json) =>
      AllConsultantsResponseModel(
        data: List<Consultant>.from(
            json["data"].map((x) => Consultant.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
      };
}

class Consultant {
  String id;
  String servicename;
  String sdesc;
  String srate;
  String catg;
  Priority priority;
  Stype stype;
  int rating;
  int price;
  String thumbnail;

  Consultant({
    required this.id,
    required this.servicename,
    required this.sdesc,
    required this.srate,
    required this.catg,
    required this.priority,
    required this.stype,
    required this.rating,
    required this.price,
    required this.thumbnail,
  });

  factory Consultant.fromJson(Map<String, dynamic> json) => Consultant(
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

enum Catg { CONSULTANTS_ADVISORY_SERVICE, CONTRACTORS }

final catgValues = EnumValues({
  "Consultants - Advisory Service": Catg.CONSULTANTS_ADVISORY_SERVICE,
  "Contractors": Catg.CONTRACTORS
});

enum Priority { PRIORITY_2 }

final priorityValues = EnumValues({"Priority-2": Priority.PRIORITY_2});

enum Stype { CONSULTANTS }

final stypeValues = EnumValues({"Consultants": Stype.CONSULTANTS});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
