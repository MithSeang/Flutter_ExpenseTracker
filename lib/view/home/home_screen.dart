// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/controller/logout_controller.dart';
import 'package:expense_tracker/model/create_expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../../controller/calendar_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ExpenseController _expenseController = Get.put(ExpenseController());
  final CalendarController _calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Obx(() {
          if (_expenseController.isFetching.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final expense = _expenseController.lstExpense.value;

          return RefreshIndicator(
            onRefresh: () async {
              _expenseController.getExpense();
            },
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        _calendarController.prevMonth();
                        _expenseController.getExpense();
                      },
                    ),
                    Text(
                      _calendarController.getFormatMonth(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        _calendarController.nextMonth();
                        _expenseController.getExpense();
                      },
                    ),
                  ],
                ),
                (expense.data == null || expense.data!.isEmpty)
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Center(
                            child: Text(
                              'No Expense',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 1.7),
                        itemCount: expense.data!.length,
                        itemBuilder: (context, index) {
                          final item = expense.data![index];
                          return Card(
                            color: const Color.fromARGB(255, 226, 226, 225),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 12),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.date}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${item.category} ',
                                    style: const TextStyle(
                                        height: 1.4,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '${item.notes}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1,
                                    ),
                                    maxLines: 2,
                                  )
                                ],
                              ),
                              onTap: () {
                                GlobalKey<FormState> _key =
                                    GlobalKey<FormState>();
                                DateTime selectedDate = DateTime.now();
                                final TextEditingController amountController =
                                    TextEditingController(
                                        text: item.amount.toString());
                                final TextEditingController notesController =
                                    TextEditingController(
                                        text: item.notes ?? "");
                                final TextEditingController dateController =
                                    TextEditingController(
                                        text: DateFormat('EEEE, d MMM yyyy')
                                            .format(
                                                DateTime.tryParse(item.date!) ??
                                                    DateTime.now()));
                                final ExpenseController _expenseController =
                                    Get.put(ExpenseController());
                                _expenseController
                                    .changeDropDown(item.category!);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Form(
                                      key: _key,
                                      child: AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Update Expense",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close))
                                          ],
                                        ),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(
                                              () => DropdownButton(
                                                value: _expenseController
                                                        .selectedItem
                                                        .value
                                                        .isEmpty
                                                    ? item.category
                                                    : _expenseController
                                                        .selectedItem.value,
                                                items: _expenseController.items
                                                    .map((item) {
                                                  return DropdownMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    _expenseController
                                                        .changeDropDown(value);
                                                  }
                                                },
                                              ),
                                            ),
                                            TextFormField(
                                              controller: amountController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  labelText: "Amount"),
                                              validator: (value) {
                                                if (value!.isEmpty ||
                                                    value == "") {
                                                  return "Amount cannot be empty.";
                                                }
                                                return null;
                                              },
                                            ),
                                            TextField(
                                              controller: notesController,
                                              decoration: const InputDecoration(
                                                  labelText:
                                                      "Notes (Optional)"),
                                            ),
                                            TextField(
                                              controller: dateController,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                  suffixIcon: Icon(
                                                      Icons.calendar_month)),
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            selectedDate,
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2100));
                                                if (pickedDate != null) {
                                                  selectedDate = pickedDate;
                                                  dateController
                                                      .text = DateFormat(
                                                          'EEEE, d MMM yyyy')
                                                      .format(selectedDate);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _expenseController.deletedExpense(
                                                  item.expenseID!);
                                              Navigator.pop(context);
                                            }, // Close dialog
                                            child: const Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_key.currentState!
                                                  .validate()) {
                                                if (amountController
                                                        .text.isNotEmpty &&
                                                    dateController
                                                        .text.isNotEmpty) {
                                                  print(
                                                      'ExpenseID before update: ${item.expenseID}, Type: ${item.expenseID.runtimeType}');

                                                  _expenseController
                                                      .updatedExpense(
                                                          item.expenseID!,
                                                          double.parse(
                                                              amountController
                                                                  .text),
                                                          _expenseController
                                                              .selectedItem
                                                              .value,
                                                          dateController.text,
                                                          notesController.text);
                                                  print(double.parse(
                                                      amountController.text));

                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            child: const Text("Save"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              trailing: Text(
                                "\$${item.amount}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        }));
  }
}
