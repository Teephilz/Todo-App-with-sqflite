import 'package:flutter/material.dart';
import 'package:sqlite_project/theme.dart';
class MyButton extends StatelessWidget {
  String label;
  Function()? onTap;
MyButton({required this.label,required this.onTap

});
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr
        ),
        child: Center(
          child: Text(label,
          style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
