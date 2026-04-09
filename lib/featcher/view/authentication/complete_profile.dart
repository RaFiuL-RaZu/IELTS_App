import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/AuthController/signup_controller.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';
import 'package:justtsham/featcher/view/authentication/verify_email.dart';
import '../../../core/widgets/common_text.dart';

class CompleteProfile extends StatelessWidget {
   CompleteProfile({super.key});

  final SignUpController controller=Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Set Up Profile",
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
            SizedBox(height: 12.h,),
            Center(
              child: CommonText(
                align: TextAlign.center,
                title:
                "Let the community know your style.",
                fSize: 16.sp,
                fWeight: FontWeight.w500,
                color: AppColor.secondary,
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Stack(
                children: [
                  Container(
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
                    ),child: Center(child: Image.asset(AppIcons.camera,height: 32.h,width: 32.w,fit: BoxFit.cover,)),
                  ),
                  
                  Positioned(
                    bottom: 0,
                    right: 0,
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
                ],
              ),
            ),
            SizedBox(height: 4.h,),
            CommonText(title: "Bio",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            CommonTextField(title: "Tell us about your voice...",maxLines: 3,),
            SizedBox(height: 10.h,),
            CommonText(title: "Voice Specialties",fSize: 16,fWeight: FontWeight.w700,color: AppColor.primary,),
            SizedBox(height: 6.h,),
            Obx(
                  () => Wrap(
                spacing: 5,
                runSpacing: 10,
                children: List.generate(controller.items.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.toggleItem(index, controller.items[index]);
                      debugPrint(">>>>>>>${controller.selectedValues}");
                    },
                    child: voiceBox(
                      title: controller.items[index],
                      isSelected: controller.selectedIndexes.contains(index),
                    ),
                  );
                }),
              ),
            ),
            Spacer(),
            CommonButton(titleText: "Complete Setup",onTap: (){
              Get.to(()=>LoginScreen());
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
           color: isSelected ? Colors.white : Color(0xFF180E27),
           width: 1.224,
         ),
         gradient: LinearGradient(
           colors: isSelected
               ? [
             Colors.white,
            Colors.white
           ]
               : [
             Color(0xFF180E27),
             Color(0xFF56397C),
           ],
           begin: Alignment.centerLeft,
           end: Alignment.centerRight,
         ),
         boxShadow: [
           BoxShadow(
             color: isSelected
                 ? Colors.white.withOpacity(0.3)
                 : Color(0xFF8A79D6),
             offset: Offset(1, 1),
             blurRadius: 1,
             spreadRadius: 1,
           ),
         ],
       ),
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 5),
         child: CommonText(
           title: title,
           fSize: 14,
           fWeight: FontWeight.w500,
           color: isSelected ? Colors.black : Colors.white,
         ),
       ),
     );
   }
}
