import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_data.g.dart';

@HiveType(typeId: 0)
class CustomerData {
  @HiveField(0)
  @JsonKey(name: "id")
  int? id;
  @HiveField(1)
  @JsonKey(name: "customername")
  String? customername;
  @HiveField(2)
  @JsonKey(name: "city")
  String? city;
  @HiveField(3)
  @JsonKey(name: "mobile")
  String? mobile;
  @HiveField(4)
  @JsonKey(name: "email")
  String? email;
  @HiveField(5)
  @JsonKey(name: "curloc")
  String? curloc;
  @HiveField(6)
  @JsonKey(name: "status")
  int? status;
  @HiveField(7)
  bool? firstLogin;
  @HiveField(8)
  bool? isLogin = false;

  CustomerData(
      {this.id,
      this.customername,
      this.city,
      this.mobile,
      this.email,
      this.curloc,
      this.status,
      this.firstLogin,
      this.isLogin});
}
