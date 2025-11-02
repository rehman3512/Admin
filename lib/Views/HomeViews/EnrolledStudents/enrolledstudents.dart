// // import 'package:admin/Constants/AppColors/appcolors.dart';
// // import 'package:admin/Controllers/AdminController/admincontroller.dart';
// // import 'package:admin/Controllers/AuthController/authcontroller.dart';
// // import 'package:admin/Widgets/IsLoadind/isloading.dart';
// // import 'package:admin/Widgets/TextWidget/textwidget.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // class EnrolledStudents extends StatelessWidget {
// //   EnrolledStudents({super.key});
// //
// //   final authController = Get.find<AuthController>();
// //   final adminController = Get.find<AdminController>();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: AppColors.purpleColor,
// //         leading: IconButton(
// //           onPressed: () {
// //             Get.back();
// //           },
// //           icon: Icon(
// //             Icons.arrow_back_ios_new_outlined,
// //             color: AppColors.whiteColor,
// //           ),
// //         ),
// //         title: TextWidget.h2(
// //           "Enrolled Students",
// //           AppColors.whiteColor,
// //           context,
// //         ),
// //       ),
// //       backgroundColor: AppColors.whiteColor,
// //       body: SafeArea(
// //         child: StreamBuilder<QuerySnapshot>(
// //           stream: FirebaseFirestore.instance
// //               .collection("subjectForm")
// //               .doc(adminController.subjectIdController.text)
// //               .collection("enrollForm")
// //               .where("status", isEqualTo: "Approved")
// //               .snapshots(),
// //           builder: (context, snapshot) {
// //             if (!snapshot.hasData) {
// //               return IsLoading();
// //             }
// //
// //             final enrollDocs = snapshot.data!.docs;
// //
// //             if (enrollDocs.isEmpty) {
// //               return Center(
// //                 child: TextWidget.h2(
// //                   "No enrolled students",
// //                   AppColors.blackColor,
// //                   context,
// //                 ),
// //               );
// //             }
// //
// //             return ListView.builder(
// //               padding: EdgeInsets.all(10),
// //               itemCount: enrollDocs.length,
// //               itemBuilder: (context, index) {
// //                 final doc = enrollDocs[index];
// //                 final data = doc.data() as Map<String, dynamic>;
// //
// //                 final userName = data["userName"] ?? "Unknown";
// //                 String feesStatus = data["feesStatus"] ?? "notPaid";
// //
// //                 DateTime? approvedAt;
// //                 DateTime? feesPaidAt;
// //
// //                 if (data["approvedAt"] != null) {
// //                   approvedAt = (data["approvedAt"] as Timestamp).toDate();
// //                 }
// //                 if (data["feesPaidAt"] != null) {
// //                   feesPaidAt = (data["feesPaidAt"] as Timestamp).toDate();
// //                 }
// //
// //                 // ✅ 30 days check
// //                 if (approvedAt != null &&
// //                     DateTime.now().difference(approvedAt).inDays >= 30 &&
// //                     feesStatus != "paid") {
// //                   FirebaseFirestore.instance
// //                       .collection("subjectForm")
// //                       .doc(adminController.subjectIdController.text)
// //                       .collection("enrollForm")
// //                       .doc(doc.id)
// //                       .update({"feesStatus": "notPaid"});
// //                   feesStatus = "notPaid";
// //                 }
// //
// //                 // ✅ Date text
// //                 String dateText = "";
// //                 if (feesStatus == "paid" && feesPaidAt != null) {
// //                   dateText =
// //                   "Fee Submitted: ${feesPaidAt.day}-${feesPaidAt.month}-${feesPaidAt.year}";
// //                 } else if (approvedAt != null) {
// //                   dateText =
// //                   "Enrolled: ${approvedAt.day}-${approvedAt.month}-${approvedAt.year}";
// //                 }
// //
// //                 return Card(
// //                   child: ListTile(
// //                     title: TextWidget.h3(
// //                       userName,
// //                       AppColors.blackColor,
// //                       context,
// //                     ),
// //                     subtitle: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         TextWidget.h3(
// //                           "Fees Status: $feesStatus",
// //                           feesStatus == "paid"
// //                               ? Colors.green
// //                               : AppColors.redColor,
// //                           context,
// //                         ),
// //                         SizedBox(height: 4),
// //                         TextWidget.h3(
// //                           dateText,
// //                           AppColors.greyColor,
// //                           context,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// /// correct
// // import 'package:admin/Constants/AppColors/appcolors.dart';
// // import 'package:admin/Controllers/AdminController/admincontroller.dart';
// // import 'package:admin/Controllers/AuthController/authcontroller.dart';
// // import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// // import 'package:admin/Widgets/IsLoadind/isloading.dart';
// // import 'package:admin/Widgets/TextWidget/textwidget.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // class EnrolledStudents extends StatelessWidget {
// //   final String subjectId; // ✅ Subject ID as parameter
// //
// //   EnrolledStudents({super.key, required this.subjectId});
// //
// //   final authController = Get.find<AuthController>();
// //   final adminController = Get.find<AdminController>();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // ✅ Find the subject from subjectList using subjectId
// //     final subject = adminController.subjectList.firstWhere(
// //           (s) => s.id == subjectId,
// //       orElse: () => SubjectModel(
// //         subject: "Unknown Subject",
// //         id: "",
// //         subjectId: "",
// //         duration: "",
// //         classTime: "",
// //         registration: "",
// //         teacher: "",
// //       ),
// //     );
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: AppColors.purpleColor,
// //         leading: IconButton(
// //           onPressed: () {
// //             Get.back();
// //           },
// //           icon: Icon(
// //             Icons.arrow_back_ios_new_outlined,
// //             color: AppColors.whiteColor,
// //           ),
// //         ),
// //         title: TextWidget.h2(
// //           "Enrolled Students - ${subject.subject}",
// //           AppColors.whiteColor,
// //           context,
// //         ),
// //       ),
// //       backgroundColor: AppColors.whiteColor,
// //       body: SafeArea(
// //         child: StreamBuilder<QuerySnapshot>(
// //           stream: FirebaseFirestore.instance
// //               .collection("subjectForm")
// //               .doc(subjectId) // ✅ Use the subjectId parameter
// //               .collection("enrollForm")
// //               .where("status", isEqualTo: "Approved")
// //               .snapshots(),
// //           builder: (context, snapshot) {
// //             if (!snapshot.hasData) {
// //               return IsLoading();
// //             }
// //
// //             final enrollDocs = snapshot.data!.docs;
// //
// //             if (enrollDocs.isEmpty) {
// //               return Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Icon(Icons.people_outline, size: 60, color: Colors.grey),
// //                     SizedBox(height: 16),
// //                     TextWidget.h2(
// //                       "No enrolled students",
// //                       AppColors.blackColor,
// //                       context,
// //                     ),
// //                     TextWidget.h3(
// //                       "in ${subject.subject}",
// //                       AppColors.greyColor,
// //                       context,
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }
// //
// //             return ListView.builder(
// //               padding: EdgeInsets.all(10),
// //               itemCount: enrollDocs.length,
// //               itemBuilder: (context, index) {
// //                 final doc = enrollDocs[index];
// //                 final data = doc.data() as Map<String, dynamic>;
// //
// //                 final userName = data["userName"] ?? "Unknown";
// //                 String feesStatus = data["feesStatus"] ?? "notPaid";
// //
// //                 DateTime? approvedAt;
// //                 DateTime? feesPaidAt;
// //
// //                 if (data["approvedAt"] != null) {
// //                   approvedAt = (data["approvedAt"] as Timestamp).toDate();
// //                 }
// //                 if (data["feesPaidAt"] != null) {
// //                   feesPaidAt = (data["feesPaidAt"] as Timestamp).toDate();
// //                 }
// //
// //                 // ✅ 30 days check
// //                 if (approvedAt != null &&
// //                     DateTime.now().difference(approvedAt).inDays >= 30 &&
// //                     feesStatus != "paid") {
// //                   FirebaseFirestore.instance
// //                       .collection("subjectForm")
// //                       .doc(subjectId) // ✅ Use subjectId parameter
// //                       .collection("enrollForm")
// //                       .doc(doc.id)
// //                       .update({"feesStatus": "notPaid"});
// //                   feesStatus = "notPaid";
// //                 }
// //
// //                 // ✅ Date text
// //                 String dateText = "";
// //                 if (feesStatus == "paid" && feesPaidAt != null) {
// //                   dateText =
// //                   "Fee Submitted: ${feesPaidAt.day}-${feesPaidAt.month}-${feesPaidAt.year}";
// //                 } else if (approvedAt != null) {
// //                   dateText =
// //                   "Enrolled: ${approvedAt.day}-${approvedAt.month}-${approvedAt.year}";
// //                 }
// //
// //                 return Card(
// //                   child: ListTile(
// //                     title: TextWidget.h3(
// //                       userName,
// //                       AppColors.blackColor,
// //                       context,
// //                     ),
// //                     subtitle: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         TextWidget.h3(
// //                           "Fees Status: $feesStatus",
// //                           feesStatus == "paid"
// //                               ? Colors.green
// //                               : AppColors.redColor,
// //                           context,
// //                         ),
// //                         SizedBox(height: 4),
// //                         TextWidget.h3(
// //                           dateText,
// //                           AppColors.greyColor,
// //                           context,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
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
//   final String subjectId;
//
//   EnrolledStudents({super.key, required this.subjectId});
//
//   final authController = Get.find<AuthController>();
//   final adminController = Get.find<AdminController>();
//
//   @override
//   Widget build(BuildContext context) {
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
//               .doc(subjectId)
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
//                 final userFatherName = data["userFatherName"] ?? "Not Available";
//                 final userEmail = data["userEmail"] ?? "No Email";
//                 String feesStatus = data["feesStatus"] ?? "notPaid";
//
//                 DateTime? approvedAt;
//                 DateTime? feesPaidAt;
//                 DateTime? enrolledAt;
//
//                 // ✅ All dates check karen
//                 if (data["approvedAt"] != null) {
//                   approvedAt = (data["approvedAt"] as Timestamp).toDate();
//                 }
//                 if (data["feesPaidAt"] != null) {
//                   feesPaidAt = (data["feesPaidAt"] as Timestamp).toDate();
//                 }
//                 if (data["enrolledAt"] != null) {
//                   enrolledAt = (data["enrolledAt"] as Timestamp).toDate();
//                 }
//
//                 // ✅ TIMER CALCULATION - YEH IMPORTANT HAI
//                 String timerText = "";
//                 Color timerColor = Colors.green;
//                 DateTime? displayDate;
//                 String dateLabel = "";
//
//                 // ✅ Fee paid date priority mein (latest fee payment)
//                 if (feesPaidAt != null) {
//                   displayDate = feesPaidAt;
//                   dateLabel = "Fee Paid";
//                 }
//                 // ✅ Agar fee paid nahi hai toh enrollment approved date
//                 else if (approvedAt != null) {
//                   displayDate = approvedAt;
//                   dateLabel = "Enrolled";
//                 }
//                 // ✅ Agar kuch nahi hai toh enrolledAt
//                 else if (enrolledAt != null) {
//                   displayDate = enrolledAt;
//                   dateLabel = "Enrolled";
//                 }
//
//                 // ✅ TIMER FORMAT: 1/30, 2/30, ... 30/30
//                 if (displayDate != null) {
//                   final totalDays = DateTime.now().difference(displayDate).inDays;
//
//                   // ✅ 30 days cycle: totalDays % 30
//                   final currentDayInCycle = (totalDays % 30) + 1;
//
//                   timerText = "$currentDayInCycle/30";
//
//                   // ✅ Colors based on days
//                   if (currentDayInCycle <= 20) {
//                     timerColor = Colors.green;
//                   } else if (currentDayInCycle <= 27) {
//                     timerColor = Colors.orange;
//                   } else {
//                     timerColor = Colors.red;
//                   }
//
//                   // ✅ Agar 30 days complete hue hain aur fees paid hai, toh auto update
//                   if (totalDays >= 30 && feesStatus == "Paid") {
//                     FirebaseFirestore.instance
//                         .collection("subjectForm")
//                         .doc(subjectId)
//                         .collection("enrollForm")
//                         .doc(doc.id)
//                         .update({
//                       "feesStatus": "notPaid",
//                       "feesPaidAt": null // Reset fees paid date
//                     });
//                   }
//                 } else {
//                   timerText = "0/30";
//                   timerColor = Colors.grey;
//                 }
//
//                 // ✅ Date text for display
//                 String dateText = "";
//                 if (displayDate != null) {
//                   dateText = "$dateLabel: ${displayDate.day}-${displayDate.month}-${displayDate.year}";
//                 }
//
//                 return Card(
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: AppColors.purpleColor,
//                       child: Text(
//                         userName[0],
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextWidget.h3(userName, AppColors.blackColor, context),
//                         SizedBox(height: 2),
//                         TextWidget.h3("Father: $userFatherName", AppColors.greyColor, context),
//                         SizedBox(height: 2),
//                         TextWidget.h3(userEmail, AppColors.greyColor, context),
//                       ],
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             TextWidget.h3("Fees: ", AppColors.greyColor, context),
//                             TextWidget.h3(
//                               feesStatus,
//                               feesStatus == "Paid" ? Colors.green : AppColors.redColor,
//                               context,
//                             ),
//                             Spacer(),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: timerColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(15),
//                                 border: Border.all(color: timerColor),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.timer, size: 14, color: timerColor),
//                                   SizedBox(width: 4),
//                                   TextWidget.h3(
//                                     timerText,
//                                     timerColor,
//                                     context,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4),
//                         if (dateText.isNotEmpty)
//                           TextWidget.h3(dateText, AppColors.greyColor, context),
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



