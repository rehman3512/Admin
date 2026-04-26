// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ShowDialog {
//   static successDialog(String message) {
//     Get.defaultDialog(
//       title: "✅ Success",
//       middleText: message,
//       backgroundColor: Colors.white,
//       titleStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//       middleTextStyle: const TextStyle(color: Colors.black87),
//       radius: 12,
//       textConfirm: "OK",
//       confirmTextColor: Colors.white,
//       buttonColor: Colors.green,
//       onConfirm: () => Get.back(),
//     );
//   }
//
//   static errorDialog(String message) {
//     Get.defaultDialog(
//       title: "❌ Error",
//       middleText: message,
//       backgroundColor: Colors.white,
//       titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//       middleTextStyle: const TextStyle(color: Colors.black87),
//       radius: 12,
//       textConfirm: "OK",
//       confirmTextColor: Colors.white,
//       buttonColor: Colors.red,
//       onConfirm: () => Get.back(),
//     );
//   }
//
//   // ⚠️ Warning Dialog
//   static warningDialog(String message) {
//     Get.defaultDialog(
//       title: "⚠️ Warning",
//       middleText: message,
//       backgroundColor: Colors.white,
//       titleStyle: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
//       middleTextStyle: const TextStyle(color: Colors.black87),
//       radius: 12,
//       textConfirm: "OK",
//       confirmTextColor: Colors.white,
//       buttonColor: Colors.orange,
//       onConfirm: () => Get.back(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDialog {
  // ==================== SUCCESS DIALOG (Same as before) ====================
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

  // ==================== ERROR DIALOG (Same as before) ====================
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

  // ==================== WARNING DIALOG (Same as before) ====================
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

  // ==================== MODERN & BEAUTIFUL DELETE DIALOG (New & Unique) ====================
  // ==================== MODERN & BEAUTIFUL DELETE DIALOG (Compact & Better) ====================
  static Future<bool?> DeleteDialog(String subjectName) async {
    return await Get.defaultDialog<bool>(
      title: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),   // Height kam ki
      backgroundColor: Colors.white,
      radius: 26,
      barrierDismissible: false,

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Red Danger Icon (thoda chhota kiya)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_forever_rounded,
              size: 46,                    // Size kam kiya
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 18),     // Spacing kam ki

          // Title
          const Text(
            "Delete Subject?",
            style: TextStyle(
              fontSize: 21.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Message (compact)
          Text(
            "Are you sure you want to permanently delete\n'$subjectName'?\nThis action cannot be undone.",
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 26),      // Buttons se pehle spacing

          // Buttons Row
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(result: false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Delete Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Yes, Delete",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}