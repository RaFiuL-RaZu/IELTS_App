import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_colors.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/core/utils/validator.dart';
import 'package:justtsham/featcher/view/authentication/verify_email.dart';

class SignUpController extends GetxController {

  static SignUpController get instance=>Get.find<SignUpController>();
  RxList<int> selectedIndexes = <int>[].obs;
  RxList<String> selectedValues = <String>[].obs;

  RxBool isChecked = false.obs;

  void toggleItem(int index, String value) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
      selectedValues.remove(value);
    } else {
      selectedIndexes.add(index);
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var accountToken="";

  Future<void> createAccount() async {
    // Validate form using Validator class
    final nameError = Validator.validateName(nameController.text);
    if (nameError != null) {
      Get.snackbar('Validation Error', nameError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    final emailError = Validator.validateEmail(emailController.text);
    if (emailError != null) {
      Get.snackbar('Validation Error', emailError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    final passwordError = Validator.validatePassword(passwordController.text);
    if (passwordError != null) {
      Get.snackbar('Validation Error', passwordError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    final confirmError = Validator.validateConfirmPassword(
      confirmPasswordController.text,
      passwordController.text,
    );
    if (confirmError != null) {
      Get.snackbar('Validation Error', confirmError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    final termsError = Validator.validateTerms(isChecked.value);
    if (termsError != null) {
      Get.snackbar('Validation Error', termsError,
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading(true);

    try {
      Map<String, String> header = {
        "Content-Type": "application/json"
      };
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "fullName": nameController.text.trim(),
        "password": passwordController.text.trim(),
      };
      final response =
          await ApiService.postApi(AppUrl.createAccount, header: header, body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        accountToken=response.body['data'];
        Get.snackbar('Success', response.message,
            snackPosition: SnackPosition.TOP,backgroundColor: AppColor.primary);
        Get.to(()=>VerifyEmail());
      } else {
        Get.snackbar('Error', response.message, snackPosition: SnackPosition.TOP);
      }
    } catch (e, s) {
      debugPrint("Error $e");
      debugPrint("Stack trace $s");
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }
}