// To parse this JSON data, do
//
//     final bookServiceResponseModel = bookServiceResponseModelFromJson(jsonString);

import 'dart:convert';

BookServiceResponseModel bookServiceResponseModelFromJson(String str) =>
    BookServiceResponseModel.fromJson(json.decode(str));

String bookServiceResponseModelToJson(BookServiceResponseModel data) =>
    json.encode(data.toJson());

class BookServiceResponseModel {
  String? status;
  String? bookingid;

  BookServiceResponseModel({
    this.status,
    this.bookingid,
  });

  factory BookServiceResponseModel.fromJson(Map<String, dynamic> json) =>
      BookServiceResponseModel(
        status: json["status"],
        bookingid: json["bookingid"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "bookingid": bookingid,
      };
}
