import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/CustomTextField/customtextfield.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/Widgets/ToggleButton/togglebutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextWidget.h1("Welcome", AppColors.blackColor, context),
                SizedBox(height: 30),
                ToggleButton(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget.h3(
                        "Create your account and learn \n with us",
                        AppColors.blackColor,
                        context,
                      ),
                      SizedBox(height: 35),
                      CustomTextField(
                        label: "UserName",
                        controller: authController.userController,
                        text: "Enter your username",
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        label: "Email Address",
                        controller: authController.emailController,
                        text: "Enter you email",
                      ),
                      SizedBox(height: 15),
                      Obx(() => CustomTextField(
                        label: "Password",
                        controller: authController.passwordController,
                        text: "Enter your password",
                        obsecure: authController.isPasswordHidden.value,
                        suffixicon: IconButton(
                          icon: Icon(
                            authController.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            authController.isPasswordHidden.value =
                            !authController.isPasswordHidden.value;
                          },
                        ),
                      )),
                      SizedBox(height: 55),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              authController.signup();
                            },
                            child: authController.isLoading.value
                                ? Center(child: IsLoading())
                                : CustomButton(
                              text: "Signup",
                              textcolor: AppColors.whiteColor,
                              color: AppColors.purpleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
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
