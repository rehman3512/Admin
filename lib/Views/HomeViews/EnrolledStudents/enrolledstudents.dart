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


/// correct
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Controllers/AuthController/authcontroller.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Widgets/IsLoadind/isloading.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class EnrolledStudents extends StatelessWidget {
//   final String subjectId; // ✅ Subject ID as parameter
//
//   EnrolledStudents({super.key, required this.subjectId});
//
//   final authController = Get.find<AuthController>();
//   final adminController = Get.find<AdminController>();
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Find the subject from subjectList using subjectId
//     final subject = adminController.subjectList.firstWhere(
//           (s) => s.id == subjectId,
//       orElse: () => SubjectModel(
//         subject: "Unknown Subject",
//         id: "",
//         subjectId: "",
//         duration: "",
//         classTime: "",
//         registration: "",
//         teacher: "",
//       ),
//     );
//
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
//           "Enrolled Students - ${subject.subject}",
//           AppColors.whiteColor,
//           context,
//         ),
//       ),
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("subjectForm")
//               .doc(subjectId) // ✅ Use the subjectId parameter
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
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.people_outline, size: 60, color: Colors.grey),
//                     SizedBox(height: 16),
//                     TextWidget.h2(
//                       "No enrolled students",
//                       AppColors.blackColor,
//                       context,
//                     ),
//                     TextWidget.h3(
//                       "in ${subject.subject}",
//                       AppColors.greyColor,
//                       context,
//                     ),
//                   ],
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
//                       .doc(subjectId) // ✅ Use subjectId parameter
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
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnrolledStudents extends StatelessWidget {
  final String subjectId;

  EnrolledStudents({super.key, required this.subjectId});

  final authController = Get.find<AuthController>();
  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    final subject = adminController.subjectList.firstWhere(
          (s) => s.id == subjectId,
      orElse: () => SubjectModel(
        subject: "Unknown Subject",
        id: "",
        subjectId: "",
        duration: "",
        classTime: "",
        registration: "",
        teacher: "",
      ),
    );

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
          "Enrolled Students - ${subject.subject}",
          AppColors.whiteColor,
          context,
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subjectForm")
              .doc(subjectId)
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
                      "in ${subject.subject}",
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
                final userFatherName = data["userFatherName"] ?? "Not Available";
                final userEmail = data["userEmail"] ?? "No Email";
                String feesStatus = data["feesStatus"] ?? "notPaid";

                DateTime? approvedAt;
                DateTime? feesPaidAt;
                DateTime? enrolledAt;

                // ✅ All dates check karen
                if (data["approvedAt"] != null) {
                  approvedAt = (data["approvedAt"] as Timestamp).toDate();
                }
                if (data["feesPaidAt"] != null) {
                  feesPaidAt = (data["feesPaidAt"] as Timestamp).toDate();
                }
                if (data["enrolledAt"] != null) {
                  enrolledAt = (data["enrolledAt"] as Timestamp).toDate();
                }

                // ✅ TIMER CALCULATION - YEH IMPORTANT HAI
                String timerText = "";
                Color timerColor = Colors.green;
                DateTime? displayDate;
                String dateLabel = "";

                // ✅ Fee paid date priority mein (latest fee payment)
                if (feesPaidAt != null) {
                  displayDate = feesPaidAt;
                  dateLabel = "Fee Paid";
                }
                // ✅ Agar fee paid nahi hai toh enrollment approved date
                else if (approvedAt != null) {
                  displayDate = approvedAt;
                  dateLabel = "Enrolled";
                }
                // ✅ Agar kuch nahi hai toh enrolledAt
                else if (enrolledAt != null) {
                  displayDate = enrolledAt;
                  dateLabel = "Enrolled";
                }

                // ✅ TIMER FORMAT: 1/30, 2/30, ... 30/30
                if (displayDate != null) {
                  final totalDays = DateTime.now().difference(displayDate).inDays;

                  // ✅ 30 days cycle: totalDays % 30
                  final currentDayInCycle = (totalDays % 30) + 1;

                  timerText = "$currentDayInCycle/30";

                  // ✅ Colors based on days
                  if (currentDayInCycle <= 20) {
                    timerColor = Colors.green;
                  } else if (currentDayInCycle <= 27) {
                    timerColor = Colors.orange;
                  } else {
                    timerColor = Colors.red;
                  }

                  // ✅ Agar 30 days complete hue hain aur fees paid hai, toh auto update
                  if (totalDays >= 30 && feesStatus == "Paid") {
                    FirebaseFirestore.instance
                        .collection("subjectForm")
                        .doc(subjectId)
                        .collection("enrollForm")
                        .doc(doc.id)
                        .update({
                      "feesStatus": "notPaid",
                      "feesPaidAt": null // Reset fees paid date
                    });
                  }
                } else {
                  timerText = "0/30";
                  timerColor = Colors.grey;
                }

                // ✅ Date text for display
                String dateText = "";
                if (displayDate != null) {
                  dateText = "$dateLabel: ${displayDate.day}-${displayDate.month}-${displayDate.year}";
                }

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.purpleColor,
                      child: Text(
                        userName[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget.h3(userName, AppColors.blackColor, context),
                        SizedBox(height: 2),
                        TextWidget.h3("Father: $userFatherName", AppColors.greyColor, context),
                        SizedBox(height: 2),
                        TextWidget.h3(userEmail, AppColors.greyColor, context),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          children: [
                            TextWidget.h3("Fees: ", AppColors.greyColor, context),
                            TextWidget.h3(
                              feesStatus,
                              feesStatus == "Paid" ? Colors.green : AppColors.redColor,
                              context,
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: timerColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: timerColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer, size: 14, color: timerColor),
                                  SizedBox(width: 4),
                                  TextWidget.h3(
                                    timerText,
                                    timerColor,
                                    context,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (dateText.isNotEmpty)
                          TextWidget.h3(dateText, AppColors.greyColor, context),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}