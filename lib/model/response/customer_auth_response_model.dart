// To parse this JSON data, do
//
//     final customerAuthResponseModel = customerAuthResponseModelFromJson(jsonString);

import 'dart:convert';

CustomerAuthResponseModel customerAuthResponseModelFromJson(String str) =>
    CustomerAuthResponseModel.fromJson(json.decode(str));

String customerAuthResponseModelToJson(CustomerAuthResponseModel data) =>
    json.encode(data.toJson());

class CustomerAuthResponseModel {
  List? data;
  int? otp;

  CustomerAuthResponseModel({
    this.data,
    this.otp,
  });

  factory CustomerAuthResponseModel.fromJson(Map<String, dynamic> json) =>
      CustomerAuthResponseModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == [null]
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "otp": otp,
      };
}

class Datum {
  String? id;
  String? customername;
  String? city;
  String? mobile;
  dynamic email;
  String? curloc;
  int? status;

  Datum({
    this.id,
    this.customername,
    this.city,
    this.mobile,
    this.email,
    this.curloc,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        customername: json["customername"],
        city: json["city"],
        mobile: json["mobile"],
        email: json["email"],
        curloc: json["curloc"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customername": customername,
        "city": city,
        "mobile": mobile,
        "email": email,
        "curloc": curloc,
        "status": status,
      };
}
