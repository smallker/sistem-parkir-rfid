import 'package:get/get_state_manager/get_state_manager.dart';
import '../model/user_model.dart';

class UserInfoCtl extends GetxController {
  UserModel user;

  updateUser(UserModel user) {
    this.user = user;
    update();
  }
}
