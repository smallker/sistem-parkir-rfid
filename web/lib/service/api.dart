// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:web/controller/user_info_ctl.dart';
import 'package:web/ui/web/user_info_page.dart';
import '../model/user_model.dart';
import 'dart:convert';

class Api {
  static var baseUrl = "http://localhost:3000";
  static getUserInfo(String rfid) async {
    showLoadingDialog();
    final ctl = Get.put(UserInfoCtl());
    var response = await http.get('$baseUrl/userinfo?rfid=$rfid');
    if (response.statusCode == HttpStatus.ok) {
      UserModel user = UserModel.fromJson(response.body);
      ctl.updateUser(user);
      Get.to(UserInfoPage());
      hideLoadingDialog();
    } else
      UserDialog.notFound();
  }

  static addBalance({int balance}) async {
    final ctl = Get.put(UserInfoCtl());
    var response = await http.post(
      '$baseUrl/recharge',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'rfid': ctl.user.rfid,
        'balance': balance,
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      hideLoadingDialog();
      Get.back();
      Api.getUserInfo(ctl.user.rfid);
      Get.snackbar(
        'Berhasil',
        'Saldo sudah ditambahkan ke akun',
        colorText: Colors.white,
        backgroundColor: Colors.blue,
      );
    }
  }

  static createUser({String rfid, String name}) async {
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
      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat',
        colorText: Colors.white,
        backgroundColor: Colors.blue,
      );
    } else {
      hideLoadingDialog();
      Get.snackbar(
        'Gagal',
        'RFID telah terpakai',
        colorText: Colors.white,
        backgroundColor: Colors.blue,
      );
    }
  }
}

class UserDialog {
  static notFound() async {
    hideLoadingDialog();
    Get.defaultDialog(
      title: 'RFID tidak ditemukan',
      content:
          Text('RFID tidak ditemukan, apakah anda akan membuat akun baru?'),
      confirm: FlatButton.icon(
        icon: Icon(Icons.check),
        label: Text('OK'),
        onPressed: () {
          Get.back();
          createuser();
        },
      ),
      cancel: FlatButton.icon(
        icon: Icon(Icons.cancel),
        label: Text('Batal'),
        onPressed: () => Get.back(),
      ),
    );
  }

  static createuser() async {
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
          Api.createUser(rfid: rfid.text, name: name.text);
          Get.back();
        },
      ),
      cancel: FlatButton.icon(
        icon: Icon(Icons.cancel),
        label: Text('Batal'),
        onPressed: () => Get.back(),
      ),
    );
  }

  static addBalance() async {
    TextEditingController balance = TextEditingController();
    Get.defaultDialog(
      title: 'Buat akun',
      content: Column(
        children: [
          TextFormField(
            controller: balance,
            decoration: InputDecoration(
              hintText: 'Jumlah saldo',
            ),
          ),
        ],
      ),
      confirm: FlatButton.icon(
        icon: Icon(Icons.check),
        label: Text('OK'),
        onPressed: () {
          showLoadingDialog();
          Api.addBalance(balance: int.tryParse(balance.text));
          Get.back();
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
