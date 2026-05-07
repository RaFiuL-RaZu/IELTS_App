

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justtsham/core/constant/prefs_helper.dart';
import 'package:justtsham/core/services/api_services.dart';
import 'package:justtsham/core/utils/app_urls.dart';
import 'package:justtsham/featcher/model/ProfileModel/subscription_model.dart';

class SubscriptionController extends GetxController{
  List<String> planList = [
    "Track up to 25 auditions",
    "Save up to 20 scripts",
    "5 AI script generations per day",
    "Upload up to 3 demos",
    "Basic analytics",
    "Access to community features",
  ];

  List<String> premiumList = [
    "All Pro features included",
    "Advanced career insights and analytics",
    "Priority visibility in community feed",
    "Featured profile and demo placement",
    "Expanded storage and future advanced tools.",
  ];
  List<String> proList = [
    "Unlimited audition tracking",
    "Unlimited scripts and demo uploads",
    "Unlimited AI script generation",
    "Advanced analytics and performance insights",
    "Full community interaction (comments, likes, following)",
  ];
  
  RxBool isLoading=false.obs;

  RxList subList=[].obs;
  
  Future<void> getSubscription()async{
    
    isLoading(true);
    
    try{
      
      Map<String,String> header={
        'token':PrefsHelper.token
      };
      
      final response=await ApiService.getApi(AppUrl.subscription,header: header);

      if(response.statusCode==200 || response.statusCode==201){

        final data=response.body['data'];
        subList.value =
            data.map((e) => SubscriptionModel.fromJson(e)).toList();

      }
      
    }catch(e,s){
      debugPrint("Error Handling :$e");
      debugPrint("SnackTrack Error :$e");
    }finally{
      isLoading(false);
    }
    
    
  }
}