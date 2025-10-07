import 'package:admin/Views/AuthViews/SigninView/signinview.dart';
import 'package:admin/Views/AuthViews/SignupView/signupview.dart';
import 'package:admin/Views/HomeViews/AddStudents/addstudents.dart';
import 'package:admin/Views/HomeViews/EnrolledStudents/enrolledstudents.dart';
import 'package:admin/Views/HomeViews/EnrollmentRequests/enrollmentrequests.dart';
import 'package:admin/Views/HomeViews/FeeSubmit/feesubmit.dart';
import 'package:admin/Views/HomeViews/ProfileView/profileview.dart';
import 'package:admin/Views/HomeViews/homeview.dart';
import 'package:admin/Views/StartingViews/SplashView/splashview.dart';
import 'package:admin/Widgets/BottomNavBar/bottomnavbar.dart';
import 'package:admin/Widgets/SubjectDetail/subjectdetail.dart';
import 'package:admin/Widgets/SubjectForm/subjectform.dart';
import 'package:get/get.dart';

class AppRoutes{
  static String splashScreen = "/";
  static String signupScreen = "/SignupView";
  static String signinScreen = "/SigninView";
  static String homeScreen = "/HomeView";
  static String subjectForm = "/SubjectForm";
  static String subjectDetail = "/SubjectDetail"; 
  static String enrollmentRequests = "/EnrollmentRequests";
  static String enrolledStudents = "/EnrolledStudents";
  static String bottomNavBar = "/BottomNavBar";
  static String profileScreen = "/ProfileView";
  static String addStudents = "/AddStudents";
  static String feeSubmit = "/feeSubmit";

  static final routes = [
    GetPage(name: splashScreen, page: ()=> SplashView()),
    GetPage(name: signupScreen, page: ()=> SignupView()),
    GetPage(name: signinScreen, page: ()=> SigninView()),
    GetPage(name: homeScreen, page: ()=> HomeView()),
    GetPage(name: subjectForm, page: ()=> SubjectForm()),
    GetPage(name: subjectDetail, page: ()=> SubjectDetail()),
    GetPage(name: enrollmentRequests, page: ()=> EnrollmentRequests()),
    GetPage(name: enrolledStudents, page: ()=> EnrolledStudents()),
    GetPage(name: bottomNavBar, page: ()=> BottomNavBar()),
    GetPage(name: profileScreen, page: ()=> ProfileView()),
    GetPage(name: addStudents, page: ()=> AddStudents()),
    GetPage(name: feeSubmit, page: ()=> FeeSubmit()),
  ];

}