import 'package:admin/Widgets/TextWidget/textwidget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textcolor;
  const CustomButton({super.key,required this.text,required this.textcolor,
  required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),child: Center(child: TextWidget.h3(text, textcolor, context)),
    );
  }
}
