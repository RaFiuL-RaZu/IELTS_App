import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/widgets/commom_image.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/ProfileController/profile_controller.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/widgets/common_text.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController controller=Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      controller.nameController.text = controller.profileModel.value.fullName.toString();
      controller.bioController.text = controller.profileModel.value.about.toString();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Edit Profile",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h,),
            Center(
              child: Stack(
                children: [
                  Obx(() => Container(
                    height: 112.h,
                    width: 112.w,
                    decoration: BoxDecoration(
                      color: AppColor.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.0),
                          offset: Offset(0, 20),
                          blurRadius: 25,
                          spreadRadius: -5,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          offset: Offset(0, 8),
                          blurRadius: 10,
                          spreadRadius: -6,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: controller.selectedImage.value.isNotEmpty
                          ? CommonImage(
                        imageSrc: controller.selectedImage.value,
                        imageType: ImageType.file,
                        height: 112.h,
                        width: 112.w,
                        fill: BoxFit.cover,
                      )

                          : controller.profileModel.value.profileImage.toString().isNotEmpty
                          ? CommonImage(
                        imageSrc: AppUrl.imageUrl +
                            controller.profileModel.value.profileImage.toString(),
                        imageType: ImageType.network,
                        height: 112.h,
                        width: 112.w,
                        fill: BoxFit.cover,
                      )

                          : Center(
                        child: Image.asset(
                          AppIcons.camera,
                          height: 32.h,
                          width: 32.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: (){
                        controller.pickImageFromGallery();
                      },

                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.0),
                              offset: Offset(0, 20),
                              blurRadius: 25,
                              spreadRadius: -5,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              offset: Offset(0, 8),
                              blurRadius: 10,
                              spreadRadius: -6,
                            ),
                          ],
                        ),child: Icon(Icons.add,color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h,),
            CommonText(title: "Full  Name",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Full Name",controller: controller.nameController,),
            SizedBox(height: 10.h,),
            SizedBox(height: 4.h,),
            CommonText(title: "Bio",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Tell us about your voice...",maxLines: 3,controller: controller.bioController,),
            SizedBox(height: 10.h,),
            CommonText(title: "Voice Specialties",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            Obx(
                  () => Wrap(
                spacing: 5,
                runSpacing: 10,
                children: List.generate(controller.items.length, (index) {
                  final item = controller.items[index];
                  final isSelected = controller.selectedValues.contains(item);

                  return GestureDetector(
                    onTap: () {
                      controller.toggleItem(item);
                    },
                    child: voiceBox(
                      title: item,
                      isSelected: isSelected,
                    ),
                  );
                }),
              ),
            ),
            Spacer(),
            CommonButton(titleText: "Save Changes",onTap: (){
             controller.updateProfile();
            },),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }

  Container voiceBox({
    required String title,
    required bool isSelected,
  }) {
    return Container(
      height: 34.h,
      width: 110.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Color(0xFF56397C) : Colors.grey.shade400,
          width: 1.2,
        ),
        gradient: LinearGradient(
          colors: isSelected
              ? [
            Color(0xFF180E27),   // ✅ primary gradient
            Color(0xFF56397C),
          ]
              : [
            Colors.white,        // ✅ unselected = white
            Colors.white,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Color(0xFF8A79D6).withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CommonText(
          title: title,
          fSize: 14,
          fWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.black, // ✅ text color fix
        ),
      ),
    );
  }
}
