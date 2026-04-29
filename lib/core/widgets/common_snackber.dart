

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';

class CommonSnackBar {
  static void show({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    final bgColor = isSuccess ? AppColor.primary : Colors.red;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }
}