import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/CustomTextField/customtextfield.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/Widgets/ToggleButton/togglebutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninView extends StatelessWidget {
  SigninView({super.key});

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
                TextWidget.h1("Welcome back", AppColors.blackColor, context),
                SizedBox(height: 30),
                ToggleButton(),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget.h3(
                        "signin your account and continue \n your study",
                        AppColors.blackColor,
                        context,
                      ),
                      SizedBox(height: 35),
                      CustomTextField(
                        label: "Email Address",
                        controller: authController.emailController,
                        text: "Enter your email",
                      ),
                      SizedBox(height: 15),
                      Obx(
                            () => CustomTextField(
                          label: "Password",
                          controller: authController.passwordController,
                          text: "Enter your password",
                          obsecure: authController.isPasswordHidden.value,
                          suffixicon: GestureDetector(
                            onTap: () {
                              authController.isPasswordHidden.value = !authController.isPasswordHidden.value;
                            },
                            child: Icon(
                              // show appropriate icon
                              authController.isPasswordHidden.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              authController.ForgotPassword();
                            },
                            child: authController.isForgot.value
                                ? IsLoading()
                                : TextWidget.h3(
                                    "Forgot Password?",
                                    AppColors.purpleColor,
                                    context,
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(height: 55),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              authController.signin();
                            },
                            child: authController.isLoading.value
                                ? Center(child: IsLoading())
                                : CustomButton(
                                    text: "Signin",
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
