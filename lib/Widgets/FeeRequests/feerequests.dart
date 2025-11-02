// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class FeeRequests extends StatelessWidget {
//   FeeRequests({super.key});
//
//   final adminController = Get.find<AdminController>();
//
//   @override
//   Widget build(BuildContext context) {
//     // Initial fetch
//     adminController.fetchAllFeeRequests();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: TextWidget.h2("Fee Requests", Colors.white, context),
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
//       ),
//       body: Obx(() {
//         if (adminController.isLoading.value) {
//           return Center(
//               child: CircularProgressIndicator(color: AppColors.purpleColor));
//         }
//
//         if (adminController.feeRequests.isEmpty) {
//           return Center(
//               child: TextWidget.h2("No fee requests", Colors.black, context));
//         }
//
//         return ListView.builder(
//           padding: EdgeInsets.all(10),
//           itemCount: adminController.feeRequests.length,
//           itemBuilder: (context, index) {
//             final data = adminController.feeRequests[index];
//
//             // Timestamp safe conversion
//             final Timestamp? ts = data['submittedAt'] as Timestamp?;
//             final String submittedAt = ts != null
//                 ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
//                 : 'N/A';
//
//             return Card(
//               margin: EdgeInsets.only(bottom: 10),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 title: TextWidget.h3(
//                     data['userName'] ?? "Unknown", Colors.black, context),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 5),
//                     TextWidget.h3(
//                         "Subject ID: ${data['subjectId']}", Colors.black, context),
//                     TextWidget.h3(
//                         "Track ID: ${data['trackId']}", Colors.black, context),
//                     TextWidget.h3("Submitted At: $submittedAt",
//                         Colors.grey, context),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (data['status'] == "Pending") ...[
//                       IconButton(
//                         icon: Icon(Icons.check, color: Colors.green),
//                         onPressed: () =>
//                             adminController.approveFeeRequest(data),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, color: Colors.red),
//                         onPressed: () =>
//                             adminController.rejectFeeRequest(data),
//                       ),
//                     ] else ...[
//                       Icon(
//                         data['status'] == "Approved"
//                             ? Icons.check_circle
//                             : Icons.cancel,
//                         color: data['status'] == "Approved"
//                             ? Colors.green
//                             : Colors.red,
//                       )
//                     ]
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:admin/Controllers/AdminController/admincontroller.dart';
// import 'package:admin/Widgets/TextWidget/textwidget.dart';
// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class FeeRequests extends StatelessWidget {
//   FeeRequests({super.key});
//
//   final adminController = Get.find<AdminController>();
//
//   // Status badge widget
//   Widget _buildStatusBadge(String status) {
//     Color color;
//     IconData icon;
//     String label;
//
//     switch (status) {
//       case "Approved":
//         color = Colors.green.shade100;
//         icon = Icons.check_circle;
//         label = "Approved";
//         break;
//       case "Rejected":
//         color = Colors.red.shade100;
//         icon = Icons.cancel;
//         label = "Rejected";
//         break;
//       default:
//         color = Colors.orange.shade100;
//         icon = Icons.access_time;
//         label = "Pending";
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color == Colors.orange.shade100 ? Colors.orange.shade700 : color == Colors.green.shade100 ? Colors.green.shade700 : Colors.red.shade700),
//           SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: color == Colors.orange.shade100 ? Colors.orange.shade700 : color == Colors.green.shade100 ? Colors.green.shade700 : Colors.red.shade700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Initial fetch
//     adminController.fetchAllFeeRequests();
//
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.purpleColor, AppColors.purpleColor.withOpacity(0.8)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 0,
//         title: TextWidget.h2("Fee Requests", Colors.white, context),
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.purpleColor.withOpacity(0.05),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Obx(() {
//           if (adminController.isLoading.value) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: AppColors.purpleColor),
//                   SizedBox(height: 16),
//                   Text("Loading requests...", style: TextStyle(color: AppColors.purpleColor)),
//                 ],
//               ),
//             );
//           }
//
//           if (adminController.feeRequests.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.description_outlined, size: 80, color: Colors.grey.shade400),
//                   SizedBox(height: 16),
//                   TextWidget.h2("No fee requests", Colors.grey.shade600, context),
//                   Text("All caught up!", style: TextStyle(color: Colors.grey.shade500)),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: adminController.feeRequests.length,
//             itemBuilder: (context, index) {
//               final data = adminController.feeRequests[index];
//               final Timestamp? ts = data['submittedAt'] as Timestamp?;
//               final String submittedAt = ts != null
//                   ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
//                   : 'N/A';
//
//               return AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 margin: EdgeInsets.only(bottom: 16),
//                 child: Material(
//                   elevation: 8,
//                   borderRadius: BorderRadius.circular(20),
//                   shadowColor: AppColors.purpleColor.withOpacity(0.2),
//                   child: Container(
//                     padding: EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: LinearGradient(
//                         colors: [Colors.white, Colors.grey.shade50],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header: Name + Status
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: TextWidget.h3(
//                                 data['userName'] ?? "Unknown User",
//                                 AppColors.purpleColor,
//                                 context,
//                               ),
//                             ),
//                             _buildStatusBadge(data['status']),
//                           ],
//                         ),
//
//                         SizedBox(height: 12),
//
//                         // Details
//                         _buildDetailRow(Icons.book, "Subject ID", data['subjectId'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.route, "Track ID", data['trackId'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.access_time, "Submitted At", submittedAt, color: Colors.grey.shade600),
//
//                         // Action Buttons (only for Pending)
//                         if (data['status'] == "Pending") ...[
//                           Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               _actionButton(
//                                 label: "Reject",
//                                 icon: Icons.close,
//                                 color: Colors.red.shade500,
//                                 onTap: () => adminController.rejectFeeRequest(data),
//                               ),
//                               SizedBox(width: 12),
//                               _actionButton(
//                                 label: "Approve",
//                                 icon: Icons.check,
//                                 color: Colors.green.shade600,
//                                 onTap: () => adminController.approveFeeRequest(data),
//                                 isPrimary: true,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
//
//   // Helper: Detail row
//   Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColors.purpleColor.withOpacity(0.7)),
//         SizedBox(width: 8),
//         Text(
//           "$label: ",
//           style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 14),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(color: color ?? Colors.black87, fontSize: 14),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper: Action button
//   Widget _actionButton({
//     required String label,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//     bool isPrimary = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isPrimary ? color : Colors.transparent,
//           border: isPrimary ? null : Border.all(color: color),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 18, color: isPrimary ? Colors.white : color),
//             SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isPrimary ? Colors.white : color,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeeRequests extends StatelessWidget {
  FeeRequests({super.key});

  final adminController = Get.find<AdminController>();

  // Status badge
  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case "Approved":
        color = Colors.green.shade100;
        icon = Icons.check_circle;
        label = "Approved";
        break;
      case "Rejected":
        color = Colors.red.shade100;
        icon = Icons.cancel;
        label = "Rejected";
        break;
      default:
        color = Colors.orange.shade100;
        icon = Icons.access_time;
        label = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color == Colors.orange.shade100
                ? Colors.orange.shade700
                : color == Colors.green.shade100
                ? Colors.green.shade700
                : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color == Colors.orange.shade100
                  ? Colors.orange.shade700
                  : color == Colors.green.shade100
                  ? Colors.green.shade700
                  : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initial fetch
    adminController.fetchAllFeeRequests();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.purpleColor,
                AppColors.purpleColor.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: TextWidget.h2("Fee Requests", Colors.white, context),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.purpleColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
          if (adminController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (adminController.feeRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  TextWidget.h2("No Fee Requests", Colors.grey.shade600, context),
                  Text("All clear!", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: adminController.feeRequests.length,
            itemBuilder: (context, index) {
              final data = adminController.feeRequests[index];
              final Timestamp? ts = data['submittedAt'] as Timestamp?;
              final String submittedAt = ts != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
                  : 'N/A';

              return Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(18),
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
                      // Name + Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextWidget.h3(
                              data['userName'] ?? "Unknown Student",
                              AppColors.purpleColor,
                              context,
                            ),
                          ),
                          _buildStatusBadge(data['status']),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Details
                      SizedBox(height: 8),
                      _buildDetailRow(Icons.person, "Father Name", data['userFatherName'] ?? 'N/A'),
                      SizedBox(height: 8),
                      _buildDetailRow(Icons.email, "Email", data['userEmail'] ?? 'N/A'),
                      SizedBox(height: 8),
                      _buildDetailRow(Icons.book, "Subject ID", data['subjectId'] ?? 'N/A'),
                      SizedBox(height: 8),
                      _buildDetailRow(Icons.numbers, "Track ID", data['trackId'] ?? 'N/A'),
                      SizedBox(height: 8),
                      _buildDetailRow(Icons.account_balance, "Transaction Method", data['transactionMethod'] ?? 'N/A'),
                      SizedBox(height: 8),
                      _buildDetailRow(Icons.access_time, "Submitted At", submittedAt, color: Colors.grey.shade600),

                      if (data['status'] == "Pending") ...[
                        Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _actionButton(
                              label: "Reject",
                              icon: Icons.close,
                              color: Colors.red.shade500,
                              onTap: () => adminController.rejectFeeRequest(data),
                            ),
                            const SizedBox(width: 12),
                            _actionButton(
                              label: "Approve",
                              icon: Icons.check,
                              color: Colors.green.shade600,
                              onTap: () => adminController.approveFeeRequest(data),
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Detail row helper
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.purpleColor.withOpacity(0.8)),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: color ?? Colors.black87, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Action buttons
  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? color : Colors.transparent,
          border: isPrimary ? null : Border.all(color: color),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isPrimary ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
