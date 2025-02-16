import 'package:expense_tracker/controller/profile_controller.dart';
import 'package:expense_tracker/view/login/login_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'expense_controller.dart';

class LogoutController extends GetxController {
  final box = GetStorage();
  var isLogout = false.obs;
  Future<void> logout() async {
    try {
      EasyLoading.show(status: 'Loading...');
      box.remove('expenses');
      Get.delete<ExpenseController>();
      Get.delete<ProfileController>();
      await Future.delayed(const Duration(seconds: 2));
      EasyLoading.dismiss();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      EasyLoading.dismiss();
      print('Error: $e');
    }
  }
}
