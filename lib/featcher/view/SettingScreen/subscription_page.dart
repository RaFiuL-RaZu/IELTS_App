import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_icons.dart';
import 'package:justtsham/featcher/controller/ProfileController/subscription_contoller.dart';
import 'package:justtsham/featcher/model/ProfileModel/subscription_model.dart';
import '../../../core/widgets/common_text.dart';
import '../../../core/widgets/coomon_button.dart';

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final SubscriptionController controller = Get.put(SubscriptionController());

  @override
  void initState() {
    controller.getSubscription();
    controller.getMyPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Subscription",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),


              Obx((){
              if(controller.isLoading.value){
                return Center(child: CircularProgressIndicator(color: AppColor.primary,),);
              }else if(controller.subList.isEmpty){
                return Center(child: CommonText(title: "No Data Found"),);
              }else{
                return ListView.builder(
                    itemCount: controller.subList.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context,index){
                      SubscriptionModel subData=controller.subList[index];
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: subData.title=="free" ? Colors.white :
                                  subData.title=="premium" ? AppColor.primary :
                                  Color(0xFF000000)
                              ,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${subData.title!.toUpperCase()} Plan",
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: subData.title=="free" ? Colors.black : Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    CommonText(
                                      title:
                                      subData.description.toString(),
                                      fSize: 14,
                                      fWeight: FontWeight.w500,
                                      color:subData.title=="free" ? Colors.black : Color(0XCCFFFFFF),
                                    ),

                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        CommonText(
                                          title: "\$${subData.price}",
                                          fSize: 30,
                                          fWeight: FontWeight.w800,
                                          color: subData.title=="free" ? Colors.black : Colors.white,
                                        ),
                                        CommonText(
                                          title: "/month",
                                          fSize: 16,
                                          fWeight: FontWeight.w500,
                                          color: subData.title=="free" ? Color(0xFF717182) : Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30.h),
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: subData.features.length,
                                      itemBuilder: (context, i) {
                                       final fetcher=subData.features[i];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            spacing: 5,
                                            children: [
                                              Container(
                                                height: 20.h,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:subData.title=="free" ? AppColor.background:
                                                      subData.title=="pro" ? Color(0x33FFFFFF)
                                                      :
                                                  Color(0x33FFFFFF),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: subData.title=="free" ? Image.asset(
                                                    AppIcons.flag,
                                                    height: 14,
                                                    width: 14,
                                                    fit: BoxFit.fill,
                                                    color: Color(0xFF717182),
                                                  ): subData.title=='pro' ? Image.asset(
                                                    AppIcons.crown,
                                                    height: 14,
                                                    width: 14,
                                                    fit: BoxFit.fill,
                                                    color: Colors.orangeAccent,
                                                  ): Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: subData.title=="free" ? Colors.black : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: CommonText(
                                                  title: fetcher,
                                                  fSize: 14,
                                                  color: subData.title=="free" ? Colors.black : Colors.white,
                                                  fWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                    subData.title == 'pro'
                                        ? Obx(()=>CommonButton(
                                      titleText: controller.myPlanModel.value.subscriptionType == subData.title
                                          ? "Current Plan"
                                          : "Upgrade to Premium",
                                      buttonHeight: 50.h,
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFDC700), Color(0xFFFE9A00)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderColor: AppColor.secondary,
                                      titleColor: Color(0xFF733E0A),
                                      useGradient: true,
                                      onTap: () {
                                        controller.selectPlan(subData.id.toString());
                                        controller.getPayment();
                                      },
                                    ))
                                        : Obx(()=>CommonButton(
                                      titleText: controller.myPlanModel.value.subscriptionType == subData.title
                                          ? "Current Plan"
                                          : subData.title == "free"
                                          ? "Free Plan"
                                          : "Upgrade to Pro",
                                      buttonHeight: 50.h,
                                      backgroundColor: Colors.white,
                                      borderColor: AppColor.secondary,
                                      titleColor: subData.title == 'free'
                                          ? AppColor.secondary
                                          : AppColor.primary,
                                      useGradient: false,
                                      onTap: () {
                                        controller.selectPlan(subData.id.toString());
                                        controller.getPayment();
                                      },
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),

                         subData.title=="premium" ?  Positioned(
                           right: 0,
                           top: 0,
                           child: Container(
                             height: 26.h,
                             width: 118.w,
                             decoration: BoxDecoration(
                               color: Color(0xFFFDC700),
                               borderRadius: BorderRadius.only(
                                 topRight: Radius.circular(20),
                                 bottomLeft: Radius.circular(20),
                               ),
                             ),child:Center(child: CommonText(title: "Most Popular",fSize: 10,fWeight: FontWeight.w800,color: Colors.black,)),
                           ),
                         ) : SizedBox(),
                        ],
                      );
                    });
              }
            }),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
