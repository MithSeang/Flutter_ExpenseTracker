import 'package:dio/dio.dart';
import 'package:expense_tracker/model/register_model.dart';
import 'package:expense_tracker/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../service/api_service.dart';

class RegisterController extends GetxController {
  final apiService = ApiService();
  final isLoggedIn = false.obs;
  Future<void> register(String username, String email, String password) async {
    try {
      EasyLoading.show(status: 'Loading');
      await apiService.RegisterUser(
          username: username, email: email, password: password);

      EasyLoading.dismiss();
      Get.snackbar(
        'Register Successfully',
        'Account registered successfully',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      Get.offAll(() => LoginScreen());
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Register failed',
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      isLoggedIn.value = false;
      print('Error: $e');
    }
  }
}
