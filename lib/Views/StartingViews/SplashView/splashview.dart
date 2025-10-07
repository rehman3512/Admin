import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),(){
      authController.checkLogin();
    });
    return Scaffold(
      body: Center(child: Text("Splash Screen"),),
    );
  }
}
