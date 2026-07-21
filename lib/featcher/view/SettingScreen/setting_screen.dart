import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/widgets/commom_image.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/ProfileController/profile_controller.dart';
import 'package:justtsham/featcher/view/SettingScreen/privacy_screen.dart';
import 'package:justtsham/featcher/view/SettingScreen/save_audition.dart';
// import 'package:justtsham/featcher/view/SettingScreen/subscription_page.dart'; // subscription tab hidden
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/featcher/view/SettingScreen/terms_conditions.dart';
import 'package:justtsham/featcher/view/authentication/Login_screen.dart';
import '../../../core/widgets/common_text.dart';
import 'edit_profile.dart';
import 'help_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final ProfileController controller=Get.put(ProfileController());

  @override
  void initState() {
    controller.getMyProfile();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              CommonText(
                title: "Settings",
                fSize: 22,
                fWeight: FontWeight.w800,
                color: AppColor.primary,
              ),
              SizedBox(height: 12.h),
             Obx((){
               if(controller.isLoading.value){
                 return Center(child: CircularProgressIndicator(color: AppColor.primary,),);
               }else if(controller.profileModel==""){
                 return Center(child: CommonText(title: "No Data Found"),);

               }else{
                 final profile=controller.profileModel;
                 return  Container(
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     gradient: LinearGradient(
                       colors: [Color(0xFF180E27), Color(0xFF56397C)],
                       begin: Alignment.centerLeft,
                       end: Alignment.centerRight,
                     ),

                     boxShadow: [
                       BoxShadow(
                         color: Color(0xFF6C4DFF).withOpacity(0.20),
                         offset: Offset(0, 20),
                         blurRadius: 25,
                         spreadRadius: -5,
                       ),
                       BoxShadow(
                         color: Color(0xFF6C4DFF).withOpacity(0.20),
                         offset: Offset(0, 8),
                         blurRadius: 10,
                         spreadRadius: -6,
                       ),
                     ],
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(
                       horizontal: 16,
                       vertical: 16,
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       spacing: 10,
                       children: [
                         Container(
                           height: 70.h,
                           width: 70.w,
                           decoration: BoxDecoration(
                             color: AppColor.background,
                             shape: BoxShape.circle,
                             border: Border.all(
                               color: Color(0xFFB8ABF6),
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
                             clipBehavior: Clip.antiAlias,
                             child: CommonImage(
                               imageSrc: AppUrl.imageUrl + profile.value.profileImage.toString(),
                               imageType: ImageType.network,
                             ),
                           ),
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           spacing: 5,
                           children: [
                             CommonText(
                               title: profile.value.fullName.toString(),
                               fSize: 20,
                               fWeight: FontWeight.w700,
                               color: Colors.white,
                             ),
                             CommonText(
                               title: profile.value.email.toString(),
                               fSize: 14,
                               fWeight: FontWeight.w500,
                               color: AppColor.secondary,
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 );
               }
             }),
              SizedBox(height: 20.h),
              CommonText(
                title: "Account",
                fSize: 14,
                fWeight: FontWeight.w700,
                color: AppColor.secondary,
              ),
              SizedBox(height: 12.h),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => EditProfile());
                        },
                        child: ProfileBox(
                          title: 'Edit Profile',
                          icon: AppIcons.man,
                        ),
                      ),
                      Divider(color: Colors.grey.shade200),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => SaveAudition());
                        },
                        child: ProfileBox(
                          title: 'Saved Audios',
                          icon: AppIcons.fav,
                        ),
                      ),
                      Divider(color: Colors.grey.shade200),
                      // Subscription tab hidden from settings.
                      // GestureDetector(
                      //   behavior: HitTestBehavior.opaque,
                      //   onTap: () {
                      //     Get.to(() => SubscriptionPage());
                      //   },
                      //   child: ProfileBox(
                      //     title: 'Subscription',
                      //     icon: AppIcons.crown,
                      //   ),
                      // ),
                      // Divider(color: Colors.grey.shade200),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => PrivacyScreen());
                        },
                        child: ProfileBox(
                          title: 'Privacy & Security',
                          icon: AppIcons.flag,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              CommonText(
                title: "Support",
                fSize: 14,
                fWeight: FontWeight.w700,
                color: AppColor.secondary,
              ),
              SizedBox(height: 12.h),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => TermsOfUseScreen());
                        },
                        child: ProfileBox(
                          title: 'Terms & Conditions',
                          icon: AppIcons.faq,
                        ),
                      ),
                      Divider(thickness: 1,color: Colors.grey.shade300,),

                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => HelpScreen());
                        },
                        child: ProfileBox(
                          title: 'Help Center',
                          icon: AppIcons.faq,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 108.h),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: 278.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFFFE2E2)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    height: 55.h,
                                    width: 55.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFEF2F2),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Image.asset(
                                          AppIcons.logout,
                                          height: 24.h,
                                          width: 24.w,
                                          color: Colors.red,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                CommonText(
                                  title: "Ready to leave?",
                                  fSize: 20,
                                  fWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 12.h),
                                CommonText(
                                  align: TextAlign.center,
                                  title:
                                      "Are you sure you want to log out of your VO Vault account? You'll need to sign back in to access your auditions.",
                                  fSize: 14,
                                  fWeight: FontWeight.w500,
                                  color: AppColor.secondary,
                                ),
                                SizedBox(height: 12.h,),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: CommonButton(
                                        onTap: (){
                                          Get.back();
                                        },
                                        buttonHeight: 50.h,
                                        titleText: "Cancel",
                                        backgroundColor: Colors.white,
                                        borderColor: Colors.grey.shade400,
                                        useGradient: false,
                                        titleSize: 16,
                                        titleWeight: FontWeight.w700,
                                        titleColor: Color(0XFF4A5565),
                                      ),
                                    ),
                                    Expanded(
                                      child: CommonButton(
                                        onTap: () async {
                                          await PrefsHelper.removeAllPrefData();
                                          Get.offAll(() => LoginScreen());
                                        },
                                        buttonHeight: 50.h,
                                        titleText: "Log Out",
                                        backgroundColor: Color(0XFFE7000B),
                                        useGradient: false,
                                        titleSize: 16,
                                        titleWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppIcons.logout, height: 20.h, width: 20.w),
                        CommonText(
                          title: "Log Out",
                          fSize: 16,
                          fWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row ProfileBox({required String title, required String icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColor.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Image.asset(
                    icon,
                    color: AppColor.primary,
                    height: 20.h,
                    width: 20.w,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            CommonText(
              title: title,
              fSize: 14,
              fWeight: FontWeight.w700,
              color: AppColor.primary,
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: AppColor.secondary),
      ],
    );
  }
}
