

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/ProfileModel/my_profile_model.dart';

import '../../../core/widgets/common_snackber.dart';
import '../../model/ProfileModel/block_user_model.dart';

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
    "Speaking",
    "Writing",
    "Listening",
    "Reading",
    "Cue Cards",
    "Vocabulary",
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
      profileModel.value = ProfileModel(
        id: PrefsHelper.userId.isEmpty ? "user_default" : PrefsHelper.userId,
        fullName: PrefsHelper.myName.isEmpty ? "IELTS Candidate" : PrefsHelper.myName,
        email: PrefsHelper.myEmail.isEmpty ? "candidate@ieltsmaster.app" : PrefsHelper.myEmail,
        profileImage: PrefsHelper.myImage,
        about: bioController.text.isNotEmpty ? bioController.text : "Aiming for IELTS Band 7.5+ in Academic & General Training.",
        voiceSpecialties: selectedValues.isNotEmpty ? selectedValues : ["Speaking", "Cue Cards", "Vocabulary"],
      );

      nameController.text = profileModel.value.fullName ?? "";
      bioController.text = profileModel.value.about ?? "";
      setInitialValues();
    } catch (e) {
      debugPrint("Local Profile Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 300));

      final newName = nameController.text.trim();
      final newBio = bioController.text.trim();

      if (newName.isNotEmpty) {
        PrefsHelper.myName = newName;
        await PrefsHelper.setString("myName", newName);
      }

      if (selectedImage.value.isNotEmpty) {
        PrefsHelper.myImage = selectedImage.value;
        await PrefsHelper.setString("myImage", selectedImage.value);
      }

      profileModel.value = ProfileModel(
        id: PrefsHelper.userId,
        fullName: PrefsHelper.myName,
        email: PrefsHelper.myEmail,
        profileImage: PrefsHelper.myImage,
        about: newBio,
        voiceSpecialties: selectedValues.map((e) => e.toString()).toList(),
      );

      Get.back();
      CommonSnackBar.show(
        title: "Success",
        message: "Profile updated successfully",
        isSuccess: true,
      );
    } catch (e) {
      debugPrint("Update Profile Error: $e");
    } finally {
      isLoading(false);
    }
  }

  final RxList<BlockUser> blockList = <BlockUser>[].obs;

  Future<void> userBlock() async {
    isLoading(false);
  }

  Future<void> unblockUser({required String id}) async {
    blockList.removeWhere((e) => e.id == id);
    Get.snackbar(
      "Success",
      "User unblocked successfully.",
      snackPosition: SnackPosition.TOP,
    );
  }
}