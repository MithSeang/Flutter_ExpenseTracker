import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/controller/manage_screen_controller.dart';
import 'package:expense_tracker/dependency.dart';
import 'package:expense_tracker/manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
  Get.put(ManageScreenController());
  DependencyInject.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ManageScreen(),
      builder: EasyLoading.init(),
    );
  }
}
