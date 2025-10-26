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
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EnrolledStudents extends StatelessWidget {
  final SubjectModel subject;

  EnrolledStudents({super.key}) : subject = Get.arguments as SubjectModel;

  final adminController = Get.find<AdminController>();

  // Fees Status Badge
  Widget _buildFeesBadge(String status) {
    final bool isPaid = status == "paid";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isPaid ? Colors.green.shade700 : Colors.red.shade700,
          ),
          SizedBox(width: 4),
          Text(
            isPaid ? "Paid" : "Not Paid",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isPaid ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Detail Row
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.purpleColor.withOpacity(0.7)),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13.5),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor ?? Colors.black87, fontSize: 13.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safe check
    if (subject.id.isEmpty || subject.subject.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("Invalid Subject")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.purpleColor, AppColors.purpleColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget.h2("Enrolled Students", Colors.white, context),
            Text(
              subject.subject,
              style: TextStyle(fontSize: 14, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.purpleColor.withOpacity(0.05), Colors.white],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subjectForm")
              .doc(subject.id)
              .collection("enrollForm")
              .where("status", isEqualTo: "Approved")
              .snapshots(),
          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.purpleColor),
                    SizedBox(height: 16),
                    Text("Loading students...", style: TextStyle(color: AppColors.purpleColor)),
                  ],
                ),
              );
            }

            // Empty
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey.shade400),
                    SizedBox(height: 16),
                    TextWidget.h2("No Enrolled Students", Colors.grey.shade600, context),
                    Text("Students will appear after approval", style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                final name = data['userName'] ?? 'Unknown';
                final email = data['userEmail'] ?? 'N/A';
                final phone = data['userPhone'] ?? 'N/A';
                final feesStatus = data['feesStatus'] ?? 'notPaid';

                // Dates
                String dateText = "Enrolled: N/A";
                if (data['acceptedAt'] != null) {
                  final Timestamp ts = data['acceptedAt'];
                  dateText = "Enrolled: ${DateFormat('dd MMM yyyy').format(ts.toDate())}";
                }
                if (feesStatus == "paid" && data['feesPaidAt'] != null) {
                  final Timestamp ts = data['feesPaidAt'];
                  dateText = "Paid: ${DateFormat('dd MMM yyyy').format(ts.toDate())}";
                }

                // Auto update notPaid after 30 days
                if (data['acceptedAt'] != null && feesStatus != "paid") {
                  final acceptedAt = (data['acceptedAt'] as Timestamp).toDate();
                  if (DateTime.now().difference(acceptedAt).inDays >= 30) {
                    FirebaseFirestore.instance
                        .collection("subjectForm")
                        .doc(subject.id)
                        .collection("enrollForm")
                        .doc(doc.id)
                        .update({"feesStatus": "notPaid"});
                  }
                }

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(20),
                    shadowColor: AppColors.purpleColor.withOpacity(0.2),
                    child: Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextWidget.h3(name, AppColors.purpleColor, context, ),
                              ),
                              _buildFeesBadge(feesStatus),
                            ],
                          ),
                          SizedBox(height: 14),

                          // Details
                          _buildDetailRow(Icons.person, "Name", name),
                          _buildDetailRow(Icons.email, "Email", email),
                          _buildDetailRow(Icons.phone, "Phone", phone),
                          _buildDetailRow(
                            Icons.calendar_today,
                            "Date",
                            dateText,
                            valueColor: feesStatus == "paid" ? Colors.green.shade700 : Colors.grey.shade600,
                          ),

                          // 30+ days warning
                          if (feesStatus == "notPaid" && data['acceptedAt'] != null)
                            if (DateTime.now().difference((data['acceptedAt'] as Timestamp).toDate()).inDays >= 30)
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.orange.shade300),
                                  ),
                                  child: Text(
                                    "30+ days since enrollment",
                                    style: TextStyle(color: Colors.orange.shade700, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                        ],
                      ),
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