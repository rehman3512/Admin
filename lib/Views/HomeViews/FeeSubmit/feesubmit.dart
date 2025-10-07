import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Widgets/FeeForm/feeform.dart';
import 'package:admin/Widgets/FeeRequests/feerequests.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/Constants/AppColors/appcolors.dart';

class FeeSubmit extends StatelessWidget {
  FeeSubmit({super.key});

  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        title: TextWidget.h2("Fee Submit", AppColors.whiteColor, context),
      ),
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // 🔹 Directly open FeeRequestsAdmin without argument
              Get.to(() => FeeRequests());
            },
            child: Icon(Icons.remove, color: AppColors.whiteColor),
            backgroundColor: AppColors.purpleColor,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              if (adminController.subjectList.isNotEmpty) {
                Get.to(() => FeeForm(subject: adminController.subjectList[0]));
              } else {
                Get.snackbar(
                  "Error",
                  "No subject available",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Icon(Icons.add, color: AppColors.whiteColor),
            backgroundColor: AppColors.purpleColor,
          ),
        ],
      ),
      body: Center(
        child: TextWidget.h2("Fee Submit", AppColors.blackColor, context),
      ),
    );
  }
}
