import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Models/EnrollModel/enrollmodel.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Widgets/ShowDialog/showdialog.dart';
import 'package:admin/Widgets/ShowMessage/showmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final authController = Get.find<AuthController>();

  // Text Controllers
  TextEditingController subjectController = TextEditingController();
  TextEditingController subjectIdController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController registrationController = TextEditingController();

  TextEditingController fatherNameController = TextEditingController();
  TextEditingController trackIdController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var isDelete = false.obs;
  var currentIndex = 0.obs;

  var subjectList = <SubjectModel>[].obs;
  var enrollList = <EnrollModel>[].obs;           // Pending Enrollments
  var feeRequests = <Map<String, dynamic>>[].obs;
  var selectedSubject = Rxn<SubjectModel>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      fetchSubject();
      // fetchPendingEnrollments();   // Agar chahein to uncomment kar sakte ho
      // fetchAllFeeRequests();
    });
  }

  void selectSubject(SubjectModel subject) {
    selectedSubject.value = subject;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  String getUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  void clearControllers() {
    subjectController.clear();
    subjectIdController.clear();
    teacherController.clear();
    classController.clear();
    durationController.clear();
    registrationController.clear();
  }

  void clearAllFields() {
    authController.userController.clear();
    fatherNameController.clear();
    emailController.clear();
    trackIdController.clear();
    transactionController.clear();
    accountHolderController.clear();
  }

  // ====================== SUBJECT FUNCTIONS ======================
  Future<void> addSubject() async {
    try {
      isLoading.value = true;

      if (subjectController.text.isEmpty ||
          subjectIdController.text.isEmpty ||
          durationController.text.isEmpty ||
          classController.text.isEmpty ||
          registrationController.text.isEmpty ||
          teacherController.text.isEmpty) {
        ShowMessage.errorMessage("All fields are required");
        return;
      }

      // Check Subject ID
      var idCheck = await FirebaseFirestore.instance
          .collection("subjectForm")
          .where("subjectId", isEqualTo: subjectIdController.text)
          .get();
      if (idCheck.docs.isNotEmpty) {
        ShowMessage.errorMessage("Subject ID already exists");
        return;
      }

      // Check Subject Name
      var nameCheck = await FirebaseFirestore.instance
          .collection("subjectForm")
          .where("subjectName", isEqualTo: subjectController.text)
          .get();
      if (nameCheck.docs.isNotEmpty) {
        ShowMessage.errorMessage("Subject Name already exists");
        return;
      }

      final docRef = await FirebaseFirestore.instance.collection("subjectForm").add({
        "subjectId": subjectIdController.text,
        "subjectName": subjectController.text,
        "duration": durationController.text,
        "registration": registrationController.text,
        "classTime": classController.text,
        "teacherName": teacherController.text,
        "createdAt": FieldValue.serverTimestamp(),
      });

      subjectList.add(
        SubjectModel(
          id: docRef.id,
          subjectId: subjectIdController.text,
          subject: subjectController.text,
          duration: durationController.text,
          classTime: classController.text,
          registration: registrationController.text,
          teacher: teacherController.text,
        ),
      );

      ShowMessage.successMessage("Subject created successfully!");
      clearControllers();
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubject() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance.collection("subjectForm").get();

      subjectList.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        subjectList.add(
          SubjectModel(
            id: doc.id,
            subjectId: data["subjectId"] ?? "",
            subject: data["subjectName"] ?? "",
            duration: data["duration"] ?? "",
            classTime: data["classTime"] ?? "",
            registration: data["registration"] ?? "",
            teacher: data["teacherName"] ?? "",
          ),
        );
      }
    } catch (e) {
      ShowMessage.errorMessage("Error fetching subjects: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSubject(SubjectModel subject) async {
    try {
      isLoading.value = true;

      if (subjectController.text.isEmpty ||
          subjectIdController.text.isEmpty ||
          durationController.text.isEmpty ||
          classController.text.isEmpty ||
          registrationController.text.isEmpty ||
          teacherController.text.isEmpty) {
        ShowMessage.errorMessage("All fields are required");
        return;
      }

      await FirebaseFirestore.instance.collection("subjectForm").doc(subject.id).update({
        "subjectId": subjectIdController.text,
        "subjectName": subjectController.text,
        "duration": durationController.text,
        "classTime": classController.text,
        "registration": registrationController.text,
        "teacherName": teacherController.text,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      int index = subjectList.indexWhere((s) => s.id == subject.id);
      if (index != -1) {
        subjectList[index] = SubjectModel(
          id: subject.id,
          subjectId: subjectIdController.text,
          subject: subjectController.text,
          duration: durationController.text,
          classTime: classController.text,
          registration: registrationController.text,
          teacher: teacherController.text,
        );
        subjectList.refresh();
      }

      ShowMessage.successMessage("Subject updated successfully");
      await Future.delayed(const Duration(seconds: 1));
      clearControllers();
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error updating subject: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSubject(SubjectModel subject) async {
    bool? confirm = await ShowDialog.DeleteDialog(subject.subject);
    if (confirm != true) return;

    try {
      isDelete.value = true;
      await FirebaseFirestore.instance.collection("subjectForm").doc(subject.id).delete();
      subjectList.removeWhere((s) => s.id == subject.id);

      ShowMessage.successMessage("✅ Subject '${subject.subject}' deleted successfully");
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error deleting subject: ${e.toString()}");
    } finally {
      isDelete.value = false;
    }
  }

  // ====================== ENROLLMENT FUNCTIONS ======================
  // EnrolledStudents(SubjectModel subject) async {
  //   if (authController.userController.text.isEmpty ||
  //       fatherNameController.text.isEmpty ||
  //       emailController.text.isEmpty ||
  //       trackIdController.text.isEmpty ||
  //       transactionController.text.isEmpty) {
  //     ShowMessage.errorMessage("❌ All fields are required");
  //     return;
  //   }
  //   if (!GetUtils.isEmail(emailController.text.trim())) {
  //     ShowMessage.errorMessage("❌ Please enter a valid email address");
  //     return;
  //   }
  //
  //   try {
  //     isLoading.value = true;
  //     final userEmail = emailController.text.trim();
  //
  //     final userQuery = await FirebaseFirestore.instance
  //         .collection("users")
  //         .where("userEmail", isEqualTo: userEmail)
  //         .limit(1)
  //         .get();
  //
  //     if (userQuery.docs.isEmpty) {
  //       ShowMessage.errorMessage("❌ No user found with this email");
  //       return;
  //     }
  //
  //     final userDoc = userQuery.docs.first;
  //     final userId = userDoc.id;
  //     final userData = userDoc.data();
  //
  //     final enrollRef = FirebaseFirestore.instance
  //         .collection("subjectForm")
  //         .doc(subject.id)
  //         .collection("enrollForm")
  //         .doc(userId);
  //
  //     final enrollSnapshot = await enrollRef.get();
  //
  //     if (enrollSnapshot.exists) {
  //       final data = enrollSnapshot.data() as Map<String, dynamic>;
  //       final status = (data['status'] ?? "").toString();
  //
  //       if (status == "Pending") {
  //         ShowMessage.errorMessage("❌ This user already has a pending request in this subject");
  //         return;
  //       } else if (status == "Approved") {
  //         ShowMessage.errorMessage("✅ This user is already enrolled in this subject");
  //         return;
  //       } else if (status == "Rejected") {
  //         await enrollRef.update({
  //           "userName": userData["userName"] ?? authController.userController.text,
  //           "userFatherName": fatherNameController.text,
  //           "userEmail": userEmail,
  //           "trackId": trackIdController.text,
  //           "transactionName": transactionController.text,
  //           "subjectId": subject.subjectId,
  //           "status": "Pending",
  //           "feesStatus": "notPaid",
  //           "submittedAt": FieldValue.serverTimestamp(),
  //         });
  //         ShowMessage.successMessage("🔄 Enrollment re-submitted successfully");
  //         clearAllFields();
  //         Get.back();
  //         return;
  //       }
  //     }
  //
  //     // New Enrollment
  //     await enrollRef.set({
  //       "userName": userData["userName"] ?? authController.userController.text,
  //       "userFatherName": fatherNameController.text,
  //       "userEmail": userEmail,
  //       "trackId": trackIdController.text,
  //       "transactionName": transactionController.text,
  //       "subjectId": subject.subjectId,
  //       "status": "Pending",
  //       "feesStatus": "notPaid",
  //       "submittedAt": FieldValue.serverTimestamp(),
  //     });
  //
  //     ShowMessage.successMessage("✅ Enrollment submitted successfully");
  //     clearAllFields();
  //     await Future.delayed(const Duration(seconds: 2));
  //     Get.back();
  //   } catch (e) {
  //     ShowMessage.errorMessage("❌ Error: ${e.toString()}");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Fetch Pending Enrollments (Important for Admin Dashboard)

  // ====================== ENROLLMENT FUNCTIONS ======================
// ✅ YE WALA FUNCTION REPLACE KAR DO (Sabse Important)

  EnrolledStudents(SubjectModel subject) async {
    if (authController.userController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        trackIdController.text.isEmpty ||
        transactionController.text.isEmpty) {
      ShowMessage.errorMessage("❌ All fields are required");
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      ShowMessage.errorMessage("❌ Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;
      final userEmail = emailController.text.trim();

      // 1. User exists check
      final userQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ShowMessage.errorMessage("❌ No user found with this email");
        return;
      }

      final userDoc = userQuery.docs.first;
      final userId = userDoc.id;
      final userData = userDoc.data();

      // 2. Enroll Reference
      final enrollRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)                    // ← Yeh important hai
          .collection("enrollForm")
          .doc(userId);

      // 3. Check existing request
      final enrollSnapshot = await enrollRef.get();

      if (enrollSnapshot.exists) {
        final data = enrollSnapshot.data() as Map<String, dynamic>;
        final status = (data['status'] ?? "").toString().toLowerCase();

        if (status == "pending") {
          ShowMessage.errorMessage("❌ This user already has a pending request in this subject");
          return;
        } else if (status == "approved") {
          ShowMessage.errorMessage("✅ This user is already enrolled in this subject");
          return;
        } else if (status == "rejected") {
          // Re-submit allowed
          await enrollRef.update({
            "userName": userData["userName"] ?? authController.userController.text,
            "userFatherName": fatherNameController.text,
            "userEmail": userEmail,
            "trackId": trackIdController.text,
            "transactionName": transactionController.text,
            "subjectId": subject.subjectId,
            "status": "Pending",
            "feesStatus": "notPaid",
            "submittedAt": FieldValue.serverTimestamp(),
          });

          ShowMessage.successMessage("🔄 Enrollment re-submitted successfully");
          clearAllFields();
          Get.back();
          return;
        }
      }

      // 4. New Enrollment
      await enrollRef.set({
        "userName": userData["userName"] ?? authController.userController.text,
        "userFatherName": fatherNameController.text,
        "userEmail": userEmail,
        "trackId": trackIdController.text,
        "transactionName": transactionController.text,
        "subjectId": subject.subjectId,
        "status": "Pending",
        "feesStatus": "notPaid",
        "submittedAt": FieldValue.serverTimestamp(),
      });

      ShowMessage.successMessage("✅ Enrollment request submitted successfully");
      clearAllFields();
      await Future.delayed(const Duration(seconds: 2));
      Get.back();

    } catch (e) {
      ShowMessage.errorMessage("❌ Error: ${e.toString()}");
      print("EnrolledStudents Error: $e");   // ← Debugging ke liye
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPendingEnrollments() async {
    try {
      isLoading.value = true;
      enrollList.clear();

      final subjectsSnapshot = await FirebaseFirestore.instance.collection('subjectForm').get();

      for (var subjectDoc in subjectsSnapshot.docs) {
        final requestsSnapshot = await subjectDoc.reference
            .collection('enrollForm')
            .where('status', isEqualTo: 'Pending')
            .orderBy('submittedAt', descending: true)
            .get();

        for (var doc in requestsSnapshot.docs) {
          final data = doc.data();
          enrollList.add(
            EnrollModel(
              name: data["userName"] ?? "",
              id: subjectDoc.id,
              fatherName: data["userFatherName"] ?? "",
              trackId: data["trackId"] ?? "",
              transaction: data["transactionName"] ?? "",
              status: data["status"] ?? "Pending",
              feesStatus: data["feesStatus"] ?? "notPaid",
            ),
          );
        }
      }
    } catch (e) {
      ShowMessage.errorMessage("Error fetching pending enrollments: ${e.toString()}");
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  approveEnrollment(String subjectDocId, String userId) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection('subjectForm')
          .doc(subjectDocId)
          .collection('enrollForm')
          .doc(userId)
          .update({
        'status': 'Approved',
        'feesStatus': 'Paid',
        'status': "Paid",
        'approvedAt': FieldValue.serverTimestamp(),
      });
      ShowMessage.successMessage("Enrollment approved successfully");
      fetchPendingEnrollments(); // Refresh list
    } catch (e) {
      ShowMessage.errorMessage("Error approving enrollment: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  rejectEnrollment(String subjectDocId, String userId) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection('subjectForm')
          .doc(subjectDocId)
          .collection('enrollForm')
          .doc(userId)
          .update({
        'status': 'Rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });
      ShowMessage.errorMessage("Enrollment request rejected");
      fetchPendingEnrollments(); // Refresh list
    } catch (e) {
      ShowMessage.errorMessage("Error rejecting enrollment: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ====================== FEE FUNCTIONS ======================
  SubmitFee(SubjectModel subject) async {
    if (authController.userController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        accountHolderController.text.isEmpty ||
        trackIdController.text.isEmpty ||
        transactionController.text.isEmpty ||
        subjectIdController.text.isEmpty) {
      ShowMessage.errorMessage("All fields are required");
      return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      ShowMessage.errorMessage("❌ Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;
      final userEmail = emailController.text.trim();
      final enteredSubjectId = subjectIdController.text.trim();

      // Check Subject ID exists
      final subjectQuery = await FirebaseFirestore.instance
          .collection("subjectForm")
          .where("subjectId", isEqualTo: enteredSubjectId)
          .limit(1)
          .get();

      if (subjectQuery.docs.isEmpty) {
        ShowMessage.errorMessage("Invalid Subject ID");
        return;
      }

      final subjectDoc = subjectQuery.docs.first;
      final subjectDocId = subjectDoc.id;

      // Check User exists
      final userQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ShowMessage.errorMessage("No user found with this email");
        return;
      }

      final userDoc = userQuery.docs.first;
      final userId = userDoc.id;

      // Check if user is approved in this subject
      final enrollRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectDocId)
          .collection("enrollForm")
          .doc(userId);

      final enrollSnap = await enrollRef.get();
      if (!enrollSnap.exists || enrollSnap.data()!["status"] != "Approved") {
        ShowMessage.errorMessage("User is not approved in this subject");
        return;
      }

      // Check duplicate pending fee request
      final feeRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectDocId)
          .collection("feeRequests")
          .doc(userId);

      final feeSnap = await feeRef.get();
      if (feeSnap.exists && feeSnap.data()!["status"] == "Pending") {
        ShowMessage.errorMessage("Fee request already pending for this subject");
        return;
      }

      // Submit Fee Request
      await feeRef.set({
        "userId": userId,
        "userName": userDoc["userName"] ?? "",
        "userFatherName": fatherNameController.text,
        "userEmail": userEmail,
        "accountHolder": accountHolderController.text,
        "trackId": trackIdController.text,
        "transactionName": transactionController.text,
        "subjectId": enteredSubjectId,
        "status": "Pending",
        "feesStatus": "notPaid",
        "submittedAt": FieldValue.serverTimestamp(),
      });

      ShowMessage.successMessage("Fee request submitted successfully");
      clearAllFields();
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllFeeRequests() async {
    try {
      isLoading.value = true;
      feeRequests.clear();

      final subjectsSnapshot = await FirebaseFirestore.instance.collection('subjectForm').get();

      for (var subjectDoc in subjectsSnapshot.docs) {
        final requestsSnapshot = await subjectDoc.reference
            .collection('feeRequests')
            .orderBy('submittedAt', descending: true)
            .get();

        for (var reqDoc in requestsSnapshot.docs) {
          final data = reqDoc.data();
          feeRequests.add({
            "userId": data["userId"] ?? "",
            "userName": data["userName"] ?? "",
            "userFatherName": data["userFatherName"] ?? "",
            "userEmail": data["userEmail"] ?? "",
            "accountHolder": data["accountHolder"] ?? "",
            "trackId": data["trackId"] ?? "",
            "transactionName": data["transactionName"] ?? "",
            "subjectId": data["subjectId"] ?? "",
            "status": data["status"] ?? "Pending",
            "submittedAt": data["submittedAt"],
            "requestId": reqDoc.id,
            "subjectDocId": subjectDoc.id,
          });
        }
      }
    } catch (e) {
      ShowMessage.errorMessage("Error fetching fee requests: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  approveFeeRequest(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(data["subjectDocId"])
          .collection("feeRequests")
          .doc(data["requestId"])
          .update({
        "status": "Paid",
        "approvedAt": FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(data["subjectDocId"])
          .collection("enrollForm")
          .doc(data["userId"])
          .update({
        "feesStatus": "Paid",
        "approvedAt": FieldValue.serverTimestamp(),
      });

      ShowMessage.successMessage("Fee approved successfully");
      fetchAllFeeRequests(); // Refresh
    } catch (e) {
      ShowMessage.errorMessage("Error approving fee: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  rejectFeeRequest(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(data["subjectDocId"])
          .collection("feeRequests")
          .doc(data["requestId"])
          .update({
        "status": "Rejected",
        "rejectedAt": FieldValue.serverTimestamp(),
      });
      ShowMessage.errorMessage("Fee request rejected");
      fetchAllFeeRequests();
    } catch (e) {
      ShowMessage.errorMessage("Error rejecting fee: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ====================== PROFILE FUNCTIONS ======================
  insertProfile() async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection("admin").doc(getUid()).set({
        "userName": authController.userController.text,
        "userEmail": authController.emailController.text.trim(),
        "userAge": int.tryParse(ageController.text) ?? 0,
        "userGender": genderController.text,
      }, SetOptions(merge: true));

      ShowMessage.successMessage("Profile updated successfully");
    } catch (e) {
      ShowMessage.errorMessage("Error updating profile: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  FetchProfile() async {
    try {
      isLoading.value = true;
      final doc = await FirebaseFirestore.instance.collection("admin").doc(getUid()).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        authController.userController.text = data["userName"] ?? "";
        authController.emailController.text = data["userEmail"] ?? "";
        ageController.text = (data["userAge"] ?? "").toString();
        genderController.text = data["userGender"] ?? "";
      } else {
        authController.emailController.text = FirebaseAuth.instance.currentUser?.email ?? "";
      }
    } catch (e) {
      ShowMessage.errorMessage("Error fetching profile: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  deleteProfile() async {
    try {
      isDelete.value = true;
      await FirebaseFirestore.instance.collection("admin").doc(getUid()).delete();

      authController.userController.clear();
      authController.emailController.clear();
      ageController.clear();
      genderController.clear();

      ShowMessage.successMessage("Profile deleted successfully");
    } catch (e) {
      ShowMessage.errorMessage("Error deleting profile: ${e.toString()}");
    } finally {
      isDelete.value = false;
    }
  }
}