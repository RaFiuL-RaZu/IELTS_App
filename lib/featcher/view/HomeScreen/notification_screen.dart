import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/constant/other_helper.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text.dart';
import 'package:justtsham/featcher/controller/HomeController/notify_controller.dart';

import '../../../core/utils/app_icons.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  final NotifyController controller=Get.put(NotifyController());
  @override
  void initState() {
   controller.getNotify();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(title: "Notifications",fSize: 22,fWeight: FontWeight.w700,color: AppColor.primary,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx((){
              if(controller.isLoading.value){
                return Center(child: CircularProgressIndicator(color: AppColor.primary,),);
              }else if(controller.notifyList.isEmpty){
                return Center(child: CommonText(title: "No Data Found"),);
              }else{
                return ListView.builder(
                    itemCount: controller.notifyList.length,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      final notify=controller.notifyList[index];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        // margin: EdgeInsets.only(bottom: 10),
                        // color: Color(0xFFD2CBFA),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 48.h,
                                width: 48.w,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFE2E2),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 3,
                                      ),
                                    ]
                                ),child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.notifications,color: AppColor.primary,),
                              ),
                              ),
                              SizedBox(width: 15.w,),
                              Expanded(
                                child: Column(
                                  spacing: 3,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(title: notify.message!.title ?? "",fSize: 14,fWeight: FontWeight.w700,color: AppColor.primary,),
                                    CommonText(title: '"${notify.message!.body}"',fSize: 14,fWeight: FontWeight.w500,color: AppColor.secondary,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: CommonText(title: OtherHelper.timeAgo(notify.createdAt.toString()),fSize: 10,fWeight: FontWeight.w700,color: AppColor.secondary,),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            })
          ],
        ),
      ),
    );
  }
}
