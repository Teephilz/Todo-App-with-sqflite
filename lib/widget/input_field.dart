
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_project/theme.dart';
class CustomTextField extends StatelessWidget {
  String? title;
  String? hint;
  TextEditingController? controller;
  Widget? widget;
  CustomTextField({this.title, this.hint, this.controller, this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title!,
            style: titleStyle,
          ),
        ),
        Container(
          height: 52,
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.only(left: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            children: [
              Expanded(child:
              TextFormField(
                readOnly: widget==null?false:true,
                autofocus: false,
                cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[600],
                controller: controller,

                style: textInputStyle,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subtitleStyle,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.backgroundColor,
                      width: 0
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0
                    ),
                  ),
                ),

              )),
              widget==null?Container():Container(child: widget,)
            ],
          ),
        )
      ],
    );
  }
}
