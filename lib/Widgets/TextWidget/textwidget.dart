import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget{

  static Widget h1(String text,Color color,BuildContext context){
    return Text(text,style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width * 0.055,
      fontWeight: FontWeight.w600,
    ),);
  }
  static Widget h2(String text,Color color,BuildContext context){
    return Text(text,style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width * 0.055,
      fontWeight: FontWeight.w600,
    ),);
  }
  static Widget h3(String text,Color color,BuildContext context){
    return Text(text,style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width *0.045,
      fontWeight: FontWeight.w600,
    ),);
  }
}