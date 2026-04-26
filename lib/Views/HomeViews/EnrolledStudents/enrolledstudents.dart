import 'dart:ui';
import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EnrolledStudents extends StatelessWidget {
  final String subjectId;

  EnrolledStudents({super.key, required this.subjectId});

  final authController = Get.find<AuthController>();
  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    final subject = adminController.subjectList.firstWhere(
          (s) => s.id == subjectId,
      orElse: () => SubjectModel(
        subject: "Unknown Subject",
        id: "", subjectId: "", duration: "", classTime: "", registration: "", teacher: "",
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor),
        ),
        title: Text(
          "Enrolled Students",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              subject.subject,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.whiteColor.withOpacity(0.92),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
        color: AppColors.purpleColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("subjectForm")
              .doc(subjectId)
              .collection("enrollForm")
              .where("status", isEqualTo: "Approved")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: IsLoading());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildModernEmptyState(subject.subject);
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                return _buildGlassCard(context, data, doc.id, subjectId, index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassCard(
      BuildContext context, Map<String, dynamic> data, String docId, String subjectId, int index) {
    final userName = data["userName"] ?? "Unknown";
    final userFatherName = data["userFatherName"] ?? "Not Available";
    final userEmail = data["userEmail"] ?? "No Email";
    String feesStatus = (data["feesStatus"] ?? "notPaid").toString().toLowerCase();

    DateTime? approvedAt = _parseTimestamp(data["approvedAt"]);
    DateTime? feesPaidAt = _parseTimestamp(data["feesPaidAt"]);
    DateTime? enrolledAt = _parseTimestamp(data["enrolledAt"]);

    DateTime? displayDate = feesPaidAt ?? approvedAt ?? enrolledAt;
    String dateLabel = feesPaidAt != null ? "Fee Paid" : "Enrolled";

    String timerText = "0/30";
    Color timerColor = AppColors.greyColor;
    double progress = 0.0;

    if (displayDate != null) {
      final totalDays = DateTime.now().difference(displayDate).inDays;
      final currentDay = (totalDays % 30) + 1;
      timerText = "$currentDay/30";
      progress = currentDay / 30;

      if (currentDay <= 20) {
        timerColor = AppColors.greenColor;
      } else if (currentDay <= 27) {
        timerColor = const Color(0xFFFF9800);
      } else {
        timerColor = AppColors.redColor;
      }

      if (totalDays >= 30 && feesStatus == "paid") {
        FirebaseFirestore.instance
            .collection("subjectForm")
            .doc(subjectId)
            .collection("enrollForm")
            .doc(docId)
            .update({"feesStatus": "notPaid", "feesPaidAt": null});
        feesStatus = "notPaid";
      }
    }

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 60 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            // Glassmorphic Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [AppColors.cardGradient1, AppColors.cardGradient2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: AppColors.glassBg,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.purpleColor.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_rounded, size: 22, color: AppColors.purpleColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                userName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentPurple,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        Divider(color: AppColors.dividerColor, thickness: 1.2),

                        // Father
                        _infoRow(Icons.person_outline, "Father's Name", userFatherName),
                        const SizedBox(height: 12),

                        // Email
                        _infoRow(Icons.alternate_email, "Email", userEmail),
                        const SizedBox(height: 20),

                        // Fees + Timer
                        Row(
                          children: [
                            // Fees Badge
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeBg,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      feesStatus == "paid" ? Icons.check_circle_rounded : Icons.pending,
                                      size: 18,
                                      color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      feesStatus == "paid" ? "PAID" : "PENDING",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: feesStatus == "paid" ? AppColors.greenColor : AppColors.redColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Circular Timer
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 6,
                                      backgroundColor: AppColors.greyColor.withOpacity(0.2),
                                      valueColor: AlwaysStoppedAnimation(timerColor),
                                    ),
                                  ),
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.whiteColor,
                                      boxShadow: [
                                        BoxShadow(color: AppColors.shadowColor, blurRadius: 8),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        timerText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: timerColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Date
                        if (displayDate != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.event_available_rounded, size: 16, color: AppColors.greyColor),
                              const SizedBox(width: 8),
                              Text(
                                "$dateLabel on ${_formatDate(displayDate)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Floating badge (optional flair)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purpleColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 6)],
                ),
                child: Text(
                  "#${index + 1}",
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.accentPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.greyColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 14.5, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernEmptyState(String subjectName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [AppColors.purpleColor.withOpacity(0.15), AppColors.transparentColor],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_outlined, size: 80, color: AppColors.purpleColor),
            ),
            const SizedBox(height: 32),
            Text(
              "No Students Yet",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accentPurple),
            ),
            const SizedBox(height: 12),
            Text(
              "in $subjectName",
              style: GoogleFonts.poppins(fontSize: 16, color: AppColors.greyColor),
            ),
            const SizedBox(height: 16),
            Text(
              "Approved enrollments will appear here with live timer.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.greyColor),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseTimestamp(dynamic t) => t is Timestamp ? t.toDate() : null;
  String _formatDate(DateTime d) => "${d.day} ${_monthName(d.month)} ${d.year}";
  String _monthName(int m) => ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][m - 1];
}
