// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

class UserModel {
  UserModel({
    this.rfid,
    this.name,
    this.balance,
    this.lastEntry,
  });

  String rfid;
  String name;
  int balance;
  int lastEntry;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        rfid: json["rfid"],
        name: json["name"],
        balance: json["balance"] == null ? 0 : json["balance"],
        lastEntry: json["last_entry"] == null ? 0 : json["last_entry"],
      );

  Map<String, dynamic> toMap() => {
        "rfid": rfid,
        "name": name,
        "balance": balance,
        "last_entry": lastEntry,
      };
}
