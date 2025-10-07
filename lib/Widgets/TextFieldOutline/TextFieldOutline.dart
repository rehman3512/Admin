import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldOutline extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String text;
  final Widget? prefixicon;
  final bool readOnly;
  const TextFieldOutline({
    super.key,
    this.label,
    required this.controller,
    required this.text,
    this.prefixicon,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextWidget.h2(label ?? "", AppColors.blackColor, context),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            prefixIcon: prefixicon,
            hintText: text,
            hintStyle: GoogleFonts.poppins(
              color: AppColors.blackColor,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.purpleColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.purpleColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.purpleColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }
}
