import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/controller/manage_screen_controller.dart';
import 'package:expense_tracker/view/add_expense/add_expense_screen.dart';
import 'package:expense_tracker/view/calendar/calendar_screen.dart';
import 'package:expense_tracker/view/home/home_screen.dart';
import 'package:expense_tracker/view/statistic/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'view/profile/profile_screen.dart';

class ManageScreen extends StatelessWidget {
  ManageScreen({super.key});
  final ManageScreenController _manageScreenController =
      Get.put(ManageScreenController());
  List<Widget> screens = [
    HomeScreen(),
    // Container(),
    StatisticScreen(),
    ProfileScreen()
  ];
  List<IconData> icons = [
    Icons.home,
    // Icons.add,
    Icons.analytics_outlined,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_manageScreenController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Scaffold(
        body: IndexedStack(
            index: _manageScreenController.currentScreen.value,
            children: screens),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddExpenseDialog(context);
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.zero,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < icons.length; i++)
                  IconButton(
                      onPressed: () {
                        // i == 2
                        //     ? _showAddExpenseDialog(context)
                        //     :
                        _manageScreenController.changeScreen(i);
                      },
                      icon: Icon(
                        icons[i],
                        size: 30,
                        color: _manageScreenController.currentScreen.value == i
                            ? Colors.blue
                            : Colors.black,
                      ))
              ],
            )),
      );
    });
  }

  void _showAddExpenseDialog(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey<FormState>();
    DateTime selectedDate = DateTime.now();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final TextEditingController dateController = TextEditingController(
        text: DateFormat('EEEE, d MMM yyyy').format(selectedDate));
    final ExpenseController _expenseController = Get.put(ExpenseController());
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _key,
          child: AlertDialog(
            title: const Text("New Expense"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => DropdownButton(
                    value: _expenseController.selectedItem.value,
                    items: _expenseController.items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _expenseController.changeDropDown(value);
                      }
                    },
                  ),
                ),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return "Amount cannot be empty.";
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: notesController,
                  decoration:
                      const InputDecoration(labelText: "Notes (Optional)"),
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_month)),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));
                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                      dateController.text =
                          DateFormat('EEEE, d MMM yyyy').format(selectedDate);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    if (amountController.text.isNotEmpty &&
                        dateController.text.isNotEmpty) {
                      _expenseController.createExpense(
                          double.parse(amountController.text),
                          _expenseController.selectedItem.value,
                          dateController.text,
                          notesController.text);
                      print(double.parse(amountController.text));

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
  }
}
