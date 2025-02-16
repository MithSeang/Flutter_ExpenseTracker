// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/controller/manage_screen_controller.dart';
import 'package:expense_tracker/controller/profile_controller.dart';
import 'package:expense_tracker/manage_screen.dart';
import 'package:expense_tracker/model/get_user_model.dart';
import 'package:expense_tracker/model/login_model.dart';
import 'package:expense_tracker/service/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final _manageScreen = Get.find<ManageScreenController>();
  final apiService = ApiService();
  var userLogin = Login_Model().obs;
  final box = GetStorage();
  final user = User().obs;
  final isLoggedIn = false.obs;

  void login(String email, String password) async {
    try {
      EasyLoading.show(status: 'Loading');
      final response =
          await apiService.LoginUser(email: email, password: password);

      final token = response.data?.token;
      print('Get token : $token');
      if (token != null) {
        box.write('expenses', token);
        await Future.delayed(
            const Duration(milliseconds: 500)); // ⏳ Small delay
        await getUser();
        await Get.put(ExpenseController()).getExpense();
        await Future.delayed(
          const Duration(seconds: 1),
        );
        EasyLoading.dismiss();
        _manageScreen.changeScreen(0);
        Get.offAll(() => ManageScreen());
      }
    } on DioException catch (e) {
      isLoggedIn.value = false;
      print('Error login controller: $e');
      Get.snackbar("Login Failed", e.response?.data?['message']);
      EasyLoading.dismiss();
    }
  }

  Future<void> getUser() async {
    try {
      print('calling login user... ');
      final response = await apiService.getCurrentUser();
      print('after login route:${response.user?.email}');
      user.value = response.user!;

      print('user value from response: ${response.user?.email}');
    } catch (e) {
      print('error: $e');
    }
  }
}
