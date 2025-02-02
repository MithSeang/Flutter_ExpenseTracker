import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/calendar_controller.dart';
import '../../controller/expense_controller.dart';
import '../../model/expense_category.model.dart';

class StatisticScreen extends StatelessWidget {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final CalendarController _calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistic")),
      body: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    _calendarController.prevMonth();
                    Get.find<ExpenseController>().getExpense();
                  },
                ),
                Text(
                  _calendarController.getFormatMonth(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: () {
                    _calendarController.nextMonth();
                    Get.find<ExpenseController>().getExpense();
                  },
                ),
              ],
            ),
            expenseController.expenses.isEmpty
                ? const Spacer()
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: expenseController.expenses.isEmpty
                  ? const Column(
                      children: [
                        Center(
                            child: Text(
                          'No Expense Found',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        )),
                      ],
                    )
                  : SfCircularChart(
                      legend: Legend(
                          isVisible: true, position: LegendPosition.right),
                      series: <CircularSeries>[
                        PieSeries<ExpenseCategory, String>(
                          dataSource: expenseController.expenses,
                          xValueMapper: (ExpenseCategory data, _) =>
                              data.categoryName,
                          yValueMapper: (ExpenseCategory data, _) =>
                              data.amount,
                          pointColorMapper: (ExpenseCategory data, _) =>
                              data.color,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        )
                      ],
                    ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenseController.expenses.length,
                itemBuilder: (context, index) {
                  final item = expenseController.expenses[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: item.color),
                    title: Text(item.categoryName),
                    trailing: Text(
                      "\$${item.amount.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
