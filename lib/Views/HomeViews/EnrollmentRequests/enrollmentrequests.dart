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
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/EnrollmentRequestCard/enrollmentRequestCard.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnrollmentRequests extends StatelessWidget {
  final SubjectModel subject = Get.arguments as SubjectModel;
  final AdminController adminController = Get.find<AdminController>();

  EnrollmentRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget.h2("Enrollment Requests", Colors.white, context),
        backgroundColor: AppColors.purpleColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("subjectForm")
            .doc(subject.id)
            .collection("enrollForm")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Requests Found"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return EnrollmentRequestCard(
                data: data,
                onApprove: () => adminController.approveEnrollment(
                  subjectId: subject.id,
                  userId: doc.id,
                ),
                onReject: () => adminController.rejectEnrollment(
                  subjectId: subject.id,
                  docId: doc.id,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
