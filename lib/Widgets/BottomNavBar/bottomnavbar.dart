import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Views/HomeViews/AddStudents/addstudents.dart';
import 'package:admin/Views/HomeViews/FeeSubmit/feesubmit.dart';
import 'package:admin/Views/HomeViews/ProfileView/profileview.dart';
import 'package:admin/Views/HomeViews/homeview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final adminController = Get.find<AdminController>();
  final List<Widget> screens = [
    HomeView(),
    AddStudents(),
    FeeSubmit(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: screens[adminController.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: adminController.currentIndex.value,
          type: BottomNavigationBarType.fixed,
          onTap: adminController.changeTab,
          selectedItemColor: AppColors.purpleColor, 
          unselectedItemColor: AppColors.greyColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.school_outlined),
            label: "AddStudents"),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_outlined),
            label: "FeeSubmit"),
            BottomNavigationBarItem(icon: Icon(Icons.person),
            label: "Profile"),
          ]
      ),
    ));
  }
}
