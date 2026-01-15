// import 'package:admin/Constants/AppColors/appcolors.dart';
// import 'package:admin/Controllers/AuthController/authcontroller.dart';
// import 'package:admin/Models/EnrollModel/enrollmodel.dart';
// import 'package:admin/Models/SubjectModel/subjectmodel.dart';
// import 'package:admin/Views/HomeViews/EnrolledStudents/enrolledstudents.dart';
// import 'package:admin/Widgets/ShowMessage/showmessage.dart';
// import 'package:admin/routes/approutes.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class AdminController extends GetxController {
//   final authController = Get.find<AuthController>();
//
//   TextEditingController subjectController = TextEditingController();
//   TextEditingController subjectIdController = TextEditingController();
//   TextEditingController teacherController = TextEditingController();
//   TextEditingController classController = TextEditingController();
//   TextEditingController durationController = TextEditingController();
//   TextEditingController registrationController = TextEditingController();
//   TextEditingController fatherNameController = TextEditingController();
//   TextEditingController trackIdController = TextEditingController();
//   TextEditingController transactionController = TextEditingController();
//   TextEditingController accountHolderController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//
//   var isLoading = false.obs;
//   var isDelete = false.obs;
//   var currentIndex = 0.obs;
//   var subjectList = <SubjectModel>[].obs;
//   var enrollList = <EnrollModel>[].obs;
//   var feeRequests = <Map<String, dynamic>>[].obs;
//   var selectedSubject = Rxn<SubjectModel>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(Duration.zero, () {
//       fetchSubject();
//     });
//   }
//
//   void selectSubject(SubjectModel subject) {
//     selectedSubject.value = subject;
//   }
//
//   changeTab(int index) {
//     currentIndex.value = index;
//   }
//
//   getUid() {
//     return FirebaseAuth.instance.currentUser!.uid;
//   }
//
//   void clearControllers() {
//     subjectController.clear();
//     subjectIdController.clear();
//     teacherController.clear();
//     classController.clear();
//     durationController.clear();
//     registrationController.clear();
//   }
//
//
//   void clearAllFields() {
//     authController.userController.clear();
//     fatherNameController.clear();
//     emailController.clear();
//     trackIdController.clear();
//     transactionController.clear();
//     accountHolderController.clear();
//   }
//
//
//   EnrolledStudents(SubjectModel subject) async {
//     if (authController.userController.text.isEmpty ||
//         fatherNameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         trackIdController.text.isEmpty ||
//         transactionController.text.isEmpty) {
//       ShowMessage.errorMessage("All fields are required");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final userEmail = emailController.text.trim();
//
//       if (subject.id.isEmpty) {
//         ShowMessage.errorMessage("Invalid Subject ID");
//         return;
//       }
//
//       // 🔍 Check user in users collection
//       final userQuery = await FirebaseFirestore.instance
//           .collection("users")
//           .where("userEmail", isEqualTo: userEmail)
//           .limit(1)
//           .get();
//
//       if (userQuery.docs.isEmpty) {
//         ShowMessage.errorMessage("No user found with this email in the system");
//         return;
//       }
//
//       final userDoc = userQuery.docs.first;
//       final userId = userDoc.id;
//       final userData = userDoc.data();
//
//       final enrollRef = FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subject.id) // Firestore document id
//           .collection("enrollForm")
//           .doc(userId);
//
//       final enrollSnapshot = await enrollRef.get();
//
//       if (enrollSnapshot.exists) {
//         final data = enrollSnapshot.data() as Map<String, dynamic>;
//         final status = (data['status'] ?? "").toString();
//
//         if (status == "Pending") {
//           ShowMessage.errorMessage("This user already has a pending request");
//           return;
//         } else if (status == "Approved") {
//           ShowMessage.errorMessage("This user is already enrolled");
//           return;
//         } else if (status == "Rejected") {
//           await enrollRef.update({
//             "userName": userData["userName"] ?? authController.userController.text,
//             "userFatherName": fatherNameController.text,
//             "userEmail": userEmail,
//             "trackId": trackIdController.text,
//             "transactionName": transactionController.text, // ✅ FIXED
//             "subjectId": subject.subjectId,                // ✅ FIXED
//             "status": "Pending",
//             "feesStatus": "notPaid",
//             "submittedAt": FieldValue.serverTimestamp(),   // ✅ FIXED
//           });
//
//           ShowMessage.successMessage("Enrollment re-submitted successfully");
//           clearAllFields();
//           Get.back();
//           return;
//         }
//       }
//
//       // New enrollment
//       await enrollRef.set({
//         "userName": userData["userName"] ?? authController.userController.text,
//         "userFatherName": fatherNameController.text,
//         "userEmail": userEmail,
//         "trackId": trackIdController.text,
//         "transactionName": transactionController.text, // ✅ FIXED
//         "subjectId": subject.subjectId,                // ✅ FIXED
//         "status": "Pending",
//         "feesStatus": "notPaid",
//         "submittedAt": FieldValue.serverTimestamp(),   // ✅ FIXED
//       });
//
//       ShowMessage.successMessage(
//           "${userData["userName"] ?? authController.userController.text} enrollment request submitted successfully");
//
//       clearAllFields();
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   SubmitFee(SubjectModel subject) async {
//     if (authController.userController.text.isEmpty ||
//         fatherNameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         accountHolderController.text.isEmpty ||
//         trackIdController.text.isEmpty ||
//         transactionController.text.isEmpty) {
//       ShowMessage.errorMessage("All fields are required");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final userEmail = emailController.text.trim();
//
//       // 🔍 Check user
//       final userQuery = await FirebaseFirestore.instance
//           .collection("users")
//           .where("userEmail", isEqualTo: userEmail)
//           .limit(1)
//           .get();
//
//       if (userQuery.docs.isEmpty) {
//         ShowMessage.errorMessage("No user found with this email");
//         return;
//       }
//
//       final userDoc = userQuery.docs.first;
//       final userId = userDoc.id;
//       final userData = userDoc.data();
//
//       final feeRef = FirebaseFirestore.instance
//           .collection("feeRequests")
//           .doc(subject.id)
//           .collection("requests")
//           .doc(userId);
//
//       final feeSnapshot = await feeRef.get();
//
//       if (feeSnapshot.exists) {
//         final data = feeSnapshot.data() as Map<String, dynamic>;
//         final status = (data['status'] ?? "").toString();
//
//         if (status == "Pending") {
//           ShowMessage.errorMessage("Fee request already pending");
//           return;
//         } else if (status == "Approved") {
//           ShowMessage.errorMessage("Fee already approved");
//           return;
//         }
//       }
//
//       await feeRef.set({
//         "userName": userData["userName"] ?? authController.userController.text,
//         "userFatherName": fatherNameController.text,
//         "userEmail": userEmail,
//         "accountHolder": accountHolderController.text,
//         "trackId": trackIdController.text,
//         "transactionName": transactionController.text, // ✅ FIXED
//         "subjectId": subject.subjectId,                // ✅ FIXED
//         "status": "Pending",
//         "submittedAt": FieldValue.serverTimestamp(),   // ✅ FIXED
//       });
//
//       ShowMessage.successMessage("Fee request submitted successfully");
//       clearAllFields();
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   approveEnrollment(String subjectDocId, String userId) async {
//     try {
//       isLoading.value = true;
//
//       await FirebaseFirestore.instance
//           .collection('subjectForm')
//           .doc(subjectDocId)
//           .collection('enrollForm')
//           .doc(userId)
//           .update({
//         'status': 'Approved',
//         'feesStatus': 'Paid',
//         'submittedAt': FieldValue.serverTimestamp(), // unified timestamp
//       });
//
//       ShowMessage.successMessage("Enrollment approved successfully");
//     } catch (e) {
//       ShowMessage.errorMessage("Error approving enrollment: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   rejectEnrollment(String subjectDocId, String userId) async {
//     try {
//       isLoading.value = true;
//
//       await FirebaseFirestore.instance
//           .collection('subjectForm')
//           .doc(subjectDocId)
//           .collection('enrollForm')
//           .doc(userId)
//           .update({
//         'status': 'Rejected',
//         'feesStatus': 'notPaid', // aligned with student app
//       });
//
//       ShowMessage.errorMessage("Enrollment request rejected");
//     } catch (e) {
//       ShowMessage.errorMessage("Error rejecting enrollment: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   fetchAllFeeRequests() async {
//     try {
//       isLoading.value = true;
//       feeRequests.clear();
//
//       var subjectsSnapshot = await FirebaseFirestore.instance
//           .collection('subjectForm')
//           .get();
//
//       for (var subjectDoc in subjectsSnapshot.docs) {
//         var requestsSnapshot = await subjectDoc.reference
//             .collection('feeRequests')
//             .orderBy('submittedAt', descending: true)
//             .get();
//
//         for (var reqDoc in requestsSnapshot.docs) {
//           var data = reqDoc.data();
//
//           feeRequests.add({
//             "userName": data["userName"] ?? "",
//             "userFatherName": data["userFatherName"] ?? "",
//             "userEmail": data["userEmail"] ?? "",
//             "accountHolder": data["accountHolder"] ?? "",
//             "trackId": data["trackId"] ?? "",
//             "transactionName": data["transactionName"] ?? "", // Student App naming
//             "subjectId": data["subjectId"] ?? "",
//             "status": data["status"] ?? "Pending",
//             "submittedAt": data["submittedAt"] ?? FieldValue.serverTimestamp(),
//             "requestId": reqDoc.id,
//             "subjectDocId": subjectDoc.id,
//           });
//         }
//       }
//     } catch (e) {
//       ShowMessage.errorMessage("Error fetching fee requests: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   approveFeeRequest(Map<String, dynamic> data) async {
//     try {
//       isLoading.value = true;
//
//       // Update fee request status
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(data["subjectDocId"])
//           .collection("feeRequests")
//           .doc(data["requestId"])
//           .update({
//         "status": "Paid", // aligned with student app
//         "approvedAt": FieldValue.serverTimestamp(),
//       });
//
//       // Update enrollment record as paid
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(data["subjectDocId"])
//           .collection("enrollForm")
//           .doc(data["userId"])
//           .update({
//         "feesStatus": "Paid",
//         "approvedAt": FieldValue.serverTimestamp(),
//       });
//
//       ShowMessage.successMessage("Fee request approved & marked as paid");
//     } catch (e) {
//       ShowMessage.errorMessage("Error approving fee request: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   rejectFeeRequest(Map<String, dynamic> data) async {
//     try {
//       isLoading.value = true;
//
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(data["subjectDocId"])
//           .collection("feeRequests")
//           .doc(data["requestId"])
//           .update({
//         "status": "Rejected",
//         "approvedAt": FieldValue.serverTimestamp(),
//       });
//
//       ShowMessage.errorMessage("Fee request rejected");
//     } catch (e) {
//       ShowMessage.errorMessage("Error rejecting fee request: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   insertProfile() async {
//     try {
//       isLoading.value = true;
//
//       await FirebaseFirestore.instance
//           .collection("admin")
//           .doc(getUid())
//           .set({
//         "userName": authController.userController.text,
//         "userEmail": authController.emailController.text.trim(),
//         "userAge": int.tryParse(ageController.text) ?? 0,
//         "userGender": genderController.text,
//       }, SetOptions(merge: true)); // Merge so existing fields stay
//
//       ShowMessage.successMessage("Profile updated successfully");
//     } catch (e) {
//       ShowMessage.errorMessage("Error updating profile: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   FetchProfile() async {
//     try {
//       isLoading.value = true;
//
//       final doc = await FirebaseFirestore.instance
//           .collection("admin")
//           .doc(getUid())
//           .get();
//
//       if (doc.exists) {
//         final data = doc.data() as Map<String, dynamic>;
//
//         authController.userController.text = data["userName"] ?? "";
//         authController.emailController.text = data["userEmail"] ?? "";
//         ageController.text = (data["userAge"] ?? "").toString();
//         genderController.text = data["userGender"] ?? "";
//       } else {
//         authController.emailController.text =
//             FirebaseAuth.instance.currentUser?.email ?? "";
//       }
//     } catch (e) {
//       ShowMessage.errorMessage("Error fetching profile: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   deleteProfile() async {
//     try {
//       isDelete.value = true;
//
//       await FirebaseFirestore.instance
//           .collection("admin")
//           .doc(getUid())
//           .delete();
//
//       authController.userController.clear();
//       authController.emailController.clear();
//       ageController.clear();
//       genderController.clear();
//
//       ShowMessage.successMessage("Profile deleted successfully");
//     } catch (e) {
//       ShowMessage.errorMessage("Error deleting profile: ${e.toString()}");
//     } finally {
//       isDelete.value = false;
//     }
//   }
//
//
//
//   Future<void> addSubject() async {
//     try {
//       isLoading.value = true;
//
//       // 1️⃣ Validate fields
//       if (subjectController.text.isEmpty ||
//           subjectIdController.text.isEmpty ||
//           durationController.text.isEmpty ||
//           classController.text.isEmpty ||
//           registrationController.text.isEmpty ||
//           teacherController.text.isEmpty) {
//         ShowMessage.errorMessage("All fields are required");
//         return;
//       }
//
//       // 2️⃣ Check if Subject ID already exists
//       var idCheck = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .where("subjectId", isEqualTo: subjectIdController.text)
//           .get();
//
//       if (idCheck.docs.isNotEmpty) {
//         ShowMessage.errorMessage("Subject ID already exists");
//         return;
//       }
//
//       // 3️⃣ Check if Subject Name already exists
//       var nameCheck = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .where("subjectName", isEqualTo: subjectController.text)
//           .get();
//
//       if (nameCheck.docs.isNotEmpty) {
//         ShowMessage.errorMessage("Subject Name already exists");
//         return;
//       }
//
//       // 4️⃣ Add new subject
//       final docRef = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .add({
//         "subjectId": subjectIdController.text,
//         "subjectName": subjectController.text,
//         "duration": durationController.text,
//         "registration": registrationController.text,
//         "classTime": classController.text,
//         "teacherName": teacherController.text,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//
//       // 5️⃣ Add to local list
//       subjectList.add(
//         SubjectModel(
//           id: docRef.id,
//           subjectId: subjectIdController.text,
//           subject: subjectController.text,
//           duration: durationController.text,
//           classTime: classController.text,
//           registration: registrationController.text,
//           teacher: teacherController.text,
//         ),
//       );
//
//       ShowMessage.successMessage("Subject created successfully");
//       clearControllers();
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchSubject() async {
//     try {
//       isLoading.value = true;
//
//       final snapshot =
//       await FirebaseFirestore.instance.collection("subjectForm").get();
//
//       subjectList.clear();
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//
//         subjectList.add(
//           SubjectModel(
//             id: doc.id,
//             subjectId: data["subjectId"] ?? "",
//             subject: data["subjectName"] ?? "",
//             duration: data["duration"] ?? "",
//             classTime: data["classTime"] ?? "",
//             registration: data["registration"] ?? "",
//             teacher: data["teacherName"] ?? "",
//           ),
//         );
//       }
//     } catch (e) {
//       ShowMessage.errorMessage("Error fetching subjects: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   Future<void> updateSubject(SubjectModel subject) async {
//     try {
//       isLoading.value = true;
//
//       // 1️⃣ Validate fields
//       if (subjectController.text.isEmpty ||
//           subjectIdController.text.isEmpty ||
//           durationController.text.isEmpty ||
//           classController.text.isEmpty ||
//           registrationController.text.isEmpty ||
//           teacherController.text.isEmpty) {
//         ShowMessage.errorMessage("All fields are required");
//         return;
//       }
//
//       // 2️⃣ Update in Firestore
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subject.id)
//           .update({
//         "subjectId": subjectIdController.text,
//         "subjectName": subjectController.text,
//         "duration": durationController.text,
//         "classTime": classController.text,
//         "registration": registrationController.text,
//         "teacherName": teacherController.text,
//         "updatedAt": FieldValue.serverTimestamp(),
//       });
//
//       // 3️⃣ Update local list
//       int index = subjectList.indexWhere((s) => s.id == subject.id);
//       if (index != -1) {
//         subjectList[index] = SubjectModel(
//           id: subject.id,
//           subjectId: subjectIdController.text,
//           subject: subjectController.text,
//           duration: durationController.text,
//           classTime: classController.text,
//           registration: registrationController.text,
//           teacher: teacherController.text,
//         );
//         subjectList.refresh();
//       }
//
//       ShowMessage.successMessage("Subject updated successfully");
//       clearControllers();
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error updating subject: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   Future<void> deleteSubject(SubjectModel subject) async {
//     try {
//       isDelete.value = true;
//
//       // 1️⃣ Delete from Firestore
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subject.id)
//           .delete();
//
//       // 2️⃣ Remove from local list
//       subjectList.removeWhere((s) => s.id == subject.id);
//
//       ShowMessage.successMessage("Subject deleted successfully");
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error deleting subject: ${e.toString()}");
//     } finally {
//       isDelete.value = false;
//     }
//   }
//
//
// }


import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';
import 'package:admin/Models/EnrollModel/enrollmodel.dart';
import 'package:admin/Models/SubjectModel/subjectmodel.dart';
import 'package:admin/Views/HomeViews/EnrolledStudents/enrolledstudents.dart';
import 'package:admin/Widgets/ShowMessage/showmessage.dart';
import 'package:admin/routes/approutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final authController = Get.find<AuthController>();

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

  var isLoading = false.obs;
  var isDelete = false.obs;
  var currentIndex = 0.obs;
  var subjectList = <SubjectModel>[].obs;
  var enrollList = <EnrollModel>[].obs;
  var feeRequests = <Map<String, dynamic>>[].obs;
  var selectedSubject = Rxn<SubjectModel>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      fetchSubject();
    });
  }

  void selectSubject(SubjectModel subject) {
    selectedSubject.value = subject;
  }

  changeTab(int index) {
    currentIndex.value = index;
  }

  getUid() {
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

  // ✅ 1. Subject create پر success message
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

      var idCheck = await FirebaseFirestore.instance
          .collection("subjectForm")
          .where("subjectId", isEqualTo: subjectIdController.text)
          .get();

      if (idCheck.docs.isNotEmpty) {
        ShowMessage.errorMessage("Subject ID already exists");
        return;
      }

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

      ShowMessage.successMessage("✅ Subject created successfully!");
      clearControllers();
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ 2. Add student form میں subject validation
  EnrolledStudents(SubjectModel subject) async {
    if (authController.userController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        trackIdController.text.isEmpty ||
        transactionController.text.isEmpty) {
      ShowMessage.errorMessage("❌ All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      final userEmail = emailController.text.trim();

      // پہلے subject کی validation
      if (subject.id.isEmpty) {
        ShowMessage.errorMessage("❌ Invalid Subject");
        return;
      }

      // Subject exists کی checking
      final subjectDoc = await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .get();

      if (!subjectDoc.exists) {
        ShowMessage.errorMessage("❌ Subject does not exist");
        return;
      }

      // User exists کی checking
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

      final enrollRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .collection("enrollForm")
          .doc(userId);

      final enrollSnapshot = await enrollRef.get();

      if (enrollSnapshot.exists) {
        final data = enrollSnapshot.data() as Map<String, dynamic>;
        final status = (data['status'] ?? "").toString();

        if (status == "Pending") {
          ShowMessage.errorMessage("❌ This user already has a pending request");
          return;
        } else if (status == "Approved") {
          ShowMessage.errorMessage("✅ This user is already enrolled");
          return;
        } else if (status == "Rejected") {
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

      // New enrollment
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

      ShowMessage.successMessage(
          "✅ ${userData["userName"] ?? authController.userController.text} enrollment submitted successfully");

      clearAllFields();
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("❌ Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ 4. Fee form میں subject validation - CORRECTED
  SubmitFee(SubjectModel subject) async {
    if (authController.userController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        accountHolderController.text.isEmpty ||
        trackIdController.text.isEmpty ||
        transactionController.text.isEmpty) {
      ShowMessage.errorMessage("❌ All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      final userEmail = emailController.text.trim();

      // 1. پہلے subject کی validation
      if (subject.id.isEmpty) {
        ShowMessage.errorMessage("❌ Invalid Subject ID");
        return;
      }

      // 2. Check if subject exists in Firestore
      final subjectDoc = await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .get();

      if (!subjectDoc.exists) {
        ShowMessage.errorMessage("❌ Subject does not exist in database");
        return;
      }

      // 3. Check user exists
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

      // 4. Check if user is enrolled in this subject
      final enrollCheck = await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .collection("enrollForm")
          .doc(userId)
          .get();

      if (!enrollCheck.exists) {
        ShowMessage.errorMessage("❌ User is not enrolled in this subject");
        return;
      }

      // 5. Check enrollment fees status
      final enrollData = enrollCheck.data() as Map<String, dynamic>;
      final feesStatus = enrollData["feesStatus"] ?? "notPaid";

      if (feesStatus == "Paid") {
        ShowMessage.errorMessage("✅ Fees already paid for this subject");
        return;
      }

      // 6. Check for existing fee request
      final feeRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .collection("feeRequests")
          .doc(userId);

      final feeSnapshot = await feeRef.get();

      if (feeSnapshot.exists) {
        final data = feeSnapshot.data() as Map<String, dynamic>;
        final status = (data['status'] ?? "").toString();

        if (status == "Pending") {
          ShowMessage.errorMessage("❌ Fee request already pending");
          return;
        } else if (status == "Paid" || status == "Approved") {
          ShowMessage.errorMessage("✅ Fee already approved/paid");
          return;
        } else if (status == "Rejected") {
          // اگر request rejected ہے تو نئی request بھیج سکتے ہیں
          await feeRef.set({
            "userName": userData["userName"] ?? authController.userController.text,
            "userFatherName": fatherNameController.text,
            "userEmail": userEmail,
            "accountHolder": accountHolderController.text,
            "trackId": trackIdController.text,
            "transactionName": transactionController.text,
            "subjectId": subject.subjectId,
            "status": "Pending",
            "submittedAt": FieldValue.serverTimestamp(),
            "userId": userId,
            "subjectDocId": subject.id,
            "previousStatus": "Rejected",
          });

          ShowMessage.successMessage("✅ Fee request re-submitted successfully");
          clearAllFields();
          Get.back();
          return;
        }
      }

      // 7. New fee request
      await feeRef.set({
        "userName": userData["userName"] ?? authController.userController.text,
        "userFatherName": fatherNameController.text,
        "userEmail": userEmail,
        "accountHolder": accountHolderController.text,
        "trackId": trackIdController.text,
        "transactionName": transactionController.text,
        "subjectId": subject.subjectId,
        "status": "Pending",
        "submittedAt": FieldValue.serverTimestamp(),
        "userId": userId,
        "subjectDocId": subject.id,
      });

      ShowMessage.successMessage("✅ Fee request submitted successfully");
      clearAllFields();
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("❌ Error: ${e.toString()}");
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
        'approvedAt': FieldValue.serverTimestamp(),
      });

      ShowMessage.successMessage("Enrollment approved successfully");
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
    } catch (e) {
      ShowMessage.errorMessage("Error rejecting enrollment: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ 5. Fee requests fetch کرنے کا function
  fetchAllFeeRequests() async {
    try {
      isLoading.value = true;
      feeRequests.clear();

      var subjectsSnapshot = await FirebaseFirestore.instance
          .collection('subjectForm')
          .get();

      for (var subjectDoc in subjectsSnapshot.docs) {
        var requestsSnapshot = await subjectDoc.reference
            .collection('feeRequests')
            .orderBy('submittedAt', descending: true)
            .get();

        for (var reqDoc in requestsSnapshot.docs) {
          var data = reqDoc.data();

          // صرف pending requests دکھائیں
          String status = (data["status"] ?? "").toString();
          if (status == "Pending") {
            feeRequests.add({
              "userName": data["userName"] ?? "",
              "userFatherName": data["userFatherName"] ?? "",
              "userEmail": data["userEmail"] ?? "",
              "accountHolder": data["accountHolder"] ?? "",
              "trackId": data["trackId"] ?? "",
              "transactionName": data["transactionName"] ?? data["transactionMethod"] ?? "",
              "subjectId": data["subjectId"] ?? "",
              "status": status,
              "submittedAt": data["submittedAt"] ?? FieldValue.serverTimestamp(),
              "requestId": reqDoc.id,
              "subjectDocId": subjectDoc.id,
              "userId": data["userId"] ?? "",
            });
          }
        }
      }

      // Sort by submission date
      feeRequests.sort((a, b) {
        Timestamp? aTime = a["submittedAt"] as Timestamp?;
        Timestamp? bTime = b["submittedAt"] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });

      feeRequests.refresh();
    } catch (e) {
      ShowMessage.errorMessage("Error fetching fee requests: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ 3. Fee request approve کرنے کا function
  approveFeeRequest(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final userId = data["userId"] ?? "";
      final subjectDocId = data["subjectDocId"] ?? "";
      final requestId = data["requestId"] ?? "";

      if (userId.isEmpty || subjectDocId.isEmpty || requestId.isEmpty) {
        ShowMessage.errorMessage("❌ Invalid request data");
        return;
      }

      // 1. Fee request update کریں
      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectDocId)
          .collection("feeRequests")
          .doc(requestId)
          .update({
        "status": "Paid",
        "approvedAt": FieldValue.serverTimestamp(),
      });

      // 2. Enrollment fees status update کریں
      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectDocId)
          .collection("enrollForm")
          .doc(userId)
          .update({
        "feesStatus": "Paid",
        "feeApprovedAt": FieldValue.serverTimestamp(),
      });

      // 3. History save کریں
      await saveFeeHistory(data, "Approved");

      ShowMessage.successMessage("✅ Fee request approved successfully");

      // 4. List refresh کریں
      await fetchAllFeeRequests();
    } catch (e) {
      ShowMessage.errorMessage("❌ Error approving fee request: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ 3. Fee request reject کرنے کا function
  rejectFeeRequest(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final subjectDocId = data["subjectDocId"] ?? "";
      final requestId = data["requestId"] ?? "";
      final userId = data["userId"] ?? "";

      if (subjectDocId.isEmpty || requestId.isEmpty) {
        ShowMessage.errorMessage("❌ Invalid request data");
        return;
      }

      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectDocId)
          .collection("feeRequests")
          .doc(requestId)
          .update({
        "status": "Rejected",
        "rejectedAt": FieldValue.serverTimestamp(),
      });

      // History save کریں
      await saveFeeHistory(data, "Rejected");

      ShowMessage.successMessage("❌ Fee request rejected");

      // List refresh کریں
      await fetchAllFeeRequests();
    } catch (e) {
      ShowMessage.errorMessage("❌ Error rejecting fee request: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ 6. Fee history save کرنے کا function
  Future<void> saveFeeHistory(Map<String, dynamic> feeData, String action) async {
    try {
      await FirebaseFirestore.instance.collection("feeHistory").add({
        "userName": feeData["userName"] ?? "",
        "userEmail": feeData["userEmail"] ?? "",
        "subjectId": feeData["subjectId"] ?? "",
        "trackId": feeData["trackId"] ?? "",
        "action": action,
        "processedBy": getUid(),
        "processedAt": FieldValue.serverTimestamp(),
        "originalData": feeData,
      });
    } catch (e) {
      print("Error saving fee history: $e");
    }
  }

  // باقی functions وہی رہیں گے
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

      final doc = await FirebaseFirestore.instance
          .collection("admin")
          .doc(getUid())
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        authController.userController.text = data["userName"] ?? "";
        authController.emailController.text = data["userEmail"] ?? "";
        ageController.text = (data["userAge"] ?? "").toString();
        genderController.text = data["userGender"] ?? "";
      } else {
        authController.emailController.text =
            FirebaseAuth.instance.currentUser?.email ?? "";
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

      await FirebaseFirestore.instance
          .collection("admin")
          .doc(getUid())
          .delete();

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

  Future<void> fetchSubject() async {
    try {
      isLoading.value = true;

      final snapshot =
      await FirebaseFirestore.instance.collection("subjectForm").get();

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

      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .update({
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
      clearControllers();
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error updating subject: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSubject(SubjectModel subject) async {
    try {
      isDelete.value = true;

      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .delete();

      subjectList.removeWhere((s) => s.id == subject.id);

      ShowMessage.successMessage("Subject deleted successfully");
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error deleting subject: ${e.toString()}");
    } finally {
      isDelete.value = false;
    }
  }
}