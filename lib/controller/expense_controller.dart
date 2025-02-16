import 'package:dio/dio.dart';
import 'package:expense_tracker/controller/calendar_controller.dart';
import 'package:expense_tracker/model/create_expense_model.dart';
import 'package:expense_tracker/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../model/expense_category.model.dart';
import '../model/expense_model.dart';
import '../service/api_service.dart';

class ExpenseController extends GetxController {
  final apiService = ApiService();
  var isFetching = false.obs;
  var lstExpense = Expense_Model().obs;
  var editExpense = CreateExpense_Model().obs;
  final box = GetStorage();

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
    if (response?.data == null) {
      expenses.clear();
      return;
    } // Filter expenses by selected month
    var monthlyExpenses = response?.data!.where((expense) {
      if (expense.date == null || expense.date!.isEmpty) return false;

      final expenseDate = _parseDate(expense.date!);
      if (expenseDate == null) return false;

      return expenseDate.year == selectedMonth.year &&
          expenseDate.month == selectedMonth.month;
    }).toList();

    // Create a map to group expenses by category
    Map<String, double> categoryMap = {};

    for (var item in monthlyExpenses!) {
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
      print(
        'Current route :${Get.currentRoute}',
      );
      final calendarController = Get.put(CalendarController());
      final selectedMonth = calendarController.selectedMoth.value;

      isFetching.value = true;
      final response = await apiService.fetchExpense();
      if (response == null) {
        isFetching.value = false;
        return;
      }
      // if (response.data is Map<String, dynamic>) {
      //   final responseMap = response.data as Map<String, dynamic>;
      //   if (responseMap['message'] == 'Invalid token') {
      //     // Handle invalid token and show an error message
      //     throw Exception('Invalid token. Please log in again.');
      //   }
      //   if (responseMap['message'] == 'Access denied, Unauthorized') {
      //     // Handle unauthorized access and show an error message
      //     throw Exception('Access denied. Please log in again.');
      //   }
      // }

      print('Response: $response'); // Add this for debugging
      if (response.data == null) {
        throw Exception('No expense available');
      }
      lstExpense.value = response;

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
      if (e is DioException) {
        if (e.response != null) {
          print('DioErrors: ${e.response?.data}');
          // If server response data is available, display it
          Get.snackbar(
            'Error fetching expenses',
            e.response?.data ?? e.message,
            colorText: Colors.red,
          );
          if (e.response?.data['message'] == 'Invalid token') {
            Get.snackbar(
              'Invalid token',
              'Your token is invalid. Please log in again.',
              colorText: Colors.red,
            );
          }

          // Handle missing token (Access denied, Unauthorized)
          else if (e.response?.data['message'] ==
              'Access denied, Unauthorized') {
            Get.snackbar(
              'Access Denied',
              'Your session has expired. Please log in again.',
              colorText: Colors.red,
            );
          }
        } else {
          print('DioError: No response data');
          Get.snackbar(
            'Error fetching expenses',
            'Something went wrong. Please try again later.',
            colorText: Colors.red,
          );
        }
      } else {
        // For other errors, log and show a general error message
        print('General error: $e');
        Get.snackbar(
          'Error fetching expenses',
          "Unauthorized. Please log in again",
          // e.toString().replaceAll("Unexpected response: ", ""),
          colorText: Colors.red,
        );
      }
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
