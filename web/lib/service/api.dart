// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web/controller/user_info_ctl.dart';
import '../model/user_model.dart';
import 'dart:convert';

class Api {
  static var baseUrl = "http://localhost:3000";
  getUserInfo() async {
    var response = await http.get('$baseUrl/userinfo');
    if (response.statusCode == HttpStatus.ok) {
      UserModel user = UserModel.fromJson(json.decode(response.body));
      Get.find<UserInfoCtl>().updateUser(user);
    }
  }

  createUser() async {}
}
