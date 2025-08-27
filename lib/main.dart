
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/auth/splash_view.dart';
import 'package:mission_dmc/screens/home_screen.dart';
import 'package:mission_dmc/screens/inner_screens/central_course.dart';
import 'package:mission_dmc/screens/inner_screens/download_video.dart';
import 'package:mission_dmc/screens/inner_screens/flash_card.dart';
import 'package:mission_dmc/screens/inner_screens/lecture_notes.dart';
import 'package:mission_dmc/screens/inner_screens/mcq_questions_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/mcq_test.dart';
import 'package:mission_dmc/screens/inner_screens/video_lecture.dart';
import 'package:mission_dmc/screens/auth/login_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/performace_screen.dart';
import 'package:mission_dmc/screens/profile/profile_screen.dart';
import 'package:mission_dmc/screens/auth/registration_screen.dart';
import 'package:mission_dmc/screens/auth/welcome_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: SplashView.id,
      routes: {
        SplashView.id: (context) => const SplashView(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(
              userId: 0,
            ),
        //Inner Screens
        PerformanceScreen.id: (context) => PerformanceScreen(),
        MCQTest.id: (context) => MCQTest(),
        //MCQ Questions
        MCQQuestion.id: (context) => const MCQQuestion(),
        CentralTest.id: (context) => const CentralTest(),
        VideoLecture.id: (context) => const VideoLecture(),
        DownloadVideo.id: (context) => const DownloadVideo(),
        FlashCard.id: (context) => const FlashCard(),
        LectureNotes.id: (context) => const LectureNotes(),
      },
    );
  }
}
