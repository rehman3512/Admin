import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AdminController/admincontroller.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Views/HomeViews/EnrolledStudents/enrolledstudents.dart';
import 'package:admin/Views/HomeViews/EnrollmentRequests/enrollmentrequests.dart';
import 'package:admin/Widgets/CustomButton/custombutton.dart';
import 'package:admin/Widgets/IsLoadind/isloading.dart';
import 'package:admin/Widgets/TextFieldWidget/textfieldwidget.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:admin/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectDetail extends StatelessWidget {
  final SubjectModel subject;
  SubjectDetail({super.key}) : subject = Get.arguments;

  final adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    // 🔥 Initialize controllers with subject values
    adminController.subjectController.text = subject.subject;
    adminController.subjectIdController.text = subject.subjectId;
    adminController.durationController.text = subject.duration;
    adminController.registrationController.text = subject.registration;
    adminController.teacherController.text = subject.teacher;
    adminController.classController.text = subject.classTime;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.purpleColor,
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios_new_outlined,
      //       color: AppColors.whiteColor,
      //     ),
      //   ),
      //   title: TextWidget.h2(subject.subject, AppColors.whiteColor, context),
      // ),

      appBar: AppBar(
        backgroundColor: AppColors.purpleColor,
        elevation: 0,
        leading: IconButton(
       onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor, size: 20),
        ),
        title: Text(
          subject.subject,
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          // REQUESTS ICON
          _iconOnlyButton(
            icon: Icons.pending_actions_rounded,
            color: AppColors.neonPurple,
            onTap: () => Get.toNamed(AppRoutes.enrollmentRequests, arguments: subject),
          ),
          const SizedBox(width: 8),
          // STUDENTS ICON
          _iconOnlyButton(
            icon: Icons.people_alt_rounded,
            color: AppColors.neonGreen,
            onTap: () => Get.to(() => EnrolledStudents(subjectId: subject.id)),
          ),
          const SizedBox(width: 16),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.purpleColor, AppColors.purpleColor.withOpacity(0.9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      // floatingActionButton: Column(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //   FloatingActionButton(onPressed: (){
      //     Get.toNamed(AppRoutes.enrollmentRequests,arguments: subject);
      //   },child: Icon(Icons.ac_unit_outlined),),
      //   SizedBox(height: 20,),
      //   FloatingActionButton(onPressed: (){
      //     // Get.toNamed(AppRoutes.enrolledStudents);
      //     Get.to(() => EnrolledStudents(subjectId: subject.id));
      //   },child: Icon(Icons.read_more),)
      // ],),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  label: "Subject",
                  controller: adminController.subjectController,
                  text: "Enter subject Name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Subject Id",
                  controller: adminController.subjectIdController,
                  text: "Enter subject Id",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Duration",
                  controller: adminController.durationController,
                  text: "Enter subject duration",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Registration Fees",
                  controller: adminController.registrationController,
                  text: "Enter registration fees",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Teacher",
                  controller: adminController.teacherController,
                  text: "Enter teacher name",
                ),
                SizedBox(height: 20),
                TextFieldWidget(
                  label: "Class",
                  controller: adminController.classController,
                  text: "Enter class timing",
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      adminController.updateSubject(subject);
                    },
                    child: Obx(() => adminController.isLoading.value
                        ? Center(child: IsLoading())
                        : CustomButton(
                      text: "Update",
                      textcolor: AppColors.whiteColor,
                      color: AppColors.purpleColor,
                    )),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      adminController.deleteSubject(subject);
                    },
                    child: Obx(() => adminController.isDelete.value
                        ? Center(child: IsLoading())
                        : CustomButton(
                      text: "Delete",
                      textcolor: AppColors.whiteColor,
                      color: AppColors.redColor,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget _iconOnlyButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 20, color: Colors.white),
    ),
  );
}