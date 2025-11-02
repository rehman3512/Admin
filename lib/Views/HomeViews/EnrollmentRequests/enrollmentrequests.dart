// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
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
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_outlined,
//             color: AppColors.whiteColor,
//           ),
//         ),
//         title: TextWidget.h2("Enrollment Requests", Colors.white, context),
//         backgroundColor: AppColors.purpleColor,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("subjectForm")
//             .doc(subject.id)
//             .collection("enrollForm")
//             .orderBy("submittedAt", descending: true)
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
//                 style: TextStyle(fontSize: 16),
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
//               // Convert Firestore timestamp
//               String submittedTime = '';
//               if (data['submittedAt'] != null) {
//                 final timestamp = data['submittedAt'] as Timestamp;
//                 submittedTime =
//                     DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
//               }
//
//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 3,
//                 margin: const EdgeInsets.only(bottom: 14),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             data["userName"] ?? "Unknown",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.purpleColor,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: (data["status"] == "Pending")
//                                   ? Colors.orange.shade100
//                                   : (data["status"] == "Approved")
//                                   ? Colors.green.shade100
//                                   : Colors.red.shade100,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               data["status"] ?? "Unknown",
//                               style: TextStyle(
//                                 color: (data["status"] == "Pending")
//                                     ? Colors.orange
//                                     : (data["status"] == "Approved")
//                                     ? Colors.green
//                                     : Colors.red,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Email
//                       if (data["userEmail"] != null)
//                         Text(
//                           "Email: ${data["userEmail"]}",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//
//                       const SizedBox(height: 6),
//
//                       // Father Name
//                       if (data["userFatherName"] != null)
//                         Text(
//                           "Father Name: ${data["userFatherName"]}",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//
//                       // Track ID
//                       if (data["trackId"] != null)
//                         Text(
//                           "Track ID: ${data["trackId"]}",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//
//                       // Transaction Method
//                       if (data["transactionName"] != null)
//                         Text(
//                           "Transaction Method: ${data["transactionName"]}",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//
//                       const SizedBox(height: 6),
//
//                       // Submitted Time
//                       if (submittedTime.isNotEmpty)
//                         Text(
//                           "Submitted At: $submittedTime",
//                           style: const TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey,
//                           ),
//                         ),
//
//                       const SizedBox(height: 14),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                             ),
//                             onPressed: () {
//                               adminController.approveEnrollment(
//                                 subjectId: subject.id,
//                                 userId: doc.id,
//                               );
//                             },
//                             child: const Text("Approve"),
//                           ),
//                           const SizedBox(width: 10),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                             onPressed: () {
//                               adminController.rejectEnrollment(
//                                 subjectId: subject.id,
//                                 docId: doc.id,
//                               );
//                             },
//                             child: const Text("Reject"),
//                           ),
//                         ],
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
//



import 'dart:ui';
import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EnrollmentRequests extends StatelessWidget {
  final SubjectModel subject = Get.arguments as SubjectModel;
  final AdminController adminController = Get.find<AdminController>();

  EnrollmentRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("subjectForm")
            .doc(subject.id)
            .collection("enrollForm")
            .orderBy("submittedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmer();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildFixedHeightCard(data, doc.id, index);
            },
          );
        },
      ),
    );
  }

  // Premium AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor),
      ),
      title: Text(
        "Enrollment Requests",
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.purpleColor, AppColors.purpleColor.withOpacity(0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
    );
  }

  // Shimmer
  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 160,
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Icon(Icons.hourglass_empty_rounded, size: 60, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            "No Requests Yet",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // FIXED HEIGHT CARD (160px)
  Widget _buildFixedHeightCard(Map<String, dynamic> data, String docId, int index) {
    final status = data["status"] ?? "Pending";
    final submittedTime = _formatTimestamp(data['submittedAt']);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + (index * 80)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        height: 160, // ← FIXED HEIGHT
        margin: const EdgeInsets.only(bottom: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.glassBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.whiteColor.withOpacity(0.35), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purpleColor.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data["userName"] ?? "Unknown",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.purpleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(status),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Grid Info (2 columns)
                  Expanded(
                    child: Row(
                      children: [
                        // Left Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _labelValue("Email", data["userEmail"]),
                              _labelValue("Father", data["userFatherName"]),
                            ],
                          ),
                        ),
                        // Right Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _labelValue("Track ID", data["trackId"]),
                              _labelValue("Method", data["transactionName"]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Footer: Time + Buttons
                  // Row(
                  //   children: [
                  //     Text(
                  //       submittedTime,
                  //       style: GoogleFonts.poppins(fontSize: 11.5, color: Colors.grey[600]),
                  //     ),
                  //     const Spacer(),
                  //     _actionButton("Approve", AppColors.neonGreen, () {
                  //       adminController.approveEnrollment(subjectId: subject.id, userId: docId);
                  //     }),
                  //     const SizedBox(width: 8),
                  //     _actionButton("Reject", AppColors.neonRed, () {
                  //       adminController.rejectEnrollment(subjectId: subject.id, docId: docId);
                  //     }),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Text(
                        submittedTime,
                        style: GoogleFonts.poppins(fontSize: 11.5, color: Colors.grey[600]),
                      ),
                      const Spacer(),

                      if (status == "Pending") ...[
                        _actionButton("Approve", AppColors.neonGreen, () async {
                          await FirebaseFirestore.instance
                              .collection("subjectForm")
                              .doc(subject.id)
                              .collection("enrollForm")
                              .doc(docId)
                              .update({"status": "Approved"});
                        }),
                        const SizedBox(width: 8),
                        _actionButton("Reject", AppColors.neonRed, () async {
                          await FirebaseFirestore.instance
                              .collection("subjectForm")
                              .doc(subject.id)
                              .collection("enrollForm")
                              .doc(docId)
                              .update({"status": "Rejected"});
                        }),
                      ] else
                        Text(
                          status,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: status == "Approved"
                                ? AppColors.neonGreen
                                : AppColors.neonRed,
                          ),
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Label + Value
  Widget _labelValue(String label, dynamic value) {
    if (value == null) return const SizedBox();
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value.toString(),
            style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.purpleColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Status Badge
  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case "Approved":
        color = AppColors.neonGreen;
        break;
      case "Rejected":
        color = AppColors.neonRed;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  // Action Button
  Widget _actionButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  // Format Time
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Unknown";
    final date = (timestamp as Timestamp).toDate();
    return DateFormat('dd MMM, hh:mm a').format(date);
  }
}