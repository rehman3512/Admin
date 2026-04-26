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
//       case "Paid":
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
//   // Detail row widget
//   Widget _buildDetailRow(IconData icon, String label, String value,
//       {Color? color}) {
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
//   // Action button widget
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
//
//   // Approve/Reject action handler
//   Future<void> _handleAction(Map<String, dynamic> data, String action) async {
//     final docRef = FirebaseFirestore.instance
//         .collection("subjectForm")
//         .doc(data['subjectDocId']) // subject document ID
//         .collection("feeRequests")
//         .doc(data['userId']);
//
//     final historyItem = {
//       "action": action,
//       "by": "Admin", // optionally use adminController name
//       "timestamp": FieldValue.serverTimestamp(),
//     };
//
//     try {
//       await docRef.update({
//         "status": action,
//         "history": FieldValue.arrayUnion([historyItem]),
//       });
//
//       Get.snackbar(
//         "Success",
//         "Fee request ${action.toLowerCase()} successfully",
//         backgroundColor: Colors.green.shade300,
//         colorText: Colors.white,
//       );
//
//       // Refresh list
//       adminController.fetchAllFeeRequests();
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to $action fee request",
//         backgroundColor: Colors.red.shade300,
//         colorText: Colors.white,
//       );
//     }
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
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh, color: Colors.white),
//             onPressed: () => adminController.fetchAllFeeRequests(),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await adminController.fetchAllFeeRequests();
//         },
//         child: Obx(() {
//           if (adminController.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
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
//                   Text("All caught up!", style: TextStyle(color: Colors.grey.shade500)),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     icon: Icon(Icons.refresh),
//                     label: Text("Refresh"),
//                     onPressed: () => adminController.fetchAllFeeRequests(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.purpleColor,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
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
//               return Container(
//                 margin: EdgeInsets.only(bottom: 12),
//                 child: Material(
//                   elevation: 6,
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     padding: const EdgeInsets.all(18),
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
//                         // Name + Status
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: TextWidget.h3(
//                                 data['userName'] ?? "Unknown Student",
//                                 AppColors.purpleColor,
//                                 context,
//                               ),
//                             ),
//                             _buildStatusBadge(data['status']),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         _buildDetailRow(Icons.person, "Father Name", data['userFatherName'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.email, "Email", data['userEmail'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.book, "Subject ID", data['subjectId'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.numbers, "Track ID", data['trackId'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.account_balance, "Account Holder", data['accountHolder'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.payment, "Transaction", data['transactionName'] ?? 'N/A'),
//                         SizedBox(height: 8),
//                         _buildDetailRow(Icons.access_time, "Submitted At", submittedAt, color: Colors.grey.shade600),
//
//                         // History display
//                         if (data['history'] != null && data['history'].isNotEmpty) ...[
//                           Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
//                           Text("History:", style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(height: 6),
//                           ...List.generate(data['history'].length, (i) {
//                             final item = data['history'][i];
//                             final Timestamp? t = item['timestamp'] as Timestamp?;
//                             final time = t != null ? DateFormat('dd MMM yyyy, hh:mm a').format(t.toDate()) : 'N/A';
//                             return Text("${item['action']} by ${item['by']} at $time", style: TextStyle(fontSize: 13));
//                           }),
//                           SizedBox(height: 12),
//                         ],
//
//                         // Pending actions
//                         if (data['status'] == "Pending") ...[
//                           Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               _actionButton(
//                                 label: "Reject",
//                                 icon: Icons.close,
//                                 color: Colors.red.shade500,
//                                 onTap: () {
//                                   Get.defaultDialog(
//                                     title: "Confirm Rejection",
//                                     middleText: "Are you sure you want to reject this fee request?",
//                                     textConfirm: "Yes, Reject",
//                                     textCancel: "Cancel",
//                                     confirmTextColor: Colors.white,
//                                     onConfirm: () {
//                                       Get.back();
//                                       _handleAction(data, "Rejected");
//                                     },
//                                     onCancel: () => Get.back(),
//                                   );
//                                 },
//                               ),
//                               const SizedBox(width: 12),
//                               _actionButton(
//                                 label: "Approve",
//                                 icon: Icons.check,
//                                 color: Colors.green.shade600,
//                                 onTap: () {
//                                   Get.defaultDialog(
//                                     title: "Confirm Approval",
//                                     middleText: "Are you sure you want to approve this fee request?",
//                                     textConfirm: "Yes, Approve",
//                                     textCancel: "Cancel",
//                                     confirmTextColor: Colors.white,
//                                     onConfirm: () {
//                                       Get.back();
//                                       _handleAction(data, "Approved");
//                                     },
//                                     onCancel: () => Get.back(),
//                                   );
//                                 },
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

  // Status badge widget (same rakha)
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

  // Detail row widget (same rakha)
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

  // Action button widget (same rakha)
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

  // ==================== MODERN APPROVE / REJECT DIALOG (DeleteDialog jaisa style) ====================
  Future<void> _handleAction(Map<String, dynamic> data, String action) async {
    bool? confirm = await Get.defaultDialog<bool>(
      title: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      backgroundColor: Colors.white,
      radius: 26,
      barrierDismissible: false,

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: action == "Approved" ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              action == "Approved" ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 48,
              color: action == "Approved" ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            action == "Approved" ? "Approve Fee Request?" : "Reject Fee Request?",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Message
          Text(
            action == "Approved"
                ? "Are you sure you want to approve this fee request?\nThis will mark it as Paid."
                : "Are you sure you want to reject this fee request?\nThis action cannot be undone.",
            style: const TextStyle(
              fontSize: 15.5,
              height: 1.45,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(result: false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: action == "Approved" ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    action == "Approved" ? "Yes, Approve" : "Yes, Reject",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      adminController.isLoading.value = true;

      final docRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(data['subjectDocId'])
          .collection("feeRequests")
          .doc(data['requestId']);

      await docRef.update({
        "status": action == "Approved" ? "Paid" : "Rejected",
        "approvedAt": FieldValue.serverTimestamp(),
      });

      if (action == "Approved") {
        await FirebaseFirestore.instance
            .collection("subjectForm")
            .doc(data['subjectDocId'])
            .collection("enrollForm")
            .doc(data['userId'])
            .update({"feesStatus": "Paid"});
      }

      Get.snackbar(
        action == "Approved" ? "✅ Approved" : "❌ Rejected",
        "Fee request ${action.toLowerCase()} successfully",
        backgroundColor: action == "Approved" ? Colors.green : Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await adminController.fetchAllFeeRequests();

    } catch (e) {
      Get.snackbar("Error", "Failed to ${action.toLowerCase()} fee request",
          backgroundColor: Colors.red.shade300, colorText: Colors.white);
    } finally {
      adminController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    adminController.fetchAllFeeRequests();

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
        title: TextWidget.h2("Fee Requests", Colors.white, context),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => adminController.fetchAllFeeRequests(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await adminController.fetchAllFeeRequests(),
        child: Obx(() {
          if (adminController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adminController.feeRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  TextWidget.h2("No Fee Requests", Colors.grey.shade600, context),
                  Text("All caught up!", style: TextStyle(color: Colors.grey.shade500)),
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
                        _buildDetailRow(Icons.person, "Father Name", data['userFatherName'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.email, "Email", data['userEmail'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.book, "Subject ID", data['subjectId'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.numbers, "Track ID", data['trackId'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.account_balance, "Account Holder", data['accountHolder'] ?? 'N/A'),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.payment, "Transaction", data['transactionName'] ?? 'N/A'),
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
                                onTap: () => _handleAction(data, "Rejected"),
                              ),
                              const SizedBox(width: 12),
                              _actionButton(
                                label: "Approve",
                                icon: Icons.check,
                                color: Colors.green.shade600,
                                onTap: () => _handleAction(data, "Approved"),
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
    );
  }
}