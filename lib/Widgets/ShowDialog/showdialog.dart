import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDialog {
  static successDialog(String message) {
    Get.defaultDialog(
      title: "✅ Success",
      middleText: message,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: Colors.black87),
      radius: 12,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () => Get.back(),
    );
  }

  static errorDialog(String message) {
    Get.defaultDialog(
      title: "❌ Error",
      middleText: message,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: Colors.black87),
      radius: 12,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => Get.back(),
    );
  }

  // ⚠️ Warning Dialog
  static warningDialog(String message) {
    Get.defaultDialog(
      title: "⚠️ Warning",
      middleText: message,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: Colors.black87),
      radius: 12,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.orange,
      onConfirm: () => Get.back(),
    );
  }
}
