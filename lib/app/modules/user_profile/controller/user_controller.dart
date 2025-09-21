import 'package:eduline/app/core/services/api_services.dart';
import 'package:eduline/app/modules/user_profile/model/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  ApiService _apiService = ApiService();


  @override
  onInit(){
    super.onInit();
    getUserInfo();
  }
  final RxBool isLoading = false.obs;
  final Rx<UserModel> userModel = UserModel().obs;

  Future<bool> getUserInfo()async{
    isLoading.value = true;
    final response = await _apiService.get("http://206.162.244.141:6003/api/v1/users/me");
    if(response != null && response["success"]==true){
      userModel.value = UserModel.fromJson(response["data"]);
      print("user data get success${response}");
      isLoading.value = false;
      return true;

    }else{
      print("user data get false${response}");
      isLoading.value = false;
      return false;
    }
  }
}