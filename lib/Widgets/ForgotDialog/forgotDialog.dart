import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Constants/AppColors/appcolors.dart';

class ForgotPasswordDialog extends StatelessWidget {
  ForgotPasswordDialog({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Check Your Email",
        style: TextStyle(
          color: AppColors.purpleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "A password reset link has been sent to your email address.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          authController.canResend.value
              ? ElevatedButton(
            onPressed: () {
              authController.resendPasswordEmail();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Resend Email",
              style: TextStyle(color: Colors.white),
            ),
          )
              : Text(
            "You can resend in ${authController.resendSeconds.value}s",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            "Close",
            style: TextStyle(color: AppColors.purpleColor),
          ),
        ),
      ],
    );
  }
}
