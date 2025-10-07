import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleButton extends StatelessWidget {
  ToggleButton({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.068,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightPurpleColor,
        borderRadius: BorderRadius.circular(44),
        border: Border.all(color: AppColors.lightPurpleColor),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  authController.isLogin.value = false;
                  authController.clearFields();
                  Get.toNamed(AppRoutes.signupScreen);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: authController.isLogin.value
                        ? AppColors.transparentColor
                        : AppColors.purpleColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: TextWidget.h3(
                      "Signup",
                      authController.isLogin.value
                          ? AppColors.purpleColor
                          : AppColors.whiteColor,
                      context,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  authController.isLogin.value = true;
                  authController.clearFields();
                  Get.toNamed(AppRoutes.signinScreen);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: !authController.isLogin.value
                        ? AppColors.transparentColor
                        : AppColors.purpleColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: TextWidget.h3(
                      "Signin",
                      !authController.isLogin.value
                          ? AppColors.purpleColor
                          : AppColors.whiteColor,
                      context,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
