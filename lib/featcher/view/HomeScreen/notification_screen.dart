import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text.dart';

import '../../../core/utils/app_icons.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
            ListView.builder(
              itemCount: 5,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context,index){
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
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.favorite_border_outlined,color: Colors.red,),
                      ),
                      ),
                      SizedBox(width: 15.w,),
                      Expanded(
                        child: Column(
                          spacing: 3,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(title: "Sarah liked your demo",fSize: 14,fWeight: FontWeight.w700,color: AppColor.primary,),
                            CommonText(title: '"Commercial Reel 2026 "',fSize: 14,fWeight: FontWeight.w500,color: AppColor.secondary,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: CommonText(title: "2m ago",fSize: 10,fWeight: FontWeight.w700,color: AppColor.secondary,),
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
