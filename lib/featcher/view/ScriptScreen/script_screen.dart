import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/core/widgets/common_text_field.dart';
import 'package:justtsham/core/widgets/coomon_button.dart';
import 'package:justtsham/featcher/controller/ScriptController/script_controller.dart';
import 'package:justtsham/featcher/model/ScriptModel/script_model.dart';
import '../CummunityScreen/commercial_screen.dart';

class ScriptScreen extends StatefulWidget {
  const ScriptScreen({super.key});

  @override
  State<ScriptScreen> createState() => _ScriptScreenState();
}

class _ScriptScreenState extends State<ScriptScreen> {
  final ScriptController controller = Get.put(ScriptController());

  @override
  void initState() {
    controller.getScript();

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
                            controller: controller.searchController,
                            title: "Search scripts...",
                            onChanged: (value) {
                              controller.searchScripts(value);
                            },
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
                                        controller.filterScriptsByCategory(index);
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
                         Obx((){
                           if(controller.isLoading.value){
                             return Center(child: CircularProgressIndicator(color: AppColor.primary,),);
                           }else if(controller.scriptList.isEmpty){
                             return Center(child: CommonText(title: "No Data Found"),);
                           }else{
                             return ListView.builder(
                                 padding: EdgeInsets.zero,
                                 shrinkWrap: true,
                                 physics: ScrollPhysics(),
                                 itemCount: controller.filteredScriptList.length,
                                 itemBuilder: (context,index){
                                   ScriptModel script = controller.filteredScriptList[index];
                                   return GestureDetector(
                                     onTap: (){
                                       Get.to(()=>CommercialScreen());
                                     },
                                     child: Container(
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
                                                   title: script.category?? "",
                                                   fSize: 12,
                                                   fWeight: FontWeight.w500,
                                                   color: AppColor.primary,
                                                 ),
                                               ),
                                             ),
                                             SizedBox(height: 7.h),
                                             CommonText(
                                               title: script.title ?? "",
                                               fSize: 16,
                                               fWeight: FontWeight.w600,
                                               color: AppColor.primary,
                                             ),
                                             SizedBox(height: 10.h),
                                             CommonText(
                                               title: script.content ?? "",
                                               fSize: 14,
                                               fWeight: FontWeight.w400,
                                               color: AppColor.secondary,
                                             ),
                                             SizedBox(height: 10.h),
                                             CommonButton(titleText: " Practice",prefixIcon: Image.asset(AppIcons.video,height: 23,width: 23,),)

                                           ],
                                         ),
                                       ),
                                     ),
                                   );
                                 });
                           }
                         })
                        ],
                      )
                    : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         ListTile(
                           contentPadding: EdgeInsets.zero,
                           leading: Container(
                             height: 40.h,
                             width: 40.w,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(14),
                               color: Color(0xFFE5E2FD),
                             ),
                             child: Center(
                               child: Image.asset(AppIcons.star,height: 24,width: 24,fit: BoxFit.fill,),
                             ),
                           ),
                           title: CommonText(title: "Script Writer",fSize: 18,fWeight: FontWeight.w800,color:AppColor.primary,),
                           subtitle: CommonText(title: "Generate custom practice copy",fSize: 12,fWeight: FontWeight.w500,color:AppColor.secondary,),
                         ),
                          SizedBox(height: 7.h),
                          CommonText(
                            title: "Category",
                            fSize: 16,
                            fWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                          SizedBox(height: 10.h),
                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             CommonTextField(
                                  readOnly: true,
                                  onTap:controller.toggleDropdown,
                                  title: controller.selectedCategory.value.isEmpty
                                      ? "Enter your category"
                                      : controller.selectedCategory.value,
                                  sIcon: const Icon(Icons.arrow_drop_down),
                                ),

                              if (controller.isDropdownOpen.value)
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    children: controller.categories.map((item) {
                                      return GestureDetector(
                                        onTap: () => controller.selectCategory(item),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          width: double.infinity,
                                          child: Text(item),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          )),
                          SizedBox(height: 10.h),
                          CommonText(
                            title: "Tone / Style",
                            fSize: 16,
                            fWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                          SizedBox(height: 10.h),
                          Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextField(
                                  readOnly: true,
                                  onTap: controller.toggleToneDropdown,
                                  title: controller.selectedTone.value.isEmpty
                                      ? "Select tone / style"
                                      : controller.selectedTone.value,
                                  sIcon: const Icon(Icons.arrow_drop_down),
                                ),

                              if (controller.isToneDropdownOpen.value)
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    children: controller.toneList.map((tone) {
                                      return GestureDetector(
                                        onTap: () => controller.selectTone(tone),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: Text(
                                            tone,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),

                            ],
                          )),
                          SizedBox(height: 10.h),
                          CommonText(
                            title: "Length",
                            fSize: 16,
                            fWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                          SizedBox(height: 10.h),
                          Obx(
                                () => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 10,
                                children: [
                                  ...List.generate(controller.timeList.length, (
                                      index,
                                      ) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectTimeItem(index);
                                      },
                                      child: voiceBox(
                                        title: controller.timeList[index],
                                        isSelected:
                                        controller.selectedTime.value == index,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          CommonButton(titleText: " Generate Script",),

                        ],
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
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
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                     title: "Generated!",
                                     fSize: 12,
                                     fWeight: FontWeight.w500,
                                     color: AppColor.primary,
                                   ),
                                 ),
                               ),
                               CommonText(title: "15 sec",fSize: 12,fWeight: FontWeight.w500,color: AppColor.primary,),
                             ],
                           ),
                            SizedBox(height: 7.h),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFF1EFFE),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        title:
                                        "Narrator : Some people say the sky is the limit. But what if you don't even believe in the sky?\nWhat if every time they told you to slow down, you just found a new gear?\nIntroducing the all-new experience. Designed for those who don't just follow the path... they create it.\nGet yours today.",
                                        fSize: 16,
                                        color: AppColor.secondary,
                                        fWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(child: CommonButton(titleText: " Practice",prefixIcon: Image.asset(AppIcons.video,height: 23,width: 23,),)),
                                Container(
                                  height: 48.h,
                                  width: 48.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade300)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.copy,color: Colors.grey.shade400,),
                                  ),
                                )

                              ],
                            )

                          ],
                        ),
                      ),
                    )

                  ],
                );
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
        border: isSelected ? Border.all(color:Colors.white) :Border.all(color:  Colors.grey.shade300),
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
