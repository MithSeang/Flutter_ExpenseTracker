import 'package:expense_tracker/controller/calendar_controller.dart';
import 'package:expense_tracker/model/create_expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/expense_category.model.dart';
import '../model/expense_model.dart';
import '../service/api_service.dart';

class ExpenseController extends GetxController {
  final apiService = ApiService();
  var isFetching = false.obs;
  var lstExpense = Expense_Model().obs;
  var editExpense = CreateExpense_Model().obs;

  var items = [
    'Food',
    'Beverage',
    'Education',
    "Cosmetics",
    'Shopping',
    'Coffee',
    'Transport'
  ].obs;
  var selectedItem = 'Food'.obs;
  var expenses = <ExpenseCategory>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await getExpense();
    generateExpenses();
  }

  void generateExpenses() async {
    final calendarController = Get.put(CalendarController());
    final selectedMonth = calendarController.selectedMoth.value;
    final response = await apiService.fetchExpense();
    if (response.data == null) {
      expenses.clear();
      return;
    } // Filter expenses by selected month
    var monthlyExpenses = response.data!.where((expense) {
      if (expense.date == null || expense.date!.isEmpty) return false;

      final expenseDate = _parseDate(expense.date!);
      if (expenseDate == null) return false;

      return expenseDate.year == selectedMonth.year &&
          expenseDate.month == selectedMonth.month;
    }).toList();

    // Create a map to group expenses by category
    Map<String, double> categoryMap = {};

    for (var item in monthlyExpenses) {
      String category = item.category.toString(); // loop item from api
      double amount = item.amount!.toDouble(); // loop item from api

      // If the category already exists in the map, add the amount to it, otherwise create a new entry
      if (categoryMap.containsKey(category)) {
        categoryMap[category] = categoryMap[category]! + amount;
      } else {
        categoryMap[category] = amount;
      }
    }

    // Convert the map back to a list of ExpenseCategory objects
    expenses.value = categoryMap.entries.map((entry) {
      return ExpenseCategory(
        categoryName: entry.key,
        amount: entry.value,
        color: _getCategoryColor(entry.key),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.green;
      case 'Beverage':
        return Colors.blue;
      case 'Education':
        return Colors.orange;
      case 'Cosmetics':
        return Colors.purple;
      case 'Shopping':
        return Colors.red;
      case 'Coffee':
        return Colors.brown;
      case 'Transport':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void changeDropDown(String value) {
    selectedItem.value = value;
  }

  Future<void> getExpense() async {
    try {
      final calendarController = Get.put(CalendarController());
      final selectedMonth = calendarController.selectedMoth.value;

      isFetching.value = true;
      final response = await apiService.fetchExpense();
      lstExpense.value = response;
      print('All Expenses: ${lstExpense.value.data}');

      final filteredExpenses = lstExpense.value.data?.where((expense) {
        final expenseDate = _parseDate(expense.date);
        return expenseDate != null &&
            expenseDate.year == selectedMonth.year &&
            expenseDate.month == selectedMonth.month;
      }).toList();

      // Format the dates for display
      final formattedExpenses = filteredExpenses?.map((expense) {
        final parsedDate = _parseDate(expense.date);
        if (parsedDate != null) {
          expense.date = DateFormat('EEEE, d MMM yyyy').format(parsedDate);
        }
        return expense;
      }).toList();

      lstExpense.value = Expense_Model(data: formattedExpenses);
      generateExpenses();
      print("Filtered expenses: $filteredExpenses");
      isFetching.value = false;
    } catch (e) {
      isFetching.value = false;
      Get.snackbar('Error fetching expenses', 'Retry', colorText: Colors.red);
      print(
          'Error fetching expenses: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;

    // Try parsing ISO format (e.g., 2025-07-11)
    DateTime? parsedDate = DateTime.tryParse(
        dateString); //get string date "2025-07-11" to 2025-07-11
    if (parsedDate != null) return parsedDate;

    // Try parsing formatted date (e.g., Sunday, 2 Feb 2025)
    final formattedDate = DateFormat('EEEE, d MMM yyyy').tryParse(dateString);
    return formattedDate;
  }

  void createExpense(
      double amount, String category, String date, String? notes) async {
    try {
      isFetching.value = true;
      await apiService.createExpense(
          amount: amount, category: category, date: date, notes: notes);
      isFetching.value = false;
      Get.snackbar('Expense created ', 'created successfully',
          colorText: Colors.green);
      await getExpense();
      generateExpenses();
    } catch (e) {
      isFetching.value = false;
      Get.snackbar("Create Failed", e.toString().replaceAll("Exception: ", ''));
    }
  }

  void updatedExpense(int expenseid, double amount, String category,
      String date, String? notes) async {
    try {
      isFetching.value = true;
      print('Starting update for expense ID: $expenseid');
      editExpense.value = await apiService.updateExpense(
          expenseId: expenseid,
          amount: amount,
          category: category,
          date: date,
          notes: notes);
      isFetching.value = false;
      Get.snackbar('Expense Updated ', 'updated successfully',
          colorText: Colors.green);
      await getExpense();
      generateExpenses();
    } catch (e) {
      isFetching.value = false;
      print(
        'error $e',
      );
      Get.snackbar(
          "Updated Failed", e.toString().replaceAll("Exception: ", ''));
    }
  }

  void deletedExpense(int expenseid) async {
    try {
      isFetching.value = true;
      print('Starting Delete for expense ID: $expenseid');
      editExpense.value = await apiService.deleteExpense(
        expenseid,
      );
      isFetching.value = false;
      Get.snackbar('Expense Delete ', 'Deleted successfully',
          colorText: Colors.green);
      getExpense();
      generateExpenses();
    } catch (e) {
      isFetching.value = false;
      print(
        'error delete: $e',
      );
      Get.snackbar(
          "Deleted Failed", e.toString().replaceAll("Exception: ", ''));
    }
  }
}
