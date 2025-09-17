import 'package:eduline/app/modules/user_profile/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class Profile extends StatelessWidget {
   Profile({super.key});
   final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user profile "),
      ),
      body: Obx((() {
        if(controller.isLoading.value){
          return Center( child:  CircularProgressIndicator(),);
        }else if(controller.userModel.value == null){
          return Center(child: Text("No data found"),);
        }else{
          final data = controller.userModel.value;
          return Column(
            children: [
              Text("${data.email}"),
              Text("${data.name??""}"),

            ],
          );
        }


        }
      ),
    )
    );
  }
}
