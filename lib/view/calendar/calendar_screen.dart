import 'package:expense_tracker/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});
  final CalendarController _calendarController = Get.put(CalendarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: _calendarController.prevMonth,
                  ),
                  Text(
                    _calendarController.getFormatMonth(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: _calendarController.nextMonth,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
