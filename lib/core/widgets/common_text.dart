import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonText extends StatelessWidget {
  final String title;
  final double? fSize;
  final FontWeight? fWeight;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextAlign? align;
  final Color? color;
  final String? fontFamily;

  const CommonText({
    super.key,
    required this.title,
    this.fSize,
    this.fWeight,
    this.overflow,
    this.maxLine,
    this.align,
    this.color,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLine,
      overflow: overflow ?? TextOverflow.visible,
      textAlign: align ?? TextAlign.start,
      style: GoogleFonts.getFont(
        fontFamily ?? 'Poppins',
        fontSize: fSize?.sp ?? 14.sp,
        fontWeight: fWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
      ),
    );
  }
}