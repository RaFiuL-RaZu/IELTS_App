import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String titleText;
  final Color titleColor;
  final Color? borderColor;
  final double borderWidth;
  final double titleSize;
  final FontWeight titleWeight;
  final double buttonRadius;
  final double buttonHeight;
  final double buttonWidth;
  final bool isLoading;
  final Color backgroundColor;
  final Widget? prefixIcon;
  final Widget? widget;
  final Gradient? gradient;

  final bool useGradient;

  const CommonButton({
    super.key,
    this.onTap,
    required this.titleText,
    this.titleColor = Colors.white,
    this.titleSize = 20,
    this.buttonRadius = 16,
    this.gradient,
    this.titleWeight = FontWeight.w600,
    this.buttonHeight = 51,
    this.borderWidth = 1,
    this.isLoading = false,
    this.buttonWidth = double.infinity,
    this.borderColor,
    this.backgroundColor = const Color(0xFF00897B),
    this.prefixIcon,
    this.widget,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight.h,
      width: buttonWidth.w,
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                color: useGradient ? null : backgroundColor,
                gradient: useGradient
                    ? (gradient ??
                    const LinearGradient(
                      colors: [
                        Color(0xFF00897B),
                        Color(0xFF00695C),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ))
                    : null,
                borderRadius: BorderRadius.circular(buttonRadius.r),
                border: Border.all(
                  color: borderColor ?? backgroundColor,
                  width: borderWidth.w,
                ),
              ),
          ),
          Positioned.fill(
            child: ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius.r),
                ),
              ),
              child: isLoading
                  ? Platform.isIOS
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const CircularProgressIndicator(color: Colors.white)
                  : widget ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        SizedBox(width: 8.w),
                      ],
                      if (titleText.isNotEmpty)
                        Flexible(
                          child: Text(
                            titleText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: titleColor,
                              fontSize: titleSize.sp,
                              fontWeight: titleWeight,
                            ),
                          ),
                        ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}