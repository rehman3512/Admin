import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Widgets/EnrollForm/enrollform.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudents extends StatelessWidget {
  AddStudents({super.key});

  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget.h2("Add Students", Colors.white, context),
        backgroundColor: AppColors.purpleColor,
      ),
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: FloatingActionButton(onPressed: (){
        if (adminController.subjectList.isNotEmpty) {
          // Index 0 as example, user select ka logic add kar sakte ho
          Get.to(() => EnrollForm(subject: adminController.subjectList[0],));
        } else {
          Get.snackbar(
            "Error",
            "No subject available",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },child: Icon(Icons.add,color: AppColors.whiteColor,),
      backgroundColor: AppColors.purpleColor,),
      body: Center(child: TextWidget.h2("Add Students", AppColors.blackColor, context),),
    );
  }
}
