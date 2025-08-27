import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/update_controllers/banner_controller.dart';


import '../../widgets/update/exam_start_card.dart';

class ExamRoutine extends StatefulWidget {
  const ExamRoutine({super.key});

  @override
  State<ExamRoutine> createState() => _ExamRoutineState();
}

class _ExamRoutineState extends State<ExamRoutine> {
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<String>> _examSchedule = {};
  BannerController bannerController = Get.find();

  @override
  void initState() {
    super.initState();
    // Simulating API call for getting exam schedule
    _examSchedule = {};
  }

  List<String> _getExamsForSelectedDate(DateTime date) {
    return _examSchedule[DateTime.utc(date.year, date.month, date.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Routine',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
        child: Column(
          children: [
            // Calendar widget - Corrected for version 1.1.3
            EasyInfiniteDateTimeLine(
              firstDate: DateTime(2024, 1, 1),
              focusDate: _selectedDate,
              lastDate: DateTime(2030, 3, 18),
              onDateChange: (selectedDate) {
                // Handle the selected date.
                setState(() {
                  _selectedDate = selectedDate;
                });
              },
              dayProps: const EasyDayProps(
                width: 64.0,
                height: 80.0,
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xff3371FF),
                  ),
                ),
                inactiveDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF5F5F5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Display selected date
            Text(
              'Selected Day: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display exams for the selected date
            Expanded(
              child: _buildExamList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamList() {
    return Center(
      child: Obx(() {
        return ListView.builder(
            itemCount: bannerController.upcomingExamList.length,
            itemBuilder: (context, index) {
              DateTime startDateTime = DateTime.parse(
                  bannerController.upcomingExamList[index]['start_datetime']);
              DateTime selectedDate = _selectedDate;
              return (DateTime(startDateTime.year, startDateTime.month,
                          startDateTime.day) ==
                      DateTime(selectedDate.year, selectedDate.month,
                          selectedDate.day))
                  ? ExamStartCard(
                      isUpcoming: true,
                      data: bannerController.upcomingExamList[index],
                      isLiveExam: true,
                      isModelTest: false,
                    )
                  : Container(
                      child: const Text(''),
                    );
            });
      }),
    );
  }
}
