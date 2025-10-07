import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextFieldWidget/textfieldwidget.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';

class EnrollForm extends StatelessWidget {
  final SubjectModel subject; // Subject jisme enroll karna hai
  EnrollForm({Key? key, required this.subject}) : super(key: key);

  final adminController = Get.find<AdminController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.whiteColor,
          ),
        ),
        title: TextWidget.h2("Submit Enrollment", Colors.white, context),
        backgroundColor: AppColors.purpleColor,
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  label: "Student Name",
                  controller: authController.userController,
                  text: "Enter Student Name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Father Name",
                  controller: adminController.fatherNameController,
                  text: "Enter Father Name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Email",
                  controller: adminController.emailController,
                  text: "Enter Student Email",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Track ID",
                  controller: adminController.trackIdController,
                  text: "Enter Transaction Track ID",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Transaction Method",
                  controller: adminController.transactionController,
                  text: "Enter Transaction Method",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Subject ID",
                  controller: adminController.subjectIdController,
                  text: "Enter Subject ID",
                ),
                SizedBox(height: 40),
                Obx(
                      () => GestureDetector(
                    onTap: () {
                      // ✅ Directly enroll student using controller function
                      adminController.EnrolledStudents(subject);
                    },
                    child: adminController.isLoading.value
                        ? Center(child: IsLoading())
                        : Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        text: "Submit",
                        textcolor: AppColors.whiteColor,
                        color: AppColors.purpleColor,
                      ),
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
