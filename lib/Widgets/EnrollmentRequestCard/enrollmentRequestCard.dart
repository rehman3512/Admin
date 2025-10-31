import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnrollmentRequestCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const EnrollmentRequestCard({
    super.key,
    required this.data,
    required this.onApprove,
    required this.onReject,
  });

  Widget _buildStatusBadge(String status) {
    final isPending = status == "Pending";
    final isApproved = status == "Approved";
    final isRejected = status == "Rejected";

    Color color = isPending
        ? Colors.orange
        : isApproved
        ? Colors.green
        : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
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
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.purpleColor),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Timestamp? ts = data['submittedAt'];
    final submittedAt = ts != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
        : 'N/A';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['userName'] ?? "Unknown",
                    style: TextStyle(
                        color: AppColors.purpleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStatusBadge(data['status'] ?? 'Pending'),
              ],
            ),
            const SizedBox(height: 10),

            _detailRow(Icons.email, "Email", data['userEmail'] ?? "N/A"),
            _detailRow(Icons.phone, "Phone", data['userPhone'] ?? "N/A"),
            _detailRow(Icons.access_time, "Submitted", submittedAt),

            if (data['status'] == "Pending") ...[
              const Divider(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close),
                    label: const Text("Reject"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check),
                    label: const Text("Approve"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
