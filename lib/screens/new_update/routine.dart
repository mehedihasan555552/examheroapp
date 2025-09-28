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
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 414;
    
    // Responsive padding based on screen size
    final horizontalPadding = isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0);
    final verticalPadding = isSmallScreen ? 8.0 : 16.0;
    
    // Responsive calendar dimensions - Fixed to prevent overflow
    final calendarItemWidth = isSmallScreen ? 50.0 : (isMediumScreen ? 55.0 : 60.0);
    final calendarItemHeight = isSmallScreen ? 65.0 : 75.0;
    
    // Responsive font sizes
    final titleFontSize = isSmallScreen ? 14.0 : 16.0;
    final appBarFontSize = isSmallScreen ? 18.0 : 20.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 2,
        title: Text(
          'Routine',
          style: TextStyle(
            color: Colors.white,
            fontSize: appBarFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
              onPressed: () {
                // Calendar view functionality
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Timeline Section - Fixed overflow issue
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(horizontalPadding),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: kPrimaryColor,
                        size: isSmallScreen ? 16 : 20,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 6 : 10),
                
                // Calendar widget with proper constraints to prevent overflow
                Container(
                  height: calendarItemHeight + 38,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            width: constraints.maxWidth,
                            child: EasyInfiniteDateTimeLine(
                              firstDate: DateTime(2024, 1, 1),
                              focusDate: _selectedDate,
                              lastDate: DateTime(2030, 3, 18),
                              onDateChange: (selectedDate) {
                                setState(() {
                                  _selectedDate = selectedDate;
                                });
                              },
                              dayProps: EasyDayProps(
                                width: calendarItemWidth,
                                height: calendarItemHeight,
                                dayStructure: DayStructure.dayStrDayNum,
                                activeDayStyle: DayStyle(
                                  dayNumStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dayStrStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isSmallScreen ? 9 : 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(isSmallScreen ? 8 : 10),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kPrimaryColor,
                                        kPrimaryColor.withOpacity(0.8),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kPrimaryColor.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                inactiveDayStyle: DayStyle(
                                  dayNumStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: isSmallScreen ? 12 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  dayStrStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: isSmallScreen ? 9 : 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(isSmallScreen ? 8 : 10),
                                    ),
                                    color: Colors.grey[100],
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Selected Date Display
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isSmallScreen ? 12 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.indigo[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                  ),
                  child: Icon(
                    Icons.event_note,
                    color: Colors.blue[700],
                    size: isSmallScreen ? 18 : 20,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Date',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat(isSmallScreen ? 'MMM d, y' : 'EEEE, MMM d, y')
                            .format(_selectedDate),
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 10,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                  ),
                  child: Obx(() {
                    List<dynamic> examsForDate = bannerController.upcomingExamList
                        .where((exam) {
                      DateTime startDateTime = DateTime.parse(exam['start_datetime']);
                      DateTime selectedDate = _selectedDate;
                      return DateTime(startDateTime.year, startDateTime.month,
                                  startDateTime.day) ==
                             DateTime(selectedDate.year, selectedDate.month,
                                  selectedDate.day);
                    }).toList();
                    
                    return Text(
                      '${examsForDate.length} ${examsForDate.length == 1 ? 'Exam' : 'Exams'}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 20),

          // Display exams for the selected date
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.quiz_outlined,
                            color: kPrimaryColor,
                            size: isSmallScreen ? 16 : 20,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: Text(
                            'Scheduled Exams',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Exam List
                  Expanded(
                    child: _buildExamList(isSmallScreen),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 16 : 20),
        ],
      ),
    );
  }

  Widget _buildExamList(bool isSmallScreen) {
    return Obx(() {
      // Filter exams for selected date
      List<dynamic> examsForDate = bannerController.upcomingExamList.where((exam) {
        DateTime startDateTime = DateTime.parse(exam['start_datetime']);
        DateTime selectedDate = _selectedDate;
        return DateTime(startDateTime.year, startDateTime.month, startDateTime.day) ==
               DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      }).toList();

      if (examsForDate.isEmpty) {
        return _buildEmptyState(isSmallScreen);
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 8 : 12,
        ),
        itemCount: examsForDate.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
            child: ExamStartCard(
              isUpcoming: true,
              data: examsForDate[index],
              isLiveExam: true,
              isModelTest: false,
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSmallScreen ? 80 : 100,
              height: isSmallScreen ? 80 : 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[200]!, Colors.grey[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_outlined,
                size: isSmallScreen ? 32 : 40,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            Text(
              'No Exams Scheduled',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
              ),
              child: Text(
                'No exams are scheduled for this date.\nSelect another date to view exams.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            
            // Quick tip
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.blue[600],
                    size: isSmallScreen ? 16 : 18,
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Text(
                      'Tip: Use the calendar above to browse different dates',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: isSmallScreen ? 11 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