// correct version
// import 'dart:ui';
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Controllers/AuthController/authcontroller.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Widgets/IsLoadind/isloading.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class EnrolledStudents extends StatelessWidget {
//   final String subjectId;
//
//   EnrolledStudents({super.key, required this.subjectId});
//
//   final authController = Get.find<AuthController>();
//   final adminController = Get.find<AdminController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final subject = adminController.subjectList.firstWhere(
//           (s) => s.id == subjectId,
//       orElse: () => SubjectModel(
//         subject: "Unknown Subject",
//         id: "", subjectId: "", duration: "", classTime: "", registration: "", teacher: "",
//       ),
//     );
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.purpleColor,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
//         ),
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor),
//         ),
//         title: Text(
//           "Enrolled Students",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w700,
//             color: AppColors.whiteColor,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Container(
//             padding: const EdgeInsets.only(bottom: 14),
//             child: Text(
//               subject.subject,
//               style: GoogleFonts.poppins(
//                 fontSize: 15,
//                 color: AppColors.whiteColor.withOpacity(0.92),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
//         color: AppColors.purpleColor,
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("subjectForm")
//               .doc(subjectId)
//               .collection("enrollForm")
//               .where("status", isEqualTo: "Approved")
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: IsLoading());
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return _buildModernEmptyState(subject.subject);
//             }
//
//             final docs = snapshot.data!.docs;
//
//             return ListView.builder(
//               padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
//               itemCount: docs.length,
//               itemBuilder: (context, index) {
//                 final doc = docs[index];
//                 final data = doc.data() as Map<String, dynamic>;
//
//                 return _buildGlassCard(context, data, doc.id, subjectId, index);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGlassCard(
//       BuildContext context, Map<String, dynamic> data, String docId, String subjectId, int index) {
//     final userName = data["userName"] ?? "Unknown";
//     final userFatherName = data["userFatherName"] ?? "Not Available";
//     final userEmail = data["userEmail"] ?? "No Email";
//     String feesStatus = (data["feesStatus"] ?? "notPaid").toString().toLowerCase();
//
//     DateTime? approvedAt = _parseTimestamp(data["approvedAt"]);
//     DateTime? feesPaidAt = _parseTimestamp(data["feesPaidAt"]);
//     DateTime? enrolledAt = _parseTimestamp(data["enrolledAt"]);
//
//     DateTime? displayDate = feesPaidAt ?? approvedAt ?? enrolledAt;
//     String dateLabel = feesPaidAt != null ? "Fee Paid" : "Enrolled";
//
//     String timerText = "0/30";
//     Color timerColor = AppColors.greyColor;
//     double progress = 0.0;
//
//     if (displayDate != null) {
//       final totalDays = DateTime.now().difference(displayDate).inDays;
//       final currentDay = (totalDays % 30) + 1;
//       timerText = "$currentDay/30";
//       progress = currentDay / 30;
//
//       if (currentDay <= 20) {
//         timerColor = AppColors.greenColor;
//       } else if (currentDay <= 27) {
//         timerColor = const Color(0xFFFF9800);
//       } else {
//         timerColor = AppColors.redColor;
//       }
//
//       if (totalDays >= 30 && feesStatus == "paid") {
//         FirebaseFirestore.instance
//             .collection("subjectForm")
//             .doc(subjectId)
//             .collection("enrollForm")
//             .doc(docId)
//             .update({"feesStatus": "notPaid", "feesPaidAt": null});
//         feesStatus = "notPaid";
//       }
//     }
//
//     return TweenAnimationBuilder(
//       duration: Duration(milliseconds: 500 + (index * 100)),
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, 60 * (1 - value)),
//           child: Opacity(opacity: value, child: child),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         child: Stack(
//           children: [
//             // Glassmorphic Card
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(28),
//                 gradient: LinearGradient(
//                   colors: [AppColors.cardGradient1, AppColors.cardGradient2],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.shadowColor,
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(28),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(
//                     color: AppColors.glassBg,
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Name + Icon
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: AppColors.purpleColor.withOpacity(0.25),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(Icons.person_rounded, size: 22, color: AppColors.purpleColor),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Text(
//                                 userName,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: AppColors.accentPurple,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 18),
//                         Divider(color: AppColors.dividerColor, thickness: 1.2),
//
//                         // Father
//                         _infoRow(Icons.person_outline, "Father's Name", userFatherName),
//                         const SizedBox(height: 12),
//
//                         // Email
//                         _infoRow(Icons.alternate_email, "Email", userEmail),
//                         const SizedBox(height: 20),
//
//                         // Fees + Timer
//                         Row(
//                           children: [
//                             // Fees Badge
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.badgeBg,
//                                   borderRadius: BorderRadius.circular(30),
//                                   border: Border.all(
//                                     color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       feesStatus == "paid" ? Icons.check_circle_rounded : Icons.pending,
//                                       size: 18,
//                                       color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       feesStatus == "paid" ? "PAID" : "PENDING",
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w700,
//                                         color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             const SizedBox(width: 16),
//
//                             // Circular Timer
//                             SizedBox(
//                               width: 70,
//                               height: 70,
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 70,
//                                     height: 70,
//                                     child: CircularProgressIndicator(
//                                       value: progress,
//                                       strokeWidth: 6,
//                                       backgroundColor: AppColors.greyColor.withOpacity(0.2),
//                                       valueColor: AlwaysStoppedAnimation(timerColor),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 54,
//                                     height: 54,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.whiteColor,
//                                       boxShadow: [
//                                         BoxShadow(color: AppColors.shadowColor, blurRadius: 8),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         timerText,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w800,
//                                           color: timerColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         // Date
//                         if (displayDate != null) ...[
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Icon(Icons.event_available_rounded, size: 16, color: AppColors.greyColor),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "$dateLabel on ${_formatDate(displayDate)}",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 12.5,
//                                   color: AppColors.greyColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Floating badge (optional flair)
//             Positioned(
//               top: 12,
//               right: 12,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: AppColors.purpleColor,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 6)],
//                 ),
//                 child: Text(
//                   "#${index + 1}",
//                   style: GoogleFonts.poppins(fontSize: 11, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 18, color: AppColors.accentPurple),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(fontSize: 12, color: AppColors.greyColor, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: GoogleFonts.poppins(fontSize: 14.5, color: AppColors.blackColor, fontWeight: FontWeight.w600),
//                 softWrap: true,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildModernEmptyState(String subjectName) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(32),
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [AppColors.purpleColor.withOpacity(0.15), AppColors.transparentColor],
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.school_outlined, size: 80, color: AppColors.purpleColor),
//             ),
//             const SizedBox(height: 32),
//             Text(
//               "No Students Yet",
//               style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accentPurple),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               "in $subjectName",
//               style: GoogleFonts.poppins(fontSize: 16, color: AppColors.greyColor),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Approved enrollments will appear here with live timer.",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(fontSize: 14, color: AppColors.greyColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   DateTime? _parseTimestamp(dynamic t) => t is Timestamp ? t.toDate() : null;
//   String _formatDate(DateTime d) => "${d.day} ${_monthName(d.month)} ${d.year}";
//   String _monthName(int m) => ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][m - 1];
// }




//
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Controllers/AuthController/authcontroller.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Widgets/IsLoadind/isloading.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class EnrolledStudents extends StatelessWidget {
//   final String subjectId;
//
//   EnrolledStudents({super.key, required this.subjectId});
//
//   final authController = Get.find<AuthController>();
//   final adminController = Get.find<AdminController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final subject = adminController.subjectList.firstWhere(
//           (s) => s.id == subjectId,
//       orElse: () => SubjectModel(
//         subject: "Unknown Subject",
//         id: "", subjectId: "", duration: "", classTime: "", registration: "", teacher: "",
//       ),
//     );
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.purpleColor,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
//         ),
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor),
//         ),
//         title: Text(
//           "Enrolled Students",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w700,
//             color: AppColors.whiteColor,
//             fontSize: 19,
//           ),
//         ),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               subject.subject,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: AppColors.whiteColor.withOpacity(0.9),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
//         color: AppColors.purpleColor,
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("subjectForm")
//               .doc(subjectId)
//               .collection("enrollForm")
//               .where("status", isEqualTo: "Approved")
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: IsLoading());
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return _buildCompactEmptyState(subject.subject);
//             }
//
//             final docs = snapshot.data!.docs;
//
//             return ListView.builder(
//               padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
//               itemCount: docs.length,
//               itemBuilder: (context, index) {
//                 final doc = docs[index];
//                 final data = doc.data() as Map<String, dynamic>;
//
//                 return _buildCompactCard(context, data, doc.id, subjectId, index);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCompactCard(
//       BuildContext context, Map<String, dynamic> data, String docId, String subjectId, int index) {
//     final userName = data["userName"] ?? "Unknown";
//     final userFatherName = data["userFatherName"] ?? "Not Available";
//     final userEmail = data["userEmail"] ?? "No Email";
//     String feesStatus = (data["feesStatus"] ?? "notPaid").toString().toLowerCase();
//
//     DateTime? approvedAt = _parseTimestamp(data["approvedAt"]);
//     DateTime? feesPaidAt = _parseTimestamp(data["feesPaidAt"]);
//     DateTime? enrolledAt = _parseTimestamp(data["enrolledAt"]);
//
//     DateTime? displayDate = feesPaidAt ?? approvedAt ?? enrolledAt;
//     String dateLabel = feesPaidAt != null ? "Fee Paid" : "Enrolled";
//
//     String timerText = "0/30";
//     Color timerColor = AppColors.greyColor;
//     double progress = 0.0;
//
//     if (displayDate != null) {
//       final totalDays = DateTime.now().difference(displayDate).inDays;
//       final currentDay = (totalDays % 30) + 1;
//       timerText = "$currentDay/30";
//       progress = currentDay / 30;
//
//       if (currentDay <= 20) {
//         timerColor = AppColors.greenColor;
//       } else if (currentDay <= 27) {
//         timerColor = const Color(0xFFFF9800);
//       } else {
//         timerColor = AppColors.redColor;
//       }
//
//       if (totalDays >= 30 && feesStatus == "paid") {
//         FirebaseFirestore.instance
//             .collection("subjectForm")
//             .doc(subjectId)
//             .collection("enrollForm")
//             .doc(docId)
//             .update({"feesStatus": "notPaid", "feesPaidAt": null});
//         feesStatus = "notPaid";
//       }
//     }
//
//     return TweenAnimationBuilder(
//       duration: Duration(milliseconds: 400 + (index * 80)),
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, 40 * (1 - value)),
//           child: Opacity(opacity: value, child: child),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         child: Card(
//           elevation: 0,
//           color: AppColors.cardBg,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: BorderSide(color: AppColors.borderColor, width: 1.4),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Compact padding
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name + Timer
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: AppColors.purpleColor.withOpacity(0.18),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.person_rounded, size: 18, color: AppColors.purpleColor),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         userName,
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textDark,
//                         ),
//                       ),
//                     ),
//                     // Compact Timer
//                     SizedBox(
//                       width: 52,
//                       height: 52,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SizedBox(
//                             width: 52,
//                             height: 52,
//                             child: CircularProgressIndicator(
//                               value: progress,
//                               strokeWidth: 4.5,
//                               backgroundColor: AppColors.greyColor.withOpacity(0.2),
//                               valueColor: AlwaysStoppedAnimation(timerColor),
//                             ),
//                           ),
//                           Text(
//                             timerText.split('/')[0],
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w800,
//                               color: timerColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Father & Email
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _infoRow(Icons.person_outline, "Father", userFatherName),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _infoRow(Icons.alternate_email, "Email", userEmail),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Fees + Date
//                 Row(
//                   children: [
//                     // Fees Badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: AppColors.badgeBg,
//                         borderRadius: BorderRadius.circular(30),
//                         border: Border.all(
//                           color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
//                           width: 1.6,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             feesStatus == "paid" ? Icons.check : Icons.close,
//                             size: 13,
//                             color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             feesStatus == "paid" ? "PAID" : "PENDING",
//                             style: GoogleFonts.poppins(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                               color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const Spacer(),
//
//                     // Enrolled Date (Dark Color)
//                     if (displayDate != null)
//                       Text(
//                         "$dateLabel: ${_formatDate(displayDate)}",
//                         style: GoogleFonts.poppins(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textDark, // DARK COLOR
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 15, color: AppColors.labelColor),
//             const SizedBox(width: 6),
//             Text(
//               "$label:",
//               style: GoogleFonts.poppins(fontSize: 11, color: AppColors.labelColor, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: GoogleFonts.poppins(fontSize: 13, color: AppColors.blackColor, fontWeight: FontWeight.w500),
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCompactEmptyState(String subjectName) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: AppColors.cardBg,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: AppColors.borderColor, width: 2),
//               ),
//               child: Icon(Icons.people_alt_outlined, size: 56, color: AppColors.purpleColor),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "No Students",
//               style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textDark),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "in $subjectName",
//               style: GoogleFonts.poppins(fontSize: 15, color: AppColors.greyColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   DateTime? _parseTimestamp(dynamic t) => t is Timestamp ? t.toDate() : null;
//   String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
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
import 'package:google_fonts/google_fonts.dart';

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
        id: "", subjectId: "", duration: "", classTime: "", registration: "", teacher: "",
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor),
        ),
        title: Text(
          "Enrolled Students",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              subject.subject,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.whiteColor.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
        color: AppColors.purpleColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subjectForm")
              .doc(subjectId)
              .collection("enrollForm")
              .where("status", isEqualTo: "Approved")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: IsLoading());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildCompactEmptyState(subject.subject);
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                return _buildCompactCard(context, data, doc.id, subjectId, index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompactCard(
      BuildContext context, Map<String, dynamic> data, String docId, String subjectId, int index) {
    final userName = data["userName"] ?? "Unknown";
    final userFatherName = data["userFatherName"] ?? "Not Available";
    final userEmail = data["userEmail"] ?? "No Email";
    String feesStatus = (data["feesStatus"] ?? "notPaid").toString().toLowerCase();

    DateTime? approvedAt = _parseTimestamp(data["approvedAt"]);
    DateTime? feesPaidAt = _parseTimestamp(data["feesPaidAt"]);
    DateTime? enrolledAt = _parseTimestamp(data["enrolledAt"]);

    DateTime? displayDate = feesPaidAt ?? approvedAt ?? enrolledAt;
    String dateLabel = feesPaidAt != null ? "Fee Paid" : "Enrolled";

    String timerText = "0/30";
    Color timerColor = AppColors.greyColor;
    double progress = 0.0;

    if (displayDate != null) {
      final totalDays = DateTime.now().difference(displayDate).inDays;
      final currentDay = (totalDays % 30) + 1;
      timerText = "$currentDay/30";  // ← 1/30, 15/30 format
      progress = currentDay / 30;

      if (currentDay <= 20) {
        timerColor = AppColors.greenColor;
      } else if (currentDay <= 27) {
        timerColor = const Color(0xFFFF9800);
      } else {
        timerColor = AppColors.redColor;
      }

      if (totalDays >= 30 && feesStatus == "paid") {
        FirebaseFirestore.instance
            .collection("subjectForm")
            .doc(subjectId)
            .collection("enrollForm")
            .doc(docId)
            .update({"feesStatus": "notPaid", "feesPaidAt": null});
        feesStatus = "notPaid";
      }
    }

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 80)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        child: Card(
          elevation: 0,
          color: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.borderColor, width: 1.4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Timer
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.purpleColor.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_rounded, size: 18, color: AppColors.purpleColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        userName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    // Timer with 1/30 format
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 4.8,
                              backgroundColor: AppColors.greyColor.withOpacity(0.22),
                              valueColor: AlwaysStoppedAnimation(timerColor),
                            ),
                          ),
                          Text(
                            timerText, // ← 1/30, 15/30, 30/30
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: timerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Father & Email (Side by Side)
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(Icons.person_outline, "Father", userFatherName),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoRow(Icons.alternate_email, "Email", userEmail),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Fees + Enrolled Date
                Row(
                  children: [
                    // Fees Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.badgeBg,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
                          width: 1.6,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            feesStatus == "paid" ? Icons.check : Icons.close,
                            size: 13,
                            color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            feesStatus == "paid" ? "PAID" : "PENDING",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Enrolled Date (DARK COLOR)
                    if (displayDate != null)
                      Text(
                        "$dateLabel: ${_formatDate(displayDate)}",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark, // DARK & CLEAR
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColors.labelColor),
            const SizedBox(width: 6),
            Text(
              "$label:",
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.labelColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.blackColor, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildCompactEmptyState(String subjectName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderColor, width: 2),
              ),
              child: Icon(Icons.people_alt_outlined, size: 56, color: AppColors.purpleColor),
            ),
            const SizedBox(height: 24),
            Text(
              "No Students",
              style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              "in $subjectName",
              style: GoogleFonts.poppins(fontSize: 15, color: AppColors.greyColor),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseTimestamp(dynamic t) => t is Timestamp ? t.toDate() : null;
  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
}