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
// class EnrollmentRequests extends StatelessWidget {
//   final SubjectModel subject;
//   EnrollmentRequests({super.key,}) : subject = Get.arguments;
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
//           "Enrollment Requests",
//           AppColors.whiteColor,
//           context,
//         ),
//       ),
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("subjectForm")
//               .doc(subject.id) // 👈 subject id from controller
//               .collection("enrollForm")
//               .where("status", isEqualTo: "Pending") // only pending requests
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
//                   "No requests",
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
//                 return Card(
//                   child: ListTile(
//                     title: TextWidget.h3(
//                       data["userName"] ?? "Unknown",
//                       AppColors.blackColor,
//                       context,
//                     ),
//                     subtitle: TextWidget.h3(
//                       "Status: ${data["status"]}",
//                       AppColors.blackColor,
//                       context,
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.check, color: Colors.green),
//                           onPressed: () {
//                             // ✅ Approve request
//                             FirebaseFirestore.instance
//                                 .collection("subjectForm")
//                                 .doc(subject.id)
//                                 .collection("enrollForm")
//                                 .doc(doc.id) // 👈 same id as enrollment doc
//                                 .update({
//                               'status': 'Approved',
//                               'feesStatus': 'Paid',
//                               'acceptedAt': FieldValue.serverTimestamp(),
//                             }).then((_) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text("Request Approved"),
//                                   backgroundColor: Colors.green,
//                                 ),
//                               );
//                             });
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             // ❌ Reject request
//                             FirebaseFirestore.instance
//                                 .collection("subjectForm")
//                                 .doc(subject.id)
//                                 .collection("enrollForm")
//                                 .doc(doc.id)
//                                 .update({'status': 'Rejected'}).then((_) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text("Request Rejected"),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             });
//                           },
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
import 'package:intl/intl.dart';

class EnrollmentRequests extends StatelessWidget {
  final SubjectModel subject;

  EnrollmentRequests({super.key}) : subject = Get.arguments as SubjectModel;

  final adminController = Get.find<AdminController>();

  // Status Badge
  Widget _buildStatusBadge(String status) {
    final isPending = status == "Pending";
    final isApproved = status == "Approved";
    final isRejected = status == "Rejected";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.orange.shade100
            : isApproved
            ? Colors.green.shade100
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPending
                ? Icons.access_time
                : isApproved
                ? Icons.check_circle
                : Icons.cancel,
            size: 16,
            color: isPending
                ? Colors.orange.shade700
                : isApproved
                ? Colors.green.shade700
                : Colors.red.shade700,
          ),
          SizedBox(width: 4),
          Text(
            isPending ? "Pending" : isApproved ? "Approved" : "Rejected",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isPending
                  ? Colors.orange.shade700
                  : isApproved
                  ? Colors.green.shade700
                  : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Detail Row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.purpleColor.withOpacity(0.7)),
          SizedBox(width: 8),
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 13.5)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87, fontSize: 13.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Action Button
  Widget _actionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap, bool primary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: primary ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: primary ? Colors.white : color),
            SizedBox(width: 6),
            Text(label, style: TextStyle(color: primary ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safe check
    if (subject.id.isEmpty) {
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
              TextWidget.h2("Enrollment Requests", Colors.white, context),
              Text(
                subject.subject ?? "Unknown Subject",
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
        .where("status", isEqualTo: "Pending")
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
    Text("Loading requests...", style: TextStyle(color: AppColors.purpleColor)),
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
    Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
    SizedBox(height: 16),
    TextWidget.h2("No Pending Requests", Colors.grey.shade600, context),
    Text("All clear!", style: TextStyle(color: Colors.grey.shade500)),
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
    final status = data['status'] ?? 'Pending';

    final Timestamp? ts = data['submittedAt'] as Timestamp?;
    final submittedAt = ts != null
    ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
        : 'N/A';

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
    gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade50], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
    _buildStatusBadge(status),
    ],
    ),
    SizedBox(height: 14),

    // Details
    _buildDetailRow(Icons.person, "Name", name),
    _buildDetailRow(Icons.email, "Email", email),
    _buildDetailRow(Icons.phone, "Phone", phone),
    _buildDetailRow(Icons.access_time, "Submitted", submittedAt),

    // Actions (only for Pending)
    if (status == "Pending") ...[
    Divider(height: 28, color: Colors.grey.shade200),
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    _actionButton(
    label: "Reject",
    icon: Icons.close,
    color: Colors.red.shade500,
    onTap: () => _rejectRequest(doc.id, context),
    ),
    SizedBox(width: 12),
    _actionButton(
    label: "Approve",
    icon: Icons.check,
    color: Colors.green.shade600,
    onTap: () => _approveRequest(doc.id, context),
    primary: true,
    ),
    ],
    ),
    ],
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

  void _approveRequest(String docId, BuildContext context) {
    FirebaseFirestore.instance
        .collection("subjectForm")
        .doc(subject.id)
        .collection("enrollForm")
        .doc(docId)
        .update({
      'status': 'Approved',
      'feesStatus': 'Paid',
      'acceptedAt': FieldValue.serverTimestamp(),
    }).then((_) {
      Get.snackbar("Approved", "Student enrolled!", backgroundColor: Colors.green, colorText: Colors.white);
    }).catchError((e) {
      Get.snackbar("Error", "Failed to approve", backgroundColor: Colors.red, colorText: Colors.white);
    });
  }

  void _rejectRequest(String docId, BuildContext context) {
    FirebaseFirestore.instance
        .collection("subjectForm")
        .doc(subject.id)
        .collection("enrollForm")
        .doc(docId)
        .update({'status': 'Rejected'}).then((_) {
      Get.snackbar("Rejected", "Request rejected", backgroundColor: Colors.red, colorText: Colors.white);
    }).catchError((e) {
      Get.snackbar("Error", "Failed to reject", backgroundColor: Colors.red, colorText: Colors.white);
    });
  }
}