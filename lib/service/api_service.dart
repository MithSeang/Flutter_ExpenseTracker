import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:expense_tracker/model/create_expense_model.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/model/get_user_model.dart';
import 'package:expense_tracker/model/login_model.dart';
import 'package:expense_tracker/model/register_model.dart';
import 'package:expense_tracker/utils/path.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final dio = Dio();
  final box = GetStorage();
  Future<Register_Model> RegisterUser(
      {required String username,
      required String email,
      required String password}) async {
    final Map<String, String> data = {
      'username': username,
      'email': email,
      'password': password,
    };
    final response = await dio.post("$baseUrl/register",
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    print("Get :${response.data}");

    if (response.statusCode == 201) {
      return Register_Model.fromJson(response.data);
    } else {
      String errorMessage = response.data?['message'] ?? "Failed to register";
      throw Exception(errorMessage);
    }
  }

  Future<Login_Model> LoginUser(
      {required String email, required String password}) async {
    final Map<String, String> data = {
      'email': email,
      'password': password,
    };
    final response = await dio.post('$baseUrl/login',
        data: jsonEncode(data),
        options: Options(headers: {
          'Accept': 'application/json',
          "Content-Type": 'application/json'
        }));
    print("Sending request to: $baseUrl/login");

    if (response.statusCode == 200) {
      return Login_Model.fromJson(response.data);
    } else {
      throw Exception("failed to login user");
    }
  }

  Future<GetUser_Model> getCurrentUser() async {
    final response = await dio.get('$baseUrl/currentuser',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': '${box.read('expenses')}'
        }));
    if (response.statusCode == 200) {
      return GetUser_Model.fromJson(response.data);
    } else {
      throw Exception("failed to get user data");
    }
  }

  Future<Expense_Model> fetchExpense() async {
    final response = await dio.get(
      '$baseUrl/expenses',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': '${box.read('expenses')}'
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    print("response:${response.data}");
    if (response.statusCode == 200) {
      return Expense_Model.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch expenses");
    }
  }

  Future<CreateExpense_Model> createExpense(
      {required double amount,
      required String category,
      required String date,
      String? notes}) async {
    final data = {
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes == null || notes.trim().isEmpty ? null : notes,
    };
    print("Sending Data :$data");
    final response = await dio.post('$baseUrl/expense',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': '${box.read('expenses')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (response.statusCode == 200) {
      return CreateExpense_Model.fromJson(response.data);
    } else {
      String errorMessage = response.data['message'];
      throw Exception(errorMessage);
    }
  }

  Future<CreateExpense_Model> updateExpense(
      {required int expenseId,
      required double amount,
      required String category,
      required String date,
      String? notes}) async {
    final data = {
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes == null || notes.trim().isEmpty ? null : notes,
    };
    print("Sending Data :$data");
    final response = await dio.put('$baseUrl/expense/$expenseId',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': '${box.read('expenses')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (response.statusCode == 200) {
      return CreateExpense_Model.fromJson(response.data);
    } else {
      String errorMessage = response.data?['message'];
      print('errorMessage: ' + errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<CreateExpense_Model> deleteExpense(
    int expenseId,
  ) async {
    print('Updating expense with ID: $expenseId (${expenseId.runtimeType})');

    final response = await dio.delete('$baseUrl/expense/$expenseId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': '${box.read('expenses')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (response.statusCode == 200) {
      return CreateExpense_Model.fromJson(response.data);
    } else {
      String errorMessage = response.data?['message'];
      print('errorMessage: ' + errorMessage);
      throw Exception(errorMessage);
    }
  }
}
