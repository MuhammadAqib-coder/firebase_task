import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controler,
    required this.hint,
    required this.inputType,
    this.prefixIcon,
    this.suffixIcon,
    this.obseCure,
  });
  final TextEditingController controler;
  final String hint;
  final TextInputType inputType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool? obseCure;
  // final VoidCallback? onTap;

  // final Function(String value) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obseCure ?? false,
      controller: controler,
      keyboardType: inputType,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon)
              : Container(
                  height: 0.sp,
                  width: 0.sp,
                ),
          suffixIcon: suffixIcon ??
              Container(
                height: 0.sp,
                width: 0.sp,
              ),
          labelText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value!.isEmpty) {
          return 'fill the field';
        } else {
          return null;
        }
      },
    );
  }
}
