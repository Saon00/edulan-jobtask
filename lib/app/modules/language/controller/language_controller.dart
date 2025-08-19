import 'package:get/get.dart';

class LanguageController extends GetxController {
  var isSelected = true.obs;
  var selectedIndex = 0.obs;

  void currentIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleSelection() {
    isSelected.value = !isSelected.value;
  }
}
