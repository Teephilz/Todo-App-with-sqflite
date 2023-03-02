import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


const Color bluishClr=Color(0xff4e5ae8);
const Color yellowClr=Color(0xffffb746);
const Color pinkClr=Color(0xffff4667);
const Color white=Colors.white;
const Color primaryClr=bluishClr;
const Color darkGreyColor=Color(0xff121212);
const Color darkHeaderClr=Color(0xff424242);

class Themes{
  static final light=ThemeData(
     backgroundColor:Colors.white,
      primaryColor: primaryClr,
      brightness:Brightness.light
      );

  static final dark=ThemeData(
    backgroundColor: darkGreyColor,
      primaryColor:darkGreyColor,
      brightness:Brightness.dark
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.grey[400]:Colors.grey
      )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,

          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,

          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get subtitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,

          color: Get.isDarkMode?Colors.grey[400]:Colors.grey[400]
      )
  );
}


TextStyle get textInputStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,

          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

