import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:get/get.dart';

class ShowMessage{
  static successMessage(String message){
    Get.snackbar("Congratulations...!", message);
  }

  static errorMessage(String message){
    Get.snackbar("Error!!", message,
        backgroundColor: AppColors.redColor);
  }
}