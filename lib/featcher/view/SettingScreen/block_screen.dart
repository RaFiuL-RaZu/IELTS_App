import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/constant/other_helper.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/widgets/common_text.dart';

import '../../../core/utils/app_urls.dart';
import '../../../core/widgets/commom_image.dart';
import '../../controller/ProfileController/profile_controller.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({super.key});

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  final ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.userBlock();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: CommonText(
          title: "Block User",
          fSize: 22.sp,
          fWeight: FontWeight.w700,
          color: AppColor.primary,
        ),
        centerTitle: true,
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: controller.blockList.length,
                  itemBuilder: (context, index) {
                    final list = controller.blockList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00897B).withOpacity(0.06),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child:ListTile(
                        leading: ClipOval(
                          child: (list.targetUserId!.profileImage?.isNotEmpty ?? false)
                              ? CommonImage(
                            imageSrc:
                            AppUrl.getFullUrl(list.targetUserId!.profileImage),
                            imageType: ImageType.network,
                            height: 50,
                            width: 50,
                            fill: BoxFit.cover,
                          )
                              : Container(
                            height: 50,
                            width: 50,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: CommonText(
                          title: list.targetUserId?.fullName ?? "",
                          fSize: 14.sp,
                          fWeight: FontWeight.w700,
                          color: AppColor.primary,
                        ),
                        subtitle: CommonText(
                          title: OtherHelper.formatDate(list.createdAt?.toString() ?? ""),
                          fSize: 12.sp,
                          fWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            controller.unblockUser(id: list.targetUserId!.id.toString());
                          },
                          child: const Text(
                            "Unblock",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),
            )

          ],
        ),
      )
    );
  }
}
