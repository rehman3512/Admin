import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String text;
  final Widget? suffixicon;
  final Widget? prefixicon;
  final bool obsecure;
  final bool readOnly;
  final TextInputType keyboardType;

  const TextFieldWidget({super.key,required this.label,required this.controller,this.keyboardType,
  required this.text,this.suffixicon,this.prefixicon,this.obsecure=false,this.readOnly=false});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget.h2(label, AppColors.blackColor, context),
        SizedBox(height: 4,),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obsecure,
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            suffixIcon: suffixicon,
            prefix: prefixicon,
            hintText: text,
            hintStyle: GoogleFonts.poppins(
              color: AppColors.blackColor,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w400,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.purpleColor,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.purpleColor,
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.purpleColor,
              )
            )

          ),
        )
      ],
    );
  }
}
