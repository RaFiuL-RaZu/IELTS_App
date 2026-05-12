


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/HomeModel/notify_model.dart';

class NotifyController extends GetxController{

  NotifyModel notifyModel=NotifyModel();
  RxBool isLoading=false.obs;

  RxList<NotifyModel> notifyList=<NotifyModel>[].obs;

  Future<void> getNotify()async{

    isLoading(true);

    try{
      
      Map<String,String> header={
        'token':PrefsHelper.token
      };
      
      final response= await ApiService.getApi(AppUrl.getNotify,header: header);
      if(response.statusCode==200 || response.statusCode==201){
        final data=response.body['data']['notification'];
        notifyList.value=List<NotifyModel>.from(data.map((e)=>NotifyModel.fromJson(e)));

      }
    }catch(e,s){
      debugPrint("Error Handling : $e");
      debugPrint("SnackTrack Error : $s");
    }finally{
      isLoading(false);
    }
  }
}