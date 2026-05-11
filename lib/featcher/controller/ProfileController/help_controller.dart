

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/featcher/model/ProfileModel/help_model.dart';

import '../../../core/constant/prefs_helper.dart';
import '../../../core/services/api_services.dart';
import '../../../core/utils/app_urls.dart';

class HelpController extends GetxController{



  RxBool isLoading=false.obs;

  Rx<HelpModel> helpModel = HelpModel().obs;


  Future<void> getHelp()async{

    isLoading(true);

    try{

      Map<String,String> header={
        'token':PrefsHelper.token
      };

      final response=await ApiService.getApi(AppUrl.getHelp,header: header);

      if(response.statusCode==200 || response.statusCode==201){
        final data=response.body['data'];
        helpModel.value=HelpModel.fromJson(data);

      }

    }catch(e,s){
      debugPrint("Error Handling :$e");
      debugPrint("SnackTrack Error :$e");
    }finally{
      isLoading(false);
    }


  }

}