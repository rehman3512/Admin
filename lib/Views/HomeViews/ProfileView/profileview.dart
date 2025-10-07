import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextFieldOutline/TextFieldOutline.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final authController = Get.find<AuthController>();
  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      adminController.FetchProfile();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        title: TextWidget.h2("Admin Profile", AppColors.whiteColor, context),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldOutline(
                  prefixicon: Icon(Icons.person),
                  label: "Name",
                  controller: authController.userController,
                  text: "Enter your name",
                ),
                SizedBox(height: 20),
                TextFieldOutline(
                  prefixicon: Icon(Icons.email),
                  label: "email",
                  controller: authController.emailController,
                  text: "Enter your email",
                  readOnly: true,
                ),
                SizedBox(height: 20),
                TextFieldOutline(
                  prefixicon: Icon(Icons.cake),
                  label: "age",
                  controller: adminController.ageController,
                  text: "Enter your age",
                ),
                SizedBox(height: 20),
                TextFieldOutline(
                  prefixicon: Icon(Icons.male),
                  label: "Gender",
                  controller: adminController.genderController,
                  text: "Enter your name",
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      adminController.insertProfile();
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
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      adminController.deleteProfile();
                    },
                    child: adminController.isDelete.value
                        ? IsLoading()
                        : CustomButton(
                      text: "Delete",
                      textcolor: AppColors.whiteColor,
                      color: AppColors.redColor,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      authController.signout();
                    },
                    child: authController.isLoading.value
                        ? IsLoading()
                        : Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200, // light background
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: AppColors.redColor), // logout icon
                          SizedBox(width: 8),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: AppColors.redColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
