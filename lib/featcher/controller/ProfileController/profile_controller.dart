

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/ProfileModel/my_profile_model.dart';

import '../../../core/widgets/common_snackber.dart';

class ProfileController extends GetxController {


  RxList<int> selectedIndexes = <int>[].obs;
  RxList<String> selectedValues = <String>[].obs;

  RxBool isChecked = false.obs;

  void toggleItem(String value) {
    if (selectedValues.contains(value)) {
      selectedValues.remove(value);
    } else {
      selectedValues.add(value);
    }
  }

  final ImagePicker picker = ImagePicker();

  RxString selectedImage = "".obs;

  Future pickImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = image.path;
    }
  }

  List<String> items = [
    "Commercial",
    "Animation ",
    "Video Game ",
    "Narration ",
    "Character ",
    "E-Learning ",
  ];

  void setInitialValues() {
    final apiList = profileModel.value.voiceSpecialties ?? [];

    selectedValues.value =
        apiList.map((e) => e.toString().trim()).toList();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  RxBool isLoading = false.obs;

  Rx<ProfileModel> profileModel = ProfileModel.fromJson({}).obs;

  Future<void> getMyProfile() async {
    isLoading(true);

    try {

      Map<String,String> header={
        "token":PrefsHelper.token
      };

      final response=await ApiService.getApi(AppUrl.myProfile,header: header,);
      if(response.statusCode==200 || response.statusCode==201){
        final data=response.body['data'];
        profileModel.value=ProfileModel.fromJson(data);
        setInitialValues();
      }


    } catch (e, s) {
      debugPrint("Error Handling: $e");
      debugPrint("SnackTrack Error: $s");
    }finally{
      isLoading(false);
    }
  }


  Future<void> updateProfile() async {
    try {
      isLoading(true);

      debugPrint("COMPLETE PROFILE API");

      var body = {
        "data": jsonEncode({
          "about": bioController.text.trim(),
          "fullName":nameController.text.trim(),
          "voiceSpecialties": selectedValues
              .map((e) => e.toString().trim())
              .toList(),
        })
      };

      final header = {
        "token": PrefsHelper.token,
        'Content-Type': 'application/json',
      };

      debugPrint("BODY: $body");
      debugPrint("IMAGE: ${selectedImage.value}");

      final response = await ApiService.multipartRequest(
        url: AppUrl.updateProfile,
        body: body,
        header: header,
        method: "PATCH",
        imageName: "image",
        imagePaths: selectedImage.value,
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");
      debugPrint("bodyImage: $selectedImage");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        await getMyProfile();
        PrefsHelper.myName=profileModel.value.fullName.toString();
        CommonSnackBar.show(
          title: "Success",
          message: "Profile update successfully",
          isSuccess: true,
        );
      } else {
        debugPrint("❌ API ERROR: ${response.message}");
        CommonSnackBar.show(
          title: "Error",
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (e, s) {
      debugPrint("❌ ERROR: $e");
      debugPrint("STACK: $s");

      CommonSnackBar.show(
        title: "Error",
        message: "Something went wrong",
        isSuccess: false,
      );
    } finally {
      isLoading(false);
    }
  }
}