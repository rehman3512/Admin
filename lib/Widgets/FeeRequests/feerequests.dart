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
//   // Status badge
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
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 16,
//             color: color == Colors.orange.shade100
//                 ? Colors.orange.shade700
//                 : color == Colors.green.shade100
//                 ? Colors.green.shade700
//                 : Colors.red.shade700,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: color == Colors.orange.shade100
//                   ? Colors.orange.shade700
//                   : color == Colors.green.shade100
//                   ? Colors.green.shade700
//                   : Colors.red.shade700,
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
//               colors: [
//                 AppColors.purpleColor,
//                 AppColors.purpleColor.withOpacity(0.8)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 0,
//         title: TextWidget.h2("Fee Requests", Colors.white, context),
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
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
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (adminController.feeRequests.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
//                   const SizedBox(height: 12),
//                   TextWidget.h2("No Fee Requests", Colors.grey.shade600, context),
//                   Text("All clear!", style: TextStyle(color: Colors.grey.shade500)),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: adminController.feeRequests.length,
//             itemBuilder: (context, index) {
//               final data = adminController.feeRequests[index];
//               final Timestamp? ts = data['submittedAt'] as Timestamp?;
//               final String submittedAt = ts != null
//                   ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
//                   : 'N/A';
//
//               return Material(
//                 elevation: 6,
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: LinearGradient(
//                       colors: [Colors.white, Colors.grey.shade50],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name + Status
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: TextWidget.h3(
//                               data['userName'] ?? "Unknown Student",
//                               AppColors.purpleColor,
//                               context,
//                             ),
//                           ),
//                           _buildStatusBadge(data['status']),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Details
//                       SizedBox(height: 8),
//                       _buildDetailRow(Icons.person, "Father Name", data['userFatherName'] ?? 'N/A'),
//                       SizedBox(height: 8),
//                       _buildDetailRow(Icons.email, "Email", data['userEmail'] ?? 'N/A'),
//                       SizedBox(height: 8),
//                       _buildDetailRow(Icons.book, "Subject ID", data['subjectId'] ?? 'N/A'),
//                       SizedBox(height: 8),
//                       _buildDetailRow(Icons.numbers, "Track ID", data['trackId'] ?? 'N/A'),
//                       SizedBox(height: 8),
//                       _buildDetailRow(Icons.account_balance, "Transaction Method", data['transactionMethod'] ?? 'N/A'),
//                       SizedBox(height: 8),
//                       _buildDetailRow(Icons.access_time, "Submitted At", submittedAt, color: Colors.grey.shade600),
//
//                       if (data['status'] == "Pending") ...[
//                         Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             _actionButton(
//                               label: "Reject",
//                               icon: Icons.close,
//                               color: Colors.red.shade500,
//                               onTap: () => adminController.rejectFeeRequest(data),
//                             ),
//                             const SizedBox(width: 12),
//                             _actionButton(
//                               label: "Approve",
//                               icon: Icons.check,
//                               color: Colors.green.shade600,
//                               onTap: () => adminController.approveFeeRequest(data),
//                               isPrimary: true,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
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
//   // Detail row helper
//   Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColors.purpleColor.withOpacity(0.8)),
//         const SizedBox(width: 8),
//         Text(
//           "$label: ",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade700,
//             fontSize: 14,
//           ),
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
//   // Action buttons
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
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isPrimary ? color : Colors.transparent,
//           border: isPrimary ? null : Border.all(color: color),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 18, color: isPrimary ? Colors.white : color),
//             const SizedBox(width: 6),
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

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case "Paid":
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
    // Initial fetch when screen opens
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => adminController.fetchAllFeeRequests(),
            tooltip: "Refresh",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await adminController.fetchAllFeeRequests();
        },
        child: Container(
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
                    Icon(Icons.receipt_long,
                        size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    TextWidget.h2(
                        "No Fee Requests", Colors.grey.shade600, context),
                    Text("All caught up!",
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: Icon(Icons.refresh),
                      label: Text("Refresh"),
                      onPressed: () => adminController.fetchAllFeeRequests(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
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

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Material(
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
                          _buildDetailRow(
                              Icons.person, "Father Name", data['userFatherName'] ?? 'N/A'),
                          SizedBox(height: 8),
                          _buildDetailRow(
                              Icons.email, "Email", data['userEmail'] ?? 'N/A'),
                          SizedBox(height: 8),
                          _buildDetailRow(
                              Icons.book, "Subject ID", data['subjectId'] ?? 'N/A'),
                          SizedBox(height: 8),
                          _buildDetailRow(
                              Icons.numbers, "Track ID", data['trackId'] ?? 'N/A'),
                          SizedBox(height: 8),
                          _buildDetailRow(Icons.account_balance,
                              "Account Holder", data['accountHolder'] ?? 'N/A'),
                          SizedBox(height: 8),
                          _buildDetailRow(Icons.payment, "Transaction",
                              data['transactionName'] ?? 'N/A'),
                          SizedBox(height: 8),
                          _buildDetailRow(Icons.access_time, "Submitted At",
                              submittedAt,
                              color: Colors.grey.shade600),

                          if (data['status'] == "Pending") ...[
                            Divider(
                                height: 24,
                                thickness: 1,
                                color: Colors.grey.shade200),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _actionButton(
                                  label: "Reject",
                                  icon: Icons.close,
                                  color: Colors.red.shade500,
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: "Confirm Rejection",
                                      middleText: "Are you sure you want to reject this fee request?",
                                      textConfirm: "Yes, Reject",
                                      textCancel: "Cancel",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back();
                                        adminController.rejectFeeRequest(data);
                                      },
                                      onCancel: () => Get.back(),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _actionButton(
                                  label: "Approve",
                                  icon: Icons.check,
                                  color: Colors.green.shade600,
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: "Confirm Approval",
                                      middleText: "Are you sure you want to approve this fee request?",
                                      textConfirm: "Yes, Approve",
                                      textCancel: "Cancel",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back();
                                        adminController.approveFeeRequest(data);
                                      },
                                      onCancel: () => Get.back(),
                                    );
                                  },
                                  isPrimary: true,
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
          }),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon,
            size: 18, color: AppColors.purpleColor.withOpacity(0.8)),
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
            Icon(icon,
                size: 18, color: isPrimary ? Colors.white : color),
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