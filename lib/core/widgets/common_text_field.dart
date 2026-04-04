import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    this.controller,
    required this.title,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.sIcon,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String title;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final bool obscureText;
  final Widget? sIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(-2, -3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),

      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly || onTap != null,
        onTap: onTap,
        maxLines: maxLines,
        validator: validator,

        decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF99A1AF),
            fontWeight: FontWeight.w500,
          ),

          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),

          prefixIcon: prefixIcon,
          suffixIcon: sIcon,

          border: InputBorder.none,
        ),
      ),
    );
  }
}