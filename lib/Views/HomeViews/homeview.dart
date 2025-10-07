import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/ShowMessage/showmessage.dart';
import 'package:admin/Widgets/SubjectContainer/subjectcontainer.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final authController = Get.find<AuthController>();
  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        title: TextWidget.h2("HomeScreen", AppColors.whiteColor, context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.subjectForm);
        },
        backgroundColor: AppColors.purpleColor,
        child: Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.h1("Subjects", AppColors.blackColor, context),
                SizedBox(height: 25,),
                Obx(() {
                  if(adminController.subjectList.isEmpty){
                    return Center(child: Text("No subjects available"));
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: adminController.subjectList.length,
                    itemBuilder: (context, index) {
                      final subject = adminController.subjectList[index];
                      return SubjectContainer(
                        subject: subject,
                        onTap: () {
                          Get.toNamed(AppRoutes.subjectDetail,
                          arguments: subject);
                        },
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
