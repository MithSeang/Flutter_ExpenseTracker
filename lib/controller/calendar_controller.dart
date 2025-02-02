import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'expense_controller.dart';

class CalendarController extends GetxController {
  var selectedMoth = DateTime.now().obs;
  void nextMonth() {
    selectedMoth.value =
        DateTime(selectedMoth.value.year, selectedMoth.value.month + 1, 1);
    _refreshExpense();
  }

  void prevMonth() {
    selectedMoth.value =
        DateTime(selectedMoth.value.year, selectedMoth.value.month - 1, 1);
    _refreshExpense();
  }

  String getFormatMonth() {
    return DateFormat.yMMMM().format(selectedMoth.value);
  }

  void _refreshExpense() {
    final expenseController = Get.find<ExpenseController>();
    expenseController.getExpense();
  }
}
