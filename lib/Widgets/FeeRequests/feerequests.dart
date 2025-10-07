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

  @override
  Widget build(BuildContext context) {
    // Initial fetch
    adminController.fetchAllFeeRequests();

    return Scaffold(
      appBar: AppBar(
        title: TextWidget.h2("Fee Requests", Colors.white, context),
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
      ),
      body: Obx(() {
        if (adminController.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: AppColors.purpleColor));
        }

        if (adminController.feeRequests.isEmpty) {
          return Center(
              child: TextWidget.h2("No fee requests", Colors.black, context));
        }

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: adminController.feeRequests.length,
          itemBuilder: (context, index) {
            final data = adminController.feeRequests[index];

            // Timestamp safe conversion
            final Timestamp? ts = data['submittedAt'] as Timestamp?;
            final String submittedAt = ts != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate())
                : 'N/A';

            return Card(
              margin: EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: TextWidget.h3(
                    data['userName'] ?? "Unknown", Colors.black, context),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    TextWidget.h3(
                        "Subject ID: ${data['subjectId']}", Colors.black, context),
                    TextWidget.h3(
                        "Track ID: ${data['trackId']}", Colors.black, context),
                    TextWidget.h3("Submitted At: $submittedAt",
                        Colors.grey, context),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data['status'] == "Pending") ...[
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () =>
                            adminController.approveFeeRequest(data),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () =>
                            adminController.rejectFeeRequest(data),
                      ),
                    ] else ...[
                      Icon(
                        data['status'] == "Approved"
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: data['status'] == "Approved"
                            ? Colors.green
                            : Colors.red,
                      )
                    ]
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
