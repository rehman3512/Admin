import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextFieldWidget/textfieldwidget.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectForm extends StatelessWidget {
  SubjectForm({super.key});

  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.whiteColor,
          ),
        ),
        title: TextWidget.h3("Subject Form", AppColors.whiteColor, context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  label: "Subject",
                  controller: adminController.subjectController,
                  text: "Enter subject Name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Subject Id",
                  controller: adminController.subjectIdController,
                  text: "Enter subject Id",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Duration",
                  controller: adminController.durationController,
                  text: "Enter subject duration",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Registration Fees",
                  controller: adminController.registrationController,
                  text: "Enter registration fees",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Teacher",
                  controller: adminController.teacherController,
                  text: "Enter teacher name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Class",
                  controller: adminController.classController,
                  text: "Enter class timing",
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      adminController.addSubject();
                    },
                    child: adminController.isLoading.value
                        ? Center(child: IsLoading())
                        : CustomButton(
                            text: "Save",
                            textcolor: AppColors.whiteColor,
                            color: AppColors.purpleColor,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
