// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Controllers/AuthController/authcontroller.dart';
// import 'package:admin/Widgets/IsLoadind/isloading.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class EnrolledStudents extends StatelessWidget {
//   EnrolledStudents({super.key});
//
//   final authController = Get.find<AuthController>();
//   final adminController = Get.find<AdminController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.purpleColor,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_outlined,
//             color: AppColors.whiteColor,
//           ),
//         ),
//         title: TextWidget.h2(
//           "Enrolled Students",
//           AppColors.whiteColor,
//           context,
//         ),
//       ),
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("subjectForm")
//               .doc(adminController.subjectIdController.text)
//               .collection("enrollForm")
//               .where("status", isEqualTo: "Approved")
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return IsLoading();
//             }
//
//             final enrollDocs = snapshot.data!.docs;
//
//             if (enrollDocs.isEmpty) {
//               return Center(
//                 child: TextWidget.h2(
//                   "No enrolled students",
//                   AppColors.blackColor,
//                   context,
//                 ),
//               );
//             }
//
//             return ListView.builder(
//               padding: EdgeInsets.all(10),
//               itemCount: enrollDocs.length,
//               itemBuilder: (context, index) {
//                 final doc = enrollDocs[index];
//                 final data = doc.data() as Map<String, dynamic>;
//
//                 final userName = data["userName"] ?? "Unknown";
//                 String feesStatus = data["feesStatus"] ?? "notPaid";
//
//                 DateTime? approvedAt;
//                 DateTime? feesPaidAt;
//
//                 if (data["approvedAt"] != null) {
//                   approvedAt = (data["approvedAt"] as Timestamp).toDate();
//                 }
//                 if (data["feesPaidAt"] != null) {
//                   feesPaidAt = (data["feesPaidAt"] as Timestamp).toDate();
//                 }
//
//                 // ✅ 30 days check
//                 if (approvedAt != null &&
//                     DateTime.now().difference(approvedAt).inDays >= 30 &&
//                     feesStatus != "paid") {
//                   FirebaseFirestore.instance
//                       .collection("subjectForm")
//                       .doc(adminController.subjectIdController.text)
//                       .collection("enrollForm")
//                       .doc(doc.id)
//                       .update({"feesStatus": "notPaid"});
//                   feesStatus = "notPaid";
//                 }
//
//                 // ✅ Date text
//                 String dateText = "";
//                 if (feesStatus == "paid" && feesPaidAt != null) {
//                   dateText =
//                   "Fee Submitted: ${feesPaidAt.day}-${feesPaidAt.month}-${feesPaidAt.year}";
//                 } else if (approvedAt != null) {
//                   dateText =
//                   "Enrolled: ${approvedAt.day}-${approvedAt.month}-${approvedAt.year}";
//                 }
//
//                 return Card(
//                   child: ListTile(
//                     title: TextWidget.h3(
//                       userName,
//                       AppColors.blackColor,
//                       context,
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextWidget.h3(
//                           "Fees Status: $feesStatus",
//                           feesStatus == "paid"
//                               ? Colors.green
//                               : AppColors.redColor,
//                           context,
//                         ),
//                         SizedBox(height: 4),
//                         TextWidget.h3(
//                           dateText,
//                           AppColors.greyColor,
//                           context,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnrolledStudents extends StatelessWidget {
  EnrolledStudents({super.key});

  final authController = Get.find<AuthController>();
  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.whiteColor,
          ),
        ),
        title: TextWidget.h2(
          adminController.selectedSubject.value != null
              ? "Enrolled Students - ${adminController.selectedSubject.value!.subject}"
              : "Enrolled Students",
          AppColors.whiteColor,
          context,
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: adminController.selectedSubject.value == null
            ? _buildNoSubjectSelected()
            : _buildStudentList(),
      ),
    );
  }

  Widget _buildNoSubjectSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          TextWidget.h2("No Subject Selected", AppColors.greyColor, Get.context!),
          TextWidget.h3("Please select a subject first", AppColors.greyColor, Get.context!),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("Go Back"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(adminController.selectedSubject.value!.id)
          .collection("enrollForm")
          .where("status", isEqualTo: "Approved")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return IsLoading();
        }

        final enrollDocs = snapshot.data!.docs;

        if (enrollDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                TextWidget.h2(
                  "No enrolled students",
                  AppColors.blackColor,
                  context,
                ),
                TextWidget.h3(
                  "in ${adminController.selectedSubject.value!.subject}",
                  AppColors.greyColor,
                  context,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: enrollDocs.length,
          itemBuilder: (context, index) {
            final doc = enrollDocs[index];
            final data = doc.data() as Map<String, dynamic>;

            final userName = data["userName"] ?? "Unknown";
            String feesStatus = data["feesStatus"] ?? "notPaid";

            DateTime? approvedAt;
            DateTime? feesPaidAt;

            if (data["approvedAt"] != null) {
              approvedAt = (data["approvedAt"] as Timestamp).toDate();
            }
            if (data["feesPaidAt"] != null) {
              feesPaidAt = (data["feesPaidAt"] as Timestamp).toDate();
            }

            // ✅ 30 days check
            if (approvedAt != null &&
                DateTime.now().difference(approvedAt).inDays >= 30 &&
                feesStatus != "paid") {
              FirebaseFirestore.instance
                  .collection("subjectForm")
                  .doc(adminController.selectedSubject.value!.id)
                  .collection("enrollForm")
                  .doc(doc.id)
                  .update({"feesStatus": "notPaid"});
              feesStatus = "notPaid";
            }

            // ✅ Date text
            String dateText = "";
            if (feesStatus == "paid" && feesPaidAt != null) {
              dateText = "Fee Submitted: ${feesPaidAt.day}-${feesPaidAt.month}-${feesPaidAt.year}";
            } else if (approvedAt != null) {
              dateText = "Enrolled: ${approvedAt.day}-${approvedAt.month}-${approvedAt.year}";
            }

            return Card(
              child: ListTile(
                title: TextWidget.h3(
                  userName,
                  AppColors.blackColor,
                  context,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget.h3(
                      "Fees Status: $feesStatus",
                      feesStatus == "paid"
                          ? Colors.green
                          : AppColors.redColor,
                      context,
                    ),
                    SizedBox(height: 4),
                    TextWidget.h3(
                      dateText,
                      AppColors.greyColor,
                      context,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}