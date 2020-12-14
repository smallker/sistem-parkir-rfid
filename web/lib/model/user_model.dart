// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

class UserModel {
  UserModel({
    this.rfid,
    this.name,
    this.balance,
    this.lastLogin,
  });

  String rfid;
  String name;
  int balance;
  int lastLogin;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        rfid: json["rfid"],
        name: json["name"],
        balance: json["balance"],
        lastLogin: json["last_login"],
      );

  Map<String, dynamic> toMap() => {
        "rfid": rfid,
        "name": name,
        "balance": balance,
        "last_login": lastLogin,
      };
}
