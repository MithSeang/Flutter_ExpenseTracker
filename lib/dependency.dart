import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:get/get.dart';

class DependencyInject {
  static void init() {
    Get.lazyPut(
      () => ExpenseController(),
    );
  }
}
