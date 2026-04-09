import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../core/widgets/coomon_button.dart';
import '../../controller/AuditionController/audition_controller.dart';

class AuditionScreen extends StatelessWidget {
  AuditionScreen({super.key});

  final AuditionController controller=Get.put(AuditionController());
  Color getStatusColor(String action) {
    switch (action.toLowerCase()) {
      case "callback":
        return const Color(0xFFFEF9C2);
      case "rejected":
        return const Color(0xFFFFE2E2);
      case "submitted":
        return const Color(0xFFDBEAFE);
      default:
        return const Color(0xFFFEF9C2);
    }
  }
  Color getStatusText(String action) {
    switch (action.toLowerCase()) {
      case "callback":
        return const Color(0xFFA65F00);
      case "rejected":
        return const Color(0xFFE7000B);
      case "submitted":
        return const Color(0xFF155DFC);
      default:
        return const Color(0xFF155DFC);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h,),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: CommonText(title: "Auditions",fSize: 22,fWeight: FontWeight.w700,color: AppColor.primary,),
                trailing: GestureDetector(
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
                            height: 660.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFFFE2E2)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       CommonText(title: "New Audition",fSize: 18,fWeight: FontWeight.w700,color: AppColor.primary,),
                                       IconButton(onPressed: (){
                                         Get.back();
                                       }, icon: Icon(Icons.close,color: AppColor.primary,size: 24,)),
                                     ],
                                   ),
                                    SizedBox(height: 12.h),
                                    SizedBox(height: 7.h),
                                    CommonText(
                                      title: "Project Name",
                                      fSize: 16,
                                      fWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                    SizedBox(height: 10.h),
                                    CommonTextField(title: "e.g. Disney Animation",),
                                    SizedBox(height: 10.h),
                                    CommonText(
                                      title: "Role Name",
                                      fSize: 16,
                                      fWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                    SizedBox(height: 10.h),
                                    CommonTextField(title: "e.g. Hero Character",),
                                    SizedBox(height: 10.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                title: "Date",
                                                fSize: 16,
                                                fWeight: FontWeight.w600,
                                                color: AppColor.primary,
                                              ),
                                              SizedBox(height: 10.h),
                                              Obx(() => CommonTextField(
                                                readOnly: true,
                                                onTap: () => controller.pickDate(context),
                                                title: controller.selectedDate.value,
                                                prefixIcon: const Icon(
                                                  Icons.calendar_month,
                                                  color: Color(0xFF99A1AF),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                title: "Status",
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
                                                      onTap: controller.toggleCallbackDropdown,
                                                      title: controller.selectedCallback.value.isEmpty
                                                          ? "Call back"
                                                          : controller.selectedCallback.value,
                                                      sIcon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Color(0xFF99A1AF),
                                                      ),
                                                    ),
                                                  if (controller.isCallbackDropdownOpen.value)
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 5),
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(color: Colors.grey.shade300),
                                                      ),
                                                      child: Column(
                                                        children: controller.callbackList.map((item) {
                                                          return GestureDetector(
                                                            onTap: () => controller.selectCallback(item),
                                                            child: Container(
                                                              width: double.infinity,
                                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                                              child: Text(item),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),

                                                ],
                                              ))
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    CommonText(
                                      title: "Audio File",
                                      fSize: 16,
                                      fWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                    SizedBox(height: 10.h,),
                                    Container(
                                      height: 153.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFF99A1AF)),
                                        borderRadius: BorderRadius.circular(16)
                                      ),child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 5,
                                      children: [

                                        Container(
                                          height: 48.h,
                                          width: 48.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Color(0xFFE5E2FD),
                                          ),
                                          child: Center(
                                            child: Image.asset(AppIcons.upload,height: 24,width: 24,fit: BoxFit.fill,),
                                          ),
                                        ),
                                        CommonText(title: "Select Audio File",fSize: 14,fWeight: FontWeight.w500,color: AppColor.primary,),
                                        CommonText(title: "MP3, WAV up to 10MB",fSize: 12,fWeight: FontWeight.w400,color: Color(0xFF99A1AF),),
                                      ],
                                    ),
                                    ),
                                    SizedBox(height: 16.h,),
                                    CommonButton(titleText: "Save Audition"),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                          ),
                        ]
                    ),child:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child: Icon(Icons.add,color: Colors.white,size: 18,)),
                  ),
                  ),
                ),
              ),
              SizedBox(height: 12.h,),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Color(0xFFEDEBFF), Color(0xFFF7F6FF)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                      children: [
                       Image.asset(AppIcons.progress,height: 16.h,width: 16.w,),
                        SizedBox(width: 8),
                        Text(
                          "MONTHLY ACTIVITY",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 180,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,

                        primaryXAxis: NumericAxis(
                          minimum: 1,
                          maximum: 12,
                          interval: 1,
                          majorGridLines:
                          const MajorGridLines(width: 0),
                          axisLine: const AxisLine(width: 0),
                        ),

                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 40,
                          interval: 10,
                          axisLine: const AxisLine(width: 0),
                          majorTickLines:
                          const MajorTickLines(size: 0),
                          majorGridLines: MajorGridLines(
                            width: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),

                        tooltipBehavior:
                        TooltipBehavior(enable: true),

                        series: [
                          SplineAreaSeries<ChartData, int>(
                            dataSource: controller.chartData,
                            xValueMapper: (d, _) => d.x,
                            yValueMapper: (d, _) => d.y,
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.withOpacity(0.4),
                                Colors.deepPurple.withOpacity(0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),

                          /// LINE
                          SplineSeries<ChartData, int>(
                            dataSource: controller.chartData,
                            xValueMapper: (d, _) => d.x,
                            yValueMapper: (d, _) => d.y,
                            color: Colors.deepPurple,
                            width: 3,
                          ),
                        ],

                        /// VERTICAL LINE
                        annotations: [
                          CartesianChartAnnotation(
                            widget: Container(
                              width: 1,
                              height: double.infinity,
                              color: Colors.grey,
                            ),
                            coordinateUnit: CoordinateUnit.point,
                            x: 10,
                            y: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              Row(
               spacing: 20,
               children: [
                 Expanded(
                   child: Container(
                     padding: EdgeInsets.symmetric(vertical: 14,horizontal: 15),
                     width: double.infinity,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(24),
                       gradient: LinearGradient(
                         colors: [
                           Colors.white,
                           Color(0x4D6C4DFF),
                         ],
                         begin: Alignment.topLeft,
                         end: Alignment.center,
                       ),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Image.asset(AppIcons.round,height: 16.h,width: 16.w,),
                             SizedBox(width: 8),
                             Text(
                               " Book Ratio",
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w700,
                                 color: Color(0xFF6A7282),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 7.h),
                         CommonText(
                           title: "18%",
                           fSize: 24,
                           fWeight: FontWeight.w800,
                           color: AppColor.primary,
                         ),
                         SizedBox(height: 10.h),
                         CommonText(
                           title: "2% this month",
                           fSize: 12,
                           fWeight: FontWeight.w500,
                           color: Color(0xFF00C950),
                         ),
                         SizedBox(height: 10.h),

                       ],
                     ),
                   ),
                 ),
                 Expanded(
                   child: Container(
                     padding: EdgeInsets.symmetric(vertical: 14,horizontal: 15),
                     width: double.infinity,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(24),
                       gradient: LinearGradient(
                         colors: [
                           Colors.white,
                           Color(0x4DF0B100)
                         ],
                         begin: Alignment.topLeft,
                         end: Alignment.center,
                       ),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Image.asset(AppIcons.docs,height: 16.h,width: 16.w,),
                             SizedBox(width: 8),
                             Text(
                               "Callbacks",
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w700,
                                 color: Color(0xFF6A7282),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 7.h),
                         CommonText(
                           title: "12",
                           fSize: 24,
                           fWeight: FontWeight.w800,
                           color: AppColor.primary,
                         ),
                         SizedBox(height: 10.h),
                         CommonText(
                           title: "out of 45 subs",
                           fSize: 12,
                           fWeight: FontWeight.w500,
                           color: AppColor.secondary,
                         ),
                         SizedBox(height: 10.h),

                       ],
                     ),
                   ),
                 ),
               ],
             ),
              SizedBox(height: 12.h,),
              Row(
                children: [
                  Image.asset(AppIcons.history,height: 20.h,width: 20.w,),
                  SizedBox(width: 8),
                  Text(
                    " History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h,),
              ListView.builder(
                itemCount: controller.historyList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final list = controller.historyList[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            title: list["title"] ?? "",
                            fSize: 16,
                            fWeight: FontWeight.w700,
                            color: AppColor.primary,
                          ),
                          SizedBox(height: 4.h),
                          CommonText(
                            title: "Narrator • Jun 08, 2026",
                            fSize: 12,
                            fWeight: FontWeight.w500,
                            color: AppColor.secondary,
                          ),
                        ],
                      ),

                      trailing: Container(
                        height: 24.h,
                        width: 93.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:getStatusColor(list["action"] ?? ""),
                        ),
                        child: Center(
                          child: CommonText(
                            title: list["action"] ?? "",
                            fSize: 12,
                            fWeight: FontWeight.w700,
                            color: getStatusText(list["action"] ?? ""),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )



            ],
          ),
        ),
      ),
    );
  }
}