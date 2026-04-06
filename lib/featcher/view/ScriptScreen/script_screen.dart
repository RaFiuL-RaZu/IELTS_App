import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/ScriptController/script_controller.dart';

import '../../../core/utils/app_image.dart';
import '../../../core/widgets/commom_image.dart';

class ScriptScreen extends StatelessWidget {
  ScriptScreen({super.key});

  final ScriptController controller = Get.put(ScriptController());

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
                title: "Scripts",
                fSize: 22,
                fWeight: FontWeight.w800,
                color: AppColor.primary,
              ),
              SizedBox(height: 16.h),
              Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFD2CBFA),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Row(
                    children: [
                      _tabButton("Library", 0, AppIcons.book),
                      _tabButton("Script Generator", 1, AppIcons.star),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Obx(() {
                return controller.selectedIndex.value == 0
                    ? Column(
                        children: [
                          CommonTextField(
                            title: "Search scripts...",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 14,
                              ),
                              child: Image.asset(
                                AppIcons.search,
                                height: 16,
                                width: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          Obx(
                            () => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 10,
                                children: [
                                  ...List.generate(controller.items.length, (
                                    index,
                                  ) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectItem(index);
                                      },
                                      child: voiceBox(
                                        title: controller.items[index],
                                        isSelected:
                                            controller.selectedTab.value == index,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: 3,
                              itemBuilder: (context,index){
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              margin: EdgeInsets.only(bottom: 16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24.h,
                                      width: 93.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFE5E2FD),
                                      ),
                                      child: Center(
                                        child: CommonText(
                                          title: "Commercial",
                                          fSize: 12,
                                          fWeight: FontWeight.w500,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 7.h),
                                    CommonText(
                                      title: "Nike - Limitless",
                                      fSize: 16,
                                      fWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                    SizedBox(height: 10.h),
                                    CommonText(
                                      title: "Some people say the sky is the limit. But what if you don't even believe in the sky? What if...",
                                      fSize: 14,
                                      fWeight: FontWeight.w400,
                                      color: AppColor.secondary,
                                    ),
                                    SizedBox(height: 10.h),
                                    CommonButton(titleText: " Practice",prefixIcon: Image.asset(AppIcons.video,height: 23,width: 23,),)

                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      )
                    : SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String text, int index, String image) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(index);
        },
        child: Obx(() {
          bool isSelected = controller.selectedIndex.value == index;

          return Container(
            height: 36.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF180E27), Color(0xFF56397C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 18,
                  width: 18,
                  fit: BoxFit.fill,
                  color: isSelected ? Colors.white : AppColor.secondary,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColor.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Container voiceBox({required String title, required bool isSelected}) {
    return Container(
      height: 34.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isSelected
              ? [Color(0xFF180E27), Color(0xFF56397C)]
              : [Colors.white, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.white.withOpacity(0.3)
                : Color(0xFF8A79D6),
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: CommonText(
            title: title,
            fSize: 14,
            fWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
