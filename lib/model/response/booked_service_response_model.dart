// To parse this JSON data, do
//
//     final bookedServiceResponseModel = bookedServiceResponseModelFromJson(jsonString);

import 'dart:convert';

BookedServiceResponseModel bookedServiceResponseModelFromJson(String str) =>
    BookedServiceResponseModel.fromJson(json.decode(str));

String bookedServiceResponseModelToJson(BookedServiceResponseModel data) =>
    json.encode(data.toJson());

class BookedServiceResponseModel {
  List<BookedServiceModel>? data;

  BookedServiceResponseModel({
    this.data,
  });

  factory BookedServiceResponseModel.fromJson(Map<String, dynamic> json) =>
      BookedServiceResponseModel(
        data: json["data"] == null
            ? []
            : List<BookedServiceModel>.from(
                json["data"]!.map((x) => BookedServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BookedServiceModel {
  String? id;
  String? name;
  String? servicename;
  String? status;
  String? location;
  String? glat;
  String? glong;
  String? vendordetails;
  String? bookdate;
  String? booktime;
  String? price;
  String? quantity;
  String? feedback;
  String? rating;
  String? comments;
  String? amcneeded;
  String? thumbnail;

  BookedServiceModel({
    this.id,
    this.name,
    this.servicename,
    this.status,
    this.location,
    this.glat,
    this.glong,
    this.vendordetails,
    this.bookdate,
    this.booktime,
    this.price,
    this.quantity,
    this.feedback,
    this.rating,
    this.comments,
    this.amcneeded,
    this.thumbnail,
  });

  factory BookedServiceModel.fromJson(Map<String, dynamic> json) =>
      BookedServiceModel(
        id: json["id"],
        name: json["name"],
        servicename: json["servicename"],
        status: json["status"],
        location: json["location"],
        glat: json["glat"],
        glong: json["glong"],
        vendordetails: json["vendordetails"],
        bookdate: json["bookdate"],
        booktime: json["booktime"],
        price: json["price"],
        quantity: json["quantity"],
        feedback: json["feedback"],
        rating: json["rating"],
        comments: json["comments"],
        amcneeded: json["amcneeded"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "servicename": servicename,
        "status": status,
        "location": location,
        "glat": glat,
        "glong": glong,
        "vendordetails": vendordetails,
        "bookdate": bookdate,
        "booktime": booktime,
        "price": price,
        "quantity": quantity,
        "feedback": feedback,
        "rating": rating,
        "comments": comments,
        "amcneeded": amcneeded,
        "thumbnail": thumbnail,
      };
}
