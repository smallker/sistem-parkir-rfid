// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:web/controller/user_info_ctl.dart';
import '../model/user_model.dart';
import 'dart:convert';

class Api {
  static var baseUrl = "http://localhost:3000";
  static getUserInfo() async {
    var response = await http.get('$baseUrl/userinfo');
    if (response.statusCode == HttpStatus.ok) {
      UserModel user = UserModel.fromJson(json.decode(response.body));
      Get.find<UserInfoCtl>().updateUser(user);
    }
  }

  static createUser(String rfid, String name) async {
    var response = await http.post(
      '$baseUrl/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rfid': rfid,
        'name': name,
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      hideLoadingDialog();
      Get.snackbar('Berhasil', 'Akun berhasil dibuat');
    }
  }
}

class UserDialog {
  notFound() async {
    Get.defaultDialog(
      title: 'RFID tidak ditemukan',
      content:
          Text('RFID tidak ditemukan, apakah anda akan membuat akun baru?'),
      confirm: FlatButton.icon(
        icon: Icon(Icons.check),
        label: Text('OK'),
        onPressed: () => createuser(),
      ),
      cancel: FlatButton.icon(
        icon: Icon(Icons.cancel),
        label: Text('Batal'),
        onPressed: () => Get.back(),
      ),
    );
  }

  createuser() async {
    TextEditingController rfid = TextEditingController();
    TextEditingController name = TextEditingController();
    Get.defaultDialog(
      title: 'Buat akun',
      content: Column(
        children: [
          TextFormField(
            controller: rfid,
            decoration: InputDecoration(
              hintText: 'RFID',
            ),
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: 'Nama',
            ),
          ),
        ],
      ),
      confirm: FlatButton.icon(
        icon: Icon(Icons.check),
        label: Text('OK'),
        onPressed: () {
          showLoadingDialog();
          Api.createUser(rfid.text, name.text);
        },
      ),
      cancel: FlatButton.icon(
        icon: Icon(Icons.cancel),
        label: Text('Batal'),
        onPressed: () => Get.back(),
      ),
    );
  }
}
