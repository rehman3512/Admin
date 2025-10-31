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
//
//
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     Future.delayed(Duration.zero, () {
//       fetchSubject();
//     });
//   }
//
//
//   changeTab(int index){
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
//   addSubject() async {
//     try {
//       isLoading.value = true;
//
//       if (subjectController.text.isEmpty ||
//           subjectIdController.text.isEmpty ||
//           durationController.text.isEmpty ||
//           classController.text.isEmpty ||
//           registrationController.text.isEmpty ||
//           teacherController.text.isEmpty) {
//         ShowMessage.errorMessage("Error: All fields are required");
//         return;
//       }
//
//       // ✅ Step 1: Check duplicate Subject ID
//       var idCheck = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .where("subjectId", isEqualTo: subjectIdController.text)
//           .get();
//
//       if (idCheck.docs.isNotEmpty) {
//         ShowMessage.errorMessage("Error: Subject ID already exists");
//         return;
//       }
//
//       // ✅ Step 2: Check duplicate Subject Name
//       var nameCheck = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .where("subjectName", isEqualTo: subjectController.text)
//           .get();
//
//       if (nameCheck.docs.isNotEmpty) {
//         ShowMessage.errorMessage("Error: Subject Name already exists");
//         return;
//       }
//
//       // ✅ Step 3: Add subject if no duplicates
//       final docRef = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .add({
//         "subjectName": subjectController.text,
//         "subjectId": subjectIdController.text,
//         "duration": durationController.text,
//         "registration": registrationController.text,
//         "classTime": classController.text,
//         "teacherName": teacherController.text,
//       });
//
//       subjectList.add(
//         SubjectModel(
//           subject: subjectController.text,
//           id: docRef.id,
//           subjectId: subjectIdController.text,
//           duration: durationController.text,
//           classTime: classController.text,
//           registration: registrationController.text,
//           teacher: teacherController.text,
//         ),
//       );
//
//       ShowMessage.successMessage("Your subject successfully created");
//       Get.back();
//
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   fetchSubject() async {
//     try {
//       isLoading.value = true;
//       var snapshot = await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .get();
//
//       subjectList.clear();
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         subjectList.add(
//           SubjectModel(
//             subject: data["subjectName"] ?? "",
//             id: doc.id,
//             subjectId: data["subjectId"] ?? "",
//             duration: data["duration"] ?? "",
//             classTime: data["classTime"] ?? "",
//             registration: data["registration"] ?? "",
//             teacher: data["teacherName"] ?? "",
//           ),
//         );
//       }
//
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   updateSubject(SubjectModel subject) async {
//     try {
//       isLoading.value = true;
//       if (subjectController.text.isEmpty ||
//           subjectIdController.text.isEmpty ||
//           durationController.text.isEmpty ||
//           classController.text.isEmpty ||
//           registrationController.text.isEmpty ||
//           teacherController.text.isEmpty) {
//         ShowMessage.errorMessage("Error: All fields are required");
//       } else {
//         await FirebaseFirestore.instance
//             .collection("subjectForm")
//             .doc(subject.id)
//             .update({
//           "subjectName" : subjectController.text,
//           "subjectId" : subjectIdController.text,
//           "duration" : durationController.text,
//           "registration"  : registrationController.text,
//           "classTime" : classController.text,
//           "teacherName" : teacherController.text,
//         });
//
//         int index = subjectList.indexWhere((s)=>s.id == subject.id);
//         if(index!= -1)
//           {
//             subjectList[index] = SubjectModel(
//                 subject: subjectController.text,
//                 id: subject.id,
//                 subjectId: subjectIdController.text,
//                 duration: durationController.text,
//                 classTime: classController.text,
//                 registration: registrationController.text,
//                 teacher: teacherController.text);
//             subjectList.refresh();
//           }
//
//         ShowMessage.successMessage("Subject updated successfully");
//         Get.back();
//
//       }
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   deleteSubject(SubjectModel subject)async{
//     try{
//       isDelete.value = true;
//       await FirebaseFirestore.instance.collection("subjectForm").doc(subject.id).delete();
//       subjectList.removeWhere((s)=>s.id == subject.id);
//
//       ShowMessage.successMessage("Subject deleted successfully");
//       Get.back();
//
//     }catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isDelete.value = false;
//     }
//   }
//
//
//   // ✅ Correct Fee Request Approval
//   Future<void> approveFeeRequest(Map<String, dynamic> data) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('subjectForm')
//           .doc(data['subjectDocId'])
//           .collection('feeRequests')
//           .doc(data['userId']) // ✅ Yahan change kiya hai
//           .update({'status': 'Approved'});
//
//       await FirebaseFirestore.instance
//           .collection('subjectForm')
//           .doc(data['subjectDocId'])
//           .collection('enrollForm')
//           .doc(data['userId']) // ✅ Yahan bhi change kiya hai
//           .update({
//         'status': 'Approved',
//         'feesStatus': 'Paid',
//         'approvedAt': FieldValue.serverTimestamp()
//       });
//
//       Get.snackbar("Success", "Fee approved & marked as paid",
//           backgroundColor: AppColors.greenColor, colorText: Colors.white);
//
//       fetchAllFeeRequests();
//     } catch (e) {
//       print("Error approving fee: $e");
//       Get.snackbar("Error", "Failed to approve fee",
//           backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//     }
//   }
//
// // ✅ Correct Fee Request Fetching
//   Future<void> fetchAllFeeRequests() async {
//     try {
//       isLoading.value = true;
//       feeRequests.clear();
//
//       var subjectsSnapshot = await FirebaseFirestore.instance.collection('subjectForm').get();
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
//           // ✅ Yahaan userId add karo
//           feeRequests.add({
//             ...data,
//             'subjectDocId': subjectDoc.id,
//             'subjectId': data['subjectId'] ?? subjectDoc['subjectId'],
//             'requestId': reqDoc.id,
//             'userId': reqDoc.id, // ✅ Yeh important hai - student ka UID
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching fee requests: $e");
//       Get.snackbar("Error", "Failed to fetch fee requests",
//           backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
// // ✅ Correct Enrollment Approval
//   Future<void> approveEnrollment({
//     required String subjectId,
//     required String userId, // ✅ Yahan change kiya hai
//   }) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subjectId)
//           .collection("enrollForm")
//           .doc(userId) // ✅ Yahan bhi change kiya hai
//           .update({
//         'status': 'Approved',
//         'feesStatus': 'Paid',
//         'acceptedAt': FieldValue.serverTimestamp(),
//       });
//
//       Get.snackbar("Approved", "Student enrolled successfully!",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to approve: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }
//
//
//
//   Future<void> rejectFeeRequest(Map<String, dynamic> data) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('subjectForm')
//           .doc(data['subjectDocId']) // ✅ correct document id
//           .collection('feeRequests')
//           .doc(data['requestId'])
//           .update({'status': 'Rejected'});
//
//       Get.snackbar("Rejected", "Fee request has been rejected",
//           backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//
//       fetchAllFeeRequests();
//     } catch (e) {
//       print("Error rejecting fee: $e");
//       Get.snackbar("Error", "Failed to reject fee",
//           backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//     }
//   }
//
//
//
//
//
//   // Fetch all fee requests across subjects
//   // Future<void> fetchAllFeeRequests() async {
//   //   try {
//   //     isLoading.value = true;
//   //     feeRequests.clear();
//   //
//   //     // Fetch all subjects
//   //     var subjectsSnapshot = await FirebaseFirestore.instance.collection('subjectForm').get();
//   //
//   //     for (var subjectDoc in subjectsSnapshot.docs) {
//   //       // Fetch fee requests for this subject
//   //       var requestsSnapshot = await subjectDoc.reference
//   //           .collection('feeRequests')
//   //           .orderBy('submittedAt', descending: true)
//   //           .get();
//   //
//   //       for (var reqDoc in requestsSnapshot.docs) {
//   //         var data = reqDoc.data();
//   //
//   //         // ✅ Use admin-defined subjectId
//   //         feeRequests.add({
//   //           ...data,
//   //           'subjectId': data['subjectId'] ?? subjectDoc['subjectId'],
//   //           'requestId': reqDoc.id,
//   //         });
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print("Error fetching fee requests: $e");
//   //     Get.snackbar(
//   //       "Error",
//   //       "Failed to fetch fee requests",
//   //       backgroundColor: AppColors.redColor,
//   //       colorText: AppColors.whiteColor,
//   //     );
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//   //
//   // // Approve fee request and mark enroll feesStatus Paid
//   // Future<void> approveFeeRequest(Map<String, dynamic> data) async {
//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('subjectForm')
//   //         .doc(data['subjectId'])
//   //         .collection('feeRequests')
//   //         .doc(data['requestId'])
//   //         .update({'status': 'Approved'});
//   //
//   //     await FirebaseFirestore.instance
//   //         .collection('subjectForm')
//   //         .doc(data['subjectId'])
//   //         .collection('enrollForm')
//   //         .doc(data['requestId'])
//   //         .update({'feesStatus': 'Paid'});
//   //
//   //     Get.snackbar("Success", "Fee approved & paid",
//   //         backgroundColor: AppColors.greenColor, colorText: AppColors.whiteColor);
//   //
//   //     fetchAllFeeRequests(); // refresh
//   //   } catch (e) {
//   //     print("Error approving fee: $e");
//   //     Get.snackbar("Error", "Failed to approve fee",
//   //         backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//   //   }
//   // }
//   //
//   // // Reject fee request
//   // Future<void> rejectFeeRequest(Map<String, dynamic> data) async {
//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection('subjectForm')
//   //         .doc(data['subjectId'])
//   //         .collection('feeRequests')
//   //         .doc(data['requestId'])
//   //         .update({'status': 'Rejected'});
//   //
//   //     Get.snackbar("Info", "Fee rejected",
//   //         backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//   //
//   //     fetchAllFeeRequests(); // refresh
//   //   } catch (e) {
//   //     print("Error rejecting fee: $e");
//   //     Get.snackbar("Error", "Failed to reject fee",
//   //         backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
//   //   }
//   // }
//
//
//   // Reject Request
//   Future<void> rejectEnrollment({
//     required String subjectId,
//     required String docId,
//   }) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subjectId)
//           .collection("enrollForm")
//           .doc(docId)
//           .update({'status': 'Rejected'});
//
//       Get.snackbar("Rejected ❌", "Request has been rejected.",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to reject: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
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
//       // ✅ Step 1: Check if the subject ID is valid
//       if (subject.id.isEmpty) {
//         ShowMessage.errorMessage("Invalid Subject ID");
//         return;
//       }
//
//       // ✅ Step 2: Check in 'users' collection if this email exists
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
//
//       final enrollRef = FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subject.id)
//           .collection("enrollForm")
//           .doc(userId);
//
//       final enrollSnapshot = await enrollRef.get();
//
//       if (enrollSnapshot.exists) {
//         final status = (enrollSnapshot.data()?['status'] ?? "").toString();
//
//         if (status == "Pending") {
//           ShowMessage.errorMessage("This user already has a pending request");
//           return;
//         } else if (status == "Approved") {
//           ShowMessage.errorMessage("This user is already enrolled");
//           return;
//         }
//       }
//
//       await enrollRef.set({
//         "userId": userId,
//         "userName": authController.userController.text,
//         "userFatherName": fatherNameController.text,
//         "userEmail": userEmail,
//         "trackId": trackIdController.text,
//         "transactionMethod": transactionController.text,
//         "subjectId": subject.id,
//         "status": "Pending", // admin will approve
//         "feesStatus": "notPaid",
//         "enrolledAt": FieldValue.serverTimestamp(),
//       });
//
//       ShowMessage.successMessage(
//           "${authController.userController.text} enrollment request submitted successfully");
//
//       // Clear all fields
//       authController.userController.clear();
//       fatherNameController.clear();
//       emailController.clear();
//       trackIdController.clear();
//       transactionController.clear();
//
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   clearAllFields() {
//     authController.userController.clear();
//     fatherNameController.clear();
//     trackIdController.clear();
//     transactionController.clear();
//   }
//
//   insertProfile()async{
//     try{
//       isLoading.value = true;
//       await FirebaseFirestore.instance.collection("admin").doc(getUid())
//           .set({
//         "userName" : authController.userController.text,
//         "userEmail" : await FirebaseAuth.instance.currentUser!.email,
//         "userAge" : int.tryParse(ageController.text)??0,
//         "userGender" : genderController.text,
//       }, SetOptions(merge: true));
//       ShowMessage.successMessage("Your profile has been updated");
//     }catch(e){
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     }finally{
//       isLoading.value = false;
//     }
//   }
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
//         // Controllers me data set kar rahe hain
//         authController.userController.text = data["userName"] ?? "";
//         authController.emailController.text = data["userEmail"] ?? "";
//         ageController.text = (data["userAge"] ?? "").toString();
//         genderController.text = data["userGender"] ?? "";
//       } else {
//         // 🔥 Profile document nai hai → kam se kam FirebaseAuth ka email show karwao
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
//   deleteProfile()async{
//     try{
//       isDelete.value = true;
//       await FirebaseFirestore.instance.collection("admin").doc(getUid()).delete();
//
//       authController.userController.clear();
//       ageController.clear();
//       genderController.clear();
//
//       ShowMessage.successMessage("Profile deleted successfully ");
//     }catch(e){
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     }finally{
//       isDelete.value = false;
//     }
//   }
//
//
//   Future<void> SubmitFee(SubjectModel subject) async {
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
//       // ✅ Step 1: Check if subjectId is valid
//       if (subject.id.isEmpty) {
//         ShowMessage.errorMessage("Invalid Subject ID");
//         return;
//       }
//
//       // ✅ Step 2: Check if user exists in "users" collection
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
//
//       // ✅ Step 3: Check if user is enrolled (status = Approved)
//       final enrollRef = FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subject.id)
//           .collection("enrollForm")
//           .doc(userId);
//
//       final enrollSnap = await enrollRef.get();
//
//       if (!enrollSnap.exists) {
//         ShowMessage.errorMessage("You are not enrolled in this subject");
//         return;
//       }
//
//       if (enrollSnap.data()?['status'] != "Approved") {
//         ShowMessage.errorMessage("Your enrollment is not approved yet");
//         return;
//       }
//
//       // ✅ Step 4: Check if fee request already exists
//       final feeRef = FirebaseFirestore.instance
//           .collection("subjectForm")
//           .doc(subject.id)
//           .collection("feeRequests")
//           .doc(userId);
//
//       final feeSnap = await feeRef.get();
//
//       if (feeSnap.exists) {
//         final status = (feeSnap.data()?['status'] ?? "").toString();
//
//         if (status == "Pending") {
//           ShowMessage.errorMessage("You already have a pending fee request");
//           return;
//         } else if (status == "Paid") {
//           ShowMessage.errorMessage("Your fee is already marked as paid");
//           return;
//         }
//       }
//
//       // ✅ Step 5: Submit new fee request
//       await feeRef.set({
//         "userId": userId,
//         "userName": authController.userController.text,
//         "userFatherName": fatherNameController.text,
//         "userEmail": userEmail,
//         "accountHolder": accountHolderController.text,
//         "trackId": trackIdController.text,
//         "transactionMethod": transactionController.text,
//         "subjectId": subject.id,
//         "status": "Pending", // Admin will approve/reject
//         "submittedAt": FieldValue.serverTimestamp(),
//       });
//
//       ShowMessage.successMessage("Fee request submitted successfully");
//
//       // ✅ Clear fields
//       authController.userController.clear();
//       fatherNameController.clear();
//       emailController.clear();
//       accountHolderController.clear();
//       trackIdController.clear();
//       transactionController.clear();
//
//       Get.back();
//     } catch (e) {
//       ShowMessage.errorMessage("Error: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
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
  var selectedSubject = Rxn<SubjectModel>(); // ✅ Added selected subject

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      fetchSubject();
    });
  }

  // ✅ Select subject method
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

  addSubject() async {
    try {
      isLoading.value = true;

      if (subjectController.text.isEmpty ||
          subjectIdController.text.isEmpty ||
          durationController.text.isEmpty ||
          classController.text.isEmpty ||
          registrationController.text.isEmpty ||
          teacherController.text.isEmpty) {
        ShowMessage.errorMessage("Error: All fields are required");
        return;
      }

      // ✅ Step 1: Check duplicate Subject ID
      var idCheck = await FirebaseFirestore.instance
          .collection("subjectForm")
          .where("subjectId", isEqualTo: subjectIdController.text)
          .get();

      if (idCheck.docs.isNotEmpty) {
        ShowMessage.errorMessage("Error: Subject ID already exists");
        return;
      }

      // ✅ Step 2: Check duplicate Subject Name
      var nameCheck = await FirebaseFirestore.instance
          .collection("subjectForm")
          .where("subjectName", isEqualTo: subjectController.text)
          .get();

      if (nameCheck.docs.isNotEmpty) {
        ShowMessage.errorMessage("Error: Subject Name already exists");
        return;
      }

      // ✅ Step 3: Add subject if no duplicates
      final docRef = await FirebaseFirestore.instance
          .collection("subjectForm")
          .add({
        "subjectName": subjectController.text,
        "subjectId": subjectIdController.text,
        "duration": durationController.text,
        "registration": registrationController.text,
        "classTime": classController.text,
        "teacherName": teacherController.text,
      });

      subjectList.add(
        SubjectModel(
          subject: subjectController.text,
          id: docRef.id,
          subjectId: subjectIdController.text,
          duration: durationController.text,
          classTime: classController.text,
          registration: registrationController.text,
          teacher: teacherController.text,
        ),
      );

      ShowMessage.successMessage("Your subject successfully created");
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  fetchSubject() async {
    try {
      isLoading.value = true;
      var snapshot = await FirebaseFirestore.instance
          .collection("subjectForm")
          .get();

      subjectList.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        subjectList.add(
          SubjectModel(
            subject: data["subjectName"] ?? "",
            id: doc.id,
            subjectId: data["subjectId"] ?? "",
            duration: data["duration"] ?? "",
            classTime: data["classTime"] ?? "",
            registration: data["registration"] ?? "",
            teacher: data["teacherName"] ?? "",
          ),
        );
      }
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  updateSubject(SubjectModel subject) async {
    try {
      isLoading.value = true;
      if (subjectController.text.isEmpty ||
          subjectIdController.text.isEmpty ||
          durationController.text.isEmpty ||
          classController.text.isEmpty ||
          registrationController.text.isEmpty ||
          teacherController.text.isEmpty) {
        ShowMessage.errorMessage("Error: All fields are required");
      } else {
        await FirebaseFirestore.instance
            .collection("subjectForm")
            .doc(subject.id)
            .update({
          "subjectName": subjectController.text,
          "subjectId": subjectIdController.text,
          "duration": durationController.text,
          "registration": registrationController.text,
          "classTime": classController.text,
          "teacherName": teacherController.text,
        });

        int index = subjectList.indexWhere((s) => s.id == subject.id);
        if (index != -1) {
          subjectList[index] = SubjectModel(
            subject: subjectController.text,
            id: subject.id,
            subjectId: subjectIdController.text,
            duration: durationController.text,
            classTime: classController.text,
            registration: registrationController.text,
            teacher: teacherController.text,
          );
          subjectList.refresh();
        }

        ShowMessage.successMessage("Subject updated successfully");
        Get.back();
      }
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  deleteSubject(SubjectModel subject) async {
    try {
      isDelete.value = true;
      await FirebaseFirestore.instance.collection("subjectForm").doc(subject.id).delete();
      subjectList.removeWhere((s) => s.id == subject.id);

      ShowMessage.successMessage("Subject deleted successfully");
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isDelete.value = false;
    }
  }

  // ✅ Correct Fee Request Fetching
  Future<void> fetchAllFeeRequests() async {
    try {
      isLoading.value = true;
      feeRequests.clear();

      var subjectsSnapshot = await FirebaseFirestore.instance.collection('subjectForm').get();

      for (var subjectDoc in subjectsSnapshot.docs) {
        var requestsSnapshot = await subjectDoc.reference
            .collection('feeRequests')
            .orderBy('submittedAt', descending: true)
            .get();

        for (var reqDoc in requestsSnapshot.docs) {
          var data = reqDoc.data();

          feeRequests.add({
            ...data,
            'subjectDocId': subjectDoc.id,
            'subjectId': data['subjectId'] ?? subjectDoc['subjectId'],
            'requestId': reqDoc.id,
            'userId': data['userId'] ?? reqDoc.id,
          });
        }
      }
    } catch (e) {
      print("Error fetching fee requests: $e");
      Get.snackbar("Error", "Failed to fetch fee requests",
          backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Correct Fee Request Approval
  Future<void> approveFeeRequest(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('subjectForm')
          .doc(data['subjectDocId'])
          .collection('feeRequests')
          .doc(data['requestId'])
          .update({'status': 'Approved'});

      await FirebaseFirestore.instance
          .collection('subjectForm')
          .doc(data['subjectDocId'])
          .collection('enrollForm')
          .doc(data['userId'])
          .update({
        'status': 'Approved',
        'feesStatus': 'Paid',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Fee approved & marked as paid",
          backgroundColor: AppColors.greenColor, colorText: Colors.white);

      fetchAllFeeRequests();
    } catch (e) {
      print("Error approving fee: $e");
      Get.snackbar("Error", "Failed to approve fee",
          backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
    }
  }

  Future<void> rejectFeeRequest(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('subjectForm')
          .doc(data['subjectDocId'])
          .collection('feeRequests')
          .doc(data['requestId'])
          .update({'status': 'Rejected'});

      Get.snackbar("Rejected", "Fee request has been rejected",
          backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);

      fetchAllFeeRequests();
    } catch (e) {
      print("Error rejecting fee: $e");
      Get.snackbar("Error", "Failed to reject fee",
          backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor);
    }
  }

  // ✅ Correct Enrollment Approval
  Future<void> approveEnrollment({
    required String subjectId,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectId)
          .collection("enrollForm")
          .doc(userId)
          .update({
        'status': 'Approved',
        'feesStatus': 'Paid',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Approved", "Student enrolled successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to approve: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Reject Request
  Future<void> rejectEnrollment({
    required String subjectId,
    required String docId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subjectId)
          .collection("enrollForm")
          .doc(docId)
          .update({'status': 'Rejected'});

      Get.snackbar("Rejected ❌", "Request has been rejected.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to reject: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  EnrolledStudents(SubjectModel subject) async {
    if (authController.userController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        trackIdController.text.isEmpty ||
        transactionController.text.isEmpty) {
      ShowMessage.errorMessage("All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      final userEmail = emailController.text.trim();

      // ✅ Step 1: Check if the subject ID is valid
      if (subject.id.isEmpty) {
        ShowMessage.errorMessage("Invalid Subject ID");
        return;
      }

      // ✅ Step 2: Check in 'users' collection if this email exists
      final userQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ShowMessage.errorMessage("No user found with this email in the system");
        return;
      }

      final userDoc = userQuery.docs.first;
      final userId = userDoc.id;

      final enrollRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .collection("enrollForm")
          .doc(userId);

      final enrollSnapshot = await enrollRef.get();

      if (enrollSnapshot.exists) {
        final status = (enrollSnapshot.data()?['status'] ?? "").toString();

        if (status == "Pending") {
          ShowMessage.errorMessage("This user already has a pending request");
          return;
        } else if (status == "Approved") {
          ShowMessage.errorMessage("This user is already enrolled");
          return;
        }
      }

      await enrollRef.set({
        "userId": userId,
        "userName": authController.userController.text,
        "userFatherName": fatherNameController.text,
        "userEmail": userEmail,
        "trackId": trackIdController.text,
        "transactionMethod": transactionController.text,
        "subjectId": subject.id,
        "status": "Pending",
        "feesStatus": "notPaid",
        "enrolledAt": FieldValue.serverTimestamp(),
      });

      ShowMessage.successMessage(
          "${authController.userController.text} enrollment request submitted successfully");

      // Clear all fields
      authController.userController.clear();
      fatherNameController.clear();
      emailController.clear();
      trackIdController.clear();
      transactionController.clear();

      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  clearAllFields() {
    authController.userController.clear();
    fatherNameController.clear();
    trackIdController.clear();
    transactionController.clear();
  }

  insertProfile() async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection("admin").doc(getUid()).set({
        "userName": authController.userController.text,
        "userEmail": await FirebaseAuth.instance.currentUser!.email,
        "userAge": int.tryParse(ageController.text) ?? 0,
        "userGender": genderController.text,
      }, SetOptions(merge: true));
      ShowMessage.successMessage("Your profile has been updated");
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
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
      await FirebaseFirestore.instance.collection("admin").doc(getUid()).delete();

      authController.userController.clear();
      ageController.clear();
      genderController.clear();

      ShowMessage.successMessage("Profile deleted successfully ");
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isDelete.value = false;
    }
  }

  Future<void> SubmitFee(SubjectModel subject) async {
    if (authController.userController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        accountHolderController.text.isEmpty ||
        trackIdController.text.isEmpty ||
        transactionController.text.isEmpty) {
      ShowMessage.errorMessage("All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      final userEmail = emailController.text.trim();

      // ✅ Step 1: Check if subjectId is valid
      if (subject.id.isEmpty) {
        ShowMessage.errorMessage("Invalid Subject ID");
        return;
      }

      // ✅ Step 2: Check if user exists in "users" collection
      final userQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("userEmail", isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ShowMessage.errorMessage("No user found with this email in the system");
        return;
      }

      final userDoc = userQuery.docs.first;
      final userId = userDoc.id;

      // ✅ Step 3: Check if user is enrolled (status = Approved)
      final enrollRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .collection("enrollForm")
          .doc(userId);

      final enrollSnap = await enrollRef.get();

      if (!enrollSnap.exists) {
        ShowMessage.errorMessage("You are not enrolled in this subject");
        return;
      }

      if (enrollSnap.data()?['status'] != "Approved") {
        ShowMessage.errorMessage("Your enrollment is not approved yet");
        return;
      }

      // ✅ Step 4: Check if fee request already exists
      final feeRef = FirebaseFirestore.instance
          .collection("subjectForm")
          .doc(subject.id)
          .collection("feeRequests")
          .doc(userId);

      final feeSnap = await feeRef.get();

      if (feeSnap.exists) {
        final status = (feeSnap.data()?['status'] ?? "").toString();

        if (status == "Pending") {
          ShowMessage.errorMessage("You already have a pending fee request");
          return;
        } else if (status == "Paid") {
          ShowMessage.errorMessage("Your fee is already marked as paid");
          return;
        }
      }

      // ✅ Step 5: Submit new fee request
      await feeRef.set({
        "userId": userId,
        "userName": authController.userController.text,
        "userFatherName": fatherNameController.text,
        "userEmail": userEmail,
        "accountHolder": accountHolderController.text,
        "trackId": trackIdController.text,
        "transactionMethod": transactionController.text,
        "subjectId": subject.id,
        "status": "Pending",
        "submittedAt": FieldValue.serverTimestamp(),
      });

      ShowMessage.successMessage("Fee request submitted successfully");

      // ✅ Clear fields
      authController.userController.clear();
      fatherNameController.clear();
      emailController.clear();
      accountHolderController.clear();
      trackIdController.clear();
      transactionController.clear();

      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}