import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextFieldWidget/textfieldwidget.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FeeForm extends StatelessWidget {
  final SubjectModel subject;
  FeeForm({super.key,required this.subject});

  final authController = Get.find<AuthController>();
  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,
          color: AppColors.whiteColor,)
        ),
        title: TextWidget.h2("Fee Form", AppColors.whiteColor, context),
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
                  text: "Enter your Name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Father Name",
                  controller: adminController.fatherNameController,
                  text: "Enter your father name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Email address",
                  controller: adminController.emailController,
                  text: "Enter student email",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Subject Id",
                  controller: adminController.subjectIdController,
                  text: "Enter Subject Id",
                ),
                SizedBox(height: 20),TextFieldWidget(
                  label: "Account Holder",
                  controller: adminController.accountHolderController,
                  text: "Enter account holder name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Track Id",
                  controller: adminController.trackIdController,
                  text: "Enter transaction track Id",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Transaction Method",
                  controller: adminController.transactionController,
                  text: "Enter transaction method",
                ),
                SizedBox(height: 40),
                Obx(
                      ()=> GestureDetector(
                    onTap: () {
                      adminController.SubmitFee(subject);
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
