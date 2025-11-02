import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnrollmentRequests extends StatelessWidget {
  final SubjectModel subject;
  EnrollmentRequests({super.key,}) : subject = Get.arguments;

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
          "Enrollment Requests",
          AppColors.whiteColor,
          context,
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subjectForm")
              .doc(subject.id) // 👈 subject id from controller
              .collection("enrollForm")
              .where("status", isEqualTo: "Pending") // only pending requests
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return IsLoading();
            }

            final enrollDocs = snapshot.data!.docs;

            if (enrollDocs.isEmpty) {
              return Center(
                child: TextWidget.h2(
                  "No requests",
                  AppColors.blackColor,
                  context,
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: enrollDocs.length,
              itemBuilder: (context, index) {
                final doc = enrollDocs[index];
                final data = doc.data() as Map<String, dynamic>;

                return Card(
                  child: ListTile(
                    title: TextWidget.h3(
                      data["userName"] ?? "Unknown",
                      AppColors.blackColor,
                      context,
                    ),
                    subtitle: TextWidget.h3(
                      "Status: ${data["status"]}",
                      AppColors.blackColor,
                      context,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            // ✅ Approve request
                            FirebaseFirestore.instance
                                .collection("subjectForm")
                                .doc(subject.id)
                                .collection("enrollForm")
                                .doc(doc.id) // 👈 same id as enrollment doc
                                .update({
                              'status': 'Approved',
                              'feesStatus': 'Paid',
                              'acceptedAt': FieldValue.serverTimestamp(),
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Request Approved"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            // ❌ Reject request
                            FirebaseFirestore.instance
                                .collection("subjectForm")
                                .doc(subject.id)
                                .collection("enrollForm")
                                .doc(doc.id)
                                .update({'status': 'Rejected'}).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Request Rejected"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          },
                        ),
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




//
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class EnrollmentRequests extends StatelessWidget {
//   final SubjectModel subject = Get.arguments as SubjectModel;
//   final AdminController adminController = Get.find<AdminController>();
//
//   EnrollmentRequests({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.purpleColor,
//         title: TextWidget.h2("Enrollment Requests", Colors.white, context),
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         // ✅ FIXED COLLECTION PATH (student submissions are inside enrollForm under subjectForm)
//         stream: FirebaseFirestore.instance
//             .collection("subjectForm")
//             .doc(subject.id)
//             .collection("enrollForm")
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No Requests Found"));
//           }
//
//           final docs = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//               final docId = docs[index].id;
//
//               return Card(
//                 elevation: 3,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(12),
//                   title: TextWidget.h3(
//                     data["userName"] ?? "Unknown Student",
//                     AppColors.blackColor,
//                     context,
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 4),
//                       Text(
//                         "Father Name: ${data['userFatherName'] ?? 'N/A'}",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       Text(
//                         "Email: ${data['userEmail'] ?? 'N/A'}",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       Text(
//                         "Track ID: ${data['trackId'] ?? 'N/A'}",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       Text(
//                         "Transaction: ${data['transactionName'] ?? 'N/A'}",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       Text(
//                         "Status: ${data['status'] ?? 'N/A'}",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.check_circle, color: Colors.green),
//                         onPressed: () => adminController.approveEnrollment(
//                           subjectId: subject.id,
//                           userId: docId,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.cancel, color: Colors.red),
//                         onPressed: () => adminController.rejectEnrollment(
//                           subjectId: subject.id,
//                           docId: docId,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

//
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class EnrollmentRequests extends StatelessWidget {
//   final SubjectModel subject = Get.arguments as SubjectModel;
//   final AdminController adminController = Get.find<AdminController>();
//
//   EnrollmentRequests({super.key});
//
//   Future<String> getUserEmail(Map<String, dynamic> data) async {
//     try {
//       // 🔹 Check if email is directly available in data (student side)
//       if (data.containsKey("studentEmail") && data["studentEmail"] != null) {
//         return data["studentEmail"];
//       }
//
//       // 🔹 If admin created the request, get email from admin collection
//       if (data.containsKey("adminEmail") && data["adminEmail"] != null) {
//         return data["adminEmail"];
//       }
//
//       // 🔹 Else fetch from users collection
//       if (data.containsKey("userId")) {
//         final userDoc = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(data["userId"])
//             .get();
//         if (userDoc.exists && userDoc.data()!.containsKey("userEmail")) {
//           return userDoc["userEmail"];
//         }
//       }
//
//       return "Email not found";
//     } catch (e) {
//       return "Error fetching email";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         title: TextWidget.h2("Enrollment Requests", Colors.white, context),
//         backgroundColor: AppColors.purpleColor,
//         elevation: 3,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new_outlined,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("subjectForm")
//             .doc(subject.id)
//             .collection("enrollForm")
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No Requests Found",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }
//
//           final docs = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//
//               final studentName = data["userName"] ?? "Unknown";
//               final fatherName = data["userFatherName"] ?? "Not Provided";
//               final userId = data["userId"] ?? doc.id;
//
//               return FutureBuilder<String>(
//                 future: getUserEmail({...data, "userId": userId}),
//                 builder: (context, emailSnapshot) {
//                   final email =
//                       emailSnapshot.data ?? "Fetching email...";
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       title: Text(
//                         studentName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Padding(
//                         padding: const EdgeInsets.only(top: 6),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Father Name: $fatherName",
//                                 style:
//                                 const TextStyle(color: Colors.black87)),
//                             Text("Email: $email",
//                                 style:
//                                 const TextStyle(color: Colors.black54)),
//                           ],
//                         ),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             onPressed: () => adminController.approveEnrollment(
//                               subjectId: subject.id,
//                               userId: userId,
//                             ),
//                             icon: const Icon(Icons.check_circle,
//                                 color: Colors.green),
//                             tooltip: "Approve",
//                           ),
//                           IconButton(
//                             onPressed: () => adminController.rejectEnrollment(
//                               subjectId: subject.id,
//                               docId: userId,
//                             ),
//                             icon:
//                             const Icon(Icons.cancel, color: Colors.red),
//                             tooltip: "Reject",
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
