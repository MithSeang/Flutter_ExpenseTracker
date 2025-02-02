import 'package:flutter/material.dart';

class ExpenseCategory {
  final String categoryName;
  final double amount;
  final Color color;
  ExpenseCategory({
    required this.categoryName,
    required this.amount,
    required this.color,
  });
}
